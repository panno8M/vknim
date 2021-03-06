{.experimental: "strictFuncs".}

import strutils
import os
import sequtils
import sugar
import strformat
import options
import algorithm
import xmltree
import tables
import logging
import times

import ./utils
import ./nodedefs
import ./liblogger
import ./defineTypeComponents

type UnexpectedXmlStructureError* = object of CatchableError
template xmlError*(title: Title; strs: varargs[string, `$`]): untyped =
  raise UnexpectedXmlStructureError.newException(logMsg(title, strs))
func invalidStructure*(at: string): Title =
    title("@" & at & " > invalid structure")
func cmp(a, b: NodeEnumVal): int =
  case a.kind
    of nkeValue:
      case b.kind
      of nkeValue:  cmp(a.value, b.value)
      of nkeBitpos: cmp(a.value, 1.shl(b.bitpos))
    of nkeBitpos:
      case b.kind
      of nkeValue:  cmp(1.shl(a.bitpos), b.value)
      of nkeBitpos: cmp(1.shl(a.bitpos), 1.shl(b.bitpos))

# SECTION renderers

proc render*(enumVal: NodeEnumVal; vendorTags: VendorTags; enumsName: string): string =
  let name = enumVal.name.parseEnumValue(enumsName, vendorTags)
  if enumVal.isExtended:
    result.add "# Provided by {enumVal.providedBy}\n".fmt

  result.add case enumVal.kind
    of nkeValue:
      if enumVal.isHex: "{name} = 0x{enumVal.value.toHex(8)}".fmt
      else: "{name} = {enumVal.value}".fmt
    of nkeBitpos:
      "{name} = 0x{1.shl(enumVal.bitpos).toHex(8)}".fmt

  if enumVal.comment.isSome:
    result.add " # " & enumVal.comment.get

proc render*(enums: NodeEnum; vendorTags: VendorTags): string =
  let name = enums.name.removeVkPrefix

  if enums.comment.isSome:
    result = "# {enums.comment.get}\n".fmt

  if enums.enumVals.len == 0:
    return result & "{name}* = distinct UnusedEnum".fmt

  result.add "{name}* {enumPragma} = enum\n".fmt
  result.add enums.enumVals
    .sorted(cmp)
    .mapIt(it.render(vendorTags, name).indent(2))
    .join("\n")

proc render*(enumAlias: NodeEnumAlias; vendorTags: VendorTags; enumName: string): string =
  let name = enumAlias.name.parseEnumValue(enumName, vendorTags)
  let alias = enumAlias.alias.parseEnumValue(enumName, vendorTags)
  if enumAlias.isExtended:
    result.add "# Provided by {enumAlias.providedBy}\n".fmt
  result.add "{alias} as {name}".fmt
  if enumAlias.comment.isSome:
    result.add " # " & enumAlias.comment.get
proc render*(enumAliases: NodeEnumAliases; vendorTags: VendorTags): string =
  if enumAliases.aliases.len == 0: return
  let name = enumAliases.name.removeVkPrefix
  result.add "{name}.defineAliases:\n".fmt
  for alias in enumAliases.aliases:
    result.add alias.render(vendorTags, name).indent(2) & "\n"


proc render*(cons: NodeConst): string =
  let name = cons.name.parseVariableNameFromSnake
  let value = case name
    of "True", "False": "Bool32({cons.value})".fmt
    else: cons.value
  result = "{name}* = {value}".fmt
  if cons.comment.isSome:
    result.add " # " & cons.comment.get

proc render*(consAlias: NodeConstAlias): string =
  let name = consAlias.name.parseVariableNameFromSnake
  let alias = consAlias.alias.parseVariableNameFromSnake
  result = "{name}* = {alias}".fmt
  if consAlias.comment.isSome:
    result.add " # " & consAlias.comment.get

proc render*(funcPtr: NodeFuncPtr): string =
  let name = funcPtr.name.parseTypeName
  let theType = funcPtr.theType.parseTypeName(funcPtr.ptrLv)
  result &= "{name}* = proc(".fmt
  let args = funcPtr.args
    .map( proc(arg: tuple[name, theType: string, ptrLv: Natural]): string =
      result = arg.name.parseParamName & ": "
      let theType = arg.theType.replaceBasicTypes
      result.add ("ptr ".repeat(arg.ptrLv) & theType).replacePtrTypes
      result &= ";"
    )
  if args.len != 0:
    result &= "\n" & args.join("\n").indent(4) & "\n  "
  result &= "): {theType} ".fmt & "{.cdecl.}"

proc render*(define: NodeDefine): string = define.str

proc render*(struct: Nodestruct): string =
  if struct.comment.isSome:
    result &= struct.comment.get.commentify.LF
  let name = struct.name.removeVkPrefix

  result.add case struct.isUnion
    of true: "{name}* {{.union.}} = object".fmt
    of false: "{name}* = object".fmt

  let members = struct.members.mapIt(block:
    let
      theType =
        case it.arrayStyle
        of nasPtr: it.theType.parseTypeName(ptrLen= it.ptrLen)
        of nasFix: it.theType.parseTypeName(dim= it.dim)
        of nasNotArray: it.theType.parseTypeName(ptrLv= it.ptrLv)
      name = it.name.parseParamName
      pragmas =
        ( if it.optional: @["optional"]
          elif it.values.isSome:
            let value = it.values.get.parseEnumValue("vkStructureType", @[])
            @[&"constant: (StructureType.{value})"]
          else: newSeq[string]()
        ).concat(
          if it.arrayStyle == nasPtr:
            let annotated = it.ptrLen.filterIt(it.isSome)
            if annotated.len != 0:
              @["length: " & annotated.mapIt(it.get).join(", ")]
            else: newSeq[string]()
          else: newSeq[string]()
        )
    if pragmas.len != 0:
      "  {name}* {{.{pragmas.join(\", \")}.}}: {theType}".fmt
    else:
      "  {name}*: {theType}".fmt
  )
  if members.len != 0:
    result.LF
    result &= members.join("\n")

proc render*(bitmask: NodeBitmask): string =
  let name = bitmask.name.replaceBasicTypes
  case bitmask.kind
  of nkbrNormal:
    if bitmask.flagbitsReq.isSome:
      "{name}* = Flags[{bitmask.flagbitsReq.get.removeVkPrefix}]".fmt
    else:
      "{name}* = Flags[distinct UnusedEnum]".fmt
  of nkbrAlias:
    let alias = bitmask.alias.replaceBasicTypes
    "{name}* = {alias}".fmt


proc render*(handle: NodeHandle): string =
  let name = handle.name.replaceBasicTypes
  case handle.kind
  of nkbrNormal:
    case handle.handleKind
    of HandleKind.Handle:
      "Ht{name}* = object of HandleType\n".fmt &
      "{name}* = Handle[Ht{name}]".fmt
    of HandleKind.NonDispatchableHandle:
      "Ht{name}* = object of HandleType\n".fmt &
      "{name}* = NonDispatchableHandle[Ht{name}]".fmt
  of nkbrAlias:
    let alias = handle.alias.replaceBasicTypes
    "{name}* = {alias}".fmt

proc render*(command: NodeCommand): string =
  let name = command.name.parseCommandName
  # let name = command.name
  case command.kind
  of nkbrNormal:
    let theType = command.theType.parseTypeName
    let procHeader = "proc {name}*(".fmt
    let procParams = command.params
      .mapIt( block:
        let name = it.name.parseParamName
        let theType = case it.arrayStyle
          of nasNotArray: it.theType.parseTypeName(it.ptrLv)
          of nasPtr: it.theType.parseTypeName(it.ptrLen)
          else: raiseAssert "arrayStyle must be NotArray or Ptr"
        let lengthAnno =
          if it.arrayStyle != nasPtr or it.ptrLen.allIt(it.isNone): ""
          else:
            let lengthAnno = it.ptrLen.filterIt(it.isSome).mapIt(it.get.replace("->", ".")).join(", ")
            " {{.length: {lengthAnno}.}}".fmt
        if it.optional:
          "      {name}{lengthAnno} = default({theType});".fmt
        else:
          "      {name}{lengthAnno}: {theType};".fmt)
    let loadMethod = case command.loadMode
      of lmPreload: "preload(\"{command.name}\")".fmt
      of lmWithInstance: "lazyload(\"{command.name}\", InstanceLevel)".fmt
      of lmWithDevice: "lazyload(\"{command.name}\", DeviceLevel)".fmt
    let procFutter = block:
      var futter = "    ): {theType} {{.cdecl,".fmt
      if command.successCodes.len != 0:
        futter.add "\n      successCodes(" & command.successCodes.mapIt(it.parseEnumValue("", @[])).join(", ") & "),"
      if command.errorCodes.len != 0:
        futter.add "\n      errorCodes(" & command.errorCodes.mapIt(it.parseEnumValue("", @[])).join(", ") & "),"
      if command.successCodes.len+command.errorCodes.len != 0:
        futter.add "\n      " & loadMethod
      else: futter.add " " & loadMethod
      futter & ".}"

    result &= procHeader
    if procParams.len != 0:
      result &= '\n' & procParams.join("\n") & '\n'
    result &= procFutter
    # result &= "  {cageName}({cageParams.join(\",\")})".fmt
    return
  of nkbrAlias:
    let alias = command.alias.parseCommandName
    return "const {name}* = {alias}".fmt

proc render*(basetype: NodeBasetype): string =
  let name = basetype.name.removeVkPrefix
  case basetype.kind
  of nkbNormal:
    let theType = basetype.theType.replaceBasicTypes
    case name
    of "Flags": "{name}*[Flagbits] = distinct {theType}".fmt
    else: "{name}* = distinct {theType}".fmt
  of nkbExternal:
    "{name}* = ptr object # defined at {basetype.path}".fmt

type CommandRenderingMode = enum
  crmAll
  crmInstance
  crmDevice

proc renderCommandLoaderComponent*(require: NodeRequire; resources: Resources; commandRenderingMode = crmAll): string =
  if require.targets.filterIt(it.kind == nkrCommand).len == 0: return
  var commandLoaderDef = newSeq[string]()

  for req in require.targets.filter(x => x.kind == nkrCommand):
    if not resources.commands.hasKey(req.name): continue
    let command = resources.commands[req.name]
    if command.kind == nkbrAlias or
       command.loadMode == lmPreload: continue

    commandLoaderDef.add case commandRenderingMode
      of crmInstance:
        if command.loadMode != lmWithInstance: continue
        "instance.loadCommand {req.name.parseCommandname}".fmt
      of crmDevice:
        if command.loadMode != lmWithDevice: continue
        "device.loadCommand {req.name.parseCommandname}".fmt
      of crmAll:
        "instance.loadCommand {req.name.parseCommandname}".fmt

  if require.comment.isSome and commandLoaderDef.len != 0:
    commandLoaderDef.insert(require.comment.get.commentify, 0)

  return commandLoaderDef.join("\n")

proc renderCommandLoader*(libFile: LibFile; resources: Resources; commandRenderingMode = crmAll): string =
  var resultDefs: seq[string]

  for i, fileRequire in libFile.requires:
    let loaderName = @[libFile.fileName].concat(libFile.mergedFileNames)[i].splitFile.name.capitalizeAscii
    var commandLoaderDefs = newSeq[string]()
    for require in fileRequire:
      let def = require.renderCommandLoaderComponent(resources, commandRenderingMode)
      if not def.isEmptyOrWhitespace:
        commandLoaderDefs.add def

    if commandLoaderDefs.len != 0:
      let loaderHeader = case commandRenderingMode
        of crmAll: "proc loadAll{loaderName}*(instance: Instance) =\n".fmt
        of crmInstance: "proc load{loaderName}*(instance: Instance) =\n".fmt
        of crmDevice: "proc load{loaderName}*(device: Device) =\n".fmt

      resultDefs.add(
        loaderHeader &
        commandLoaderDefs.mapIt(it.indent(2)).join("\n\n")
      )
  resultDefs.join("\n\n")

func renderInstanceCommandLoader*(fileName: string): string =
  assert fileName in ["features/vk10", "features/vk11"]
  case fileName
  of "features/vk10":
    "proc loadInstanceProcs*() =\n" &
    "  getInstanceProcAddr.load(instance = nil)\n" &
    "  enumerateInstanceExtensionProperties.load(instance = nil)\n" &
    "  enumerateInstanceLayerProperties.load(instance = nil)\n" &
    "  createInstance.load(instance = nil)"
  of "features/vk11":
    "proc loadInstanceProcs*() =\n" &
    "  vk10.loadInstanceProcs()\n" &
    "  enumerateInstanceVersion.load(instance = nil)"
  else: ""

proc render*(libFile: LibFile; library: Library; resources: Resources): string =
  var renderedNodes: seq[string]
  var enumAliasesRequired: seq[NodeEnumAliases]
  result &= "# Generated at {now().utc()}\n".fmt
  result &= libFile.fileName.splitFile.name.commentify
  result.LF
  if libFile.mergedFileNames.len != 0:
    result &= libFile.mergedFileNames.mapIt(it.splitFile.name).join("\n").commentify
    result.LF
  if not libFile.fileHeader.isEmptyOrWhitespace:
    result &= libFile.fileHeader
    result.LF

  result.LF

  let dependencies = libFile
    .deps
    .mapIt( block:
      let (idir, iname, iext) = library[it.fileName].fileName.splitFile
      let (ldir, lname, lext) = libFile.fileName.splitFile
      if idir == ldir: (fileName: "."/iname, exportit: it.exportit)
      else: (fileName: ".."/idir/iname, exportit: it.exportit))
    .deduplicate
  if dependencies.len != 0:
    result &= dependencies
      .mapIt("import {it.fileName}".fmt)
      .join("\n").LF
    if dependencies.filterIt(it.exportit).len != 0:
      result &= dependencies
        .filterIt(it.exportIt)
        .mapIt("export {it.fileName.splitFile.name}".fmt)
        .join("\n").LF
    result.LF

  result &= "prepareVulkanLibDef()\n\n"

  block Solve_basetypes:
    var typeDefs: seq[seq[string]]
    for fileRequire in libFile.requires:
      for require in fileRequire:
        let typeTargets = require.targets.filterIt(it.kind in {nkrType})
        if typeTargets.len == 0: continue

        var typeDef: seq[string]

        for req in typeTargets:
          if req.name in renderedNodes: continue

          if resources.basetypes.hasKey(req.name):
            typeDef.add resources.basetypes[req.name].render
            renderedNodes.add req.name

        if typeDef.len != 0:
          typeDefs.add case require.comment.isSome
            of true: concat(@[require.comment.get.commentify], typeDef)
            of false: typeDef

    if typeDefs.len != 0:
      result.add "type # basetypes\n"
      result &= typeDefs.mapIt(it.join("\n").indent(2)).join("\n\n").LF.LF

  block Solve_consts:
    var reqDefs: seq[seq[string]]
    for fileRequire in libFile.requires:
      for require in fileRequire:
        var reqDef: seq[string]

        for req in require.targets.filter(x => x.kind in {nkrApiConst, nkrConst, nkrConstAlias, nkrType}):
          if req.name in renderedNodes: continue

          case req.kind
          of nkrConst:
            reqDef.add NodeConst(name: req.name, value: req.value).render
            renderedNodes.add req.name

          of nkrConstAlias:
            reqDef.add NodeConstAlias(name: req.name, alias: req.alias).render
            renderedNodes.add req.name

          of nkrApiConst:
            if resources.consts.hasKey(req.name):
              reqDef.add resources.consts[req.name].render
              renderedNodes.add req.name

            elif resources.constAliases.hasKey(req.name):
              reqDef.add resources.constAliases[req.name].render
              renderedNodes.add req.name

          of nkrType:
            if resources.structs.hasKey(req.name):
              let struct = resources.structs[req.name]
              if struct.requiredConstNames.len == 0: continue
              for reqConst in struct.requiredConstNames:
                if reqConst in renderedNodes: continue
                if resources.consts.hasKey(reqConst):
                  reqDef.add resources.consts[reqConst].render
                  renderedNodes.add reqConst

          else: discard
        if reqDef.len != 0:
          reqDefs.add case require.comment.isSome
            of true: concat(@[require.comment.get.commentify], reqDef)
            of false: reqDef
    if reqDefs.len != 0:
      result.add "const\n"
      result.add reqDefs
        .mapIt(it.map(s => s.indent(2)).join("\n"))
        .join("\n\n")
      result.LF
      result.LF

  block Solve_enums:
    var typeDefs: seq[seq[string]]
    for fileRequire in libFile.requires:
      for require in fileRequire:
        let typeTargets = require.targets.filterIt(it.kind in {nkrType})
        if typeTargets.len == 0: continue

        var typeDef: seq[string]

        for req in typeTargets:
          if req.name in renderedNodes: continue

          if resources.bitmasks.hasKey(req.name):
            typeDef.add resources.bitmasks[req.name].render
            renderedNodes.add req.name
          elif resources.enums.hasKey(req.name):
            typeDef.add resources.enums[req.name].render(resources.vendorTags)
            if resources.enumAliases.hasKey(req.name):
              enumAliasesRequired.add resources.enumAliases[req.name]
            renderedNodes.add req.name

        if typeDef.len != 0:
          typeDefs.add case require.comment.isSome
            of true: concat(@[require.comment.get.commentify], typeDef)
            of false: typeDef

    if typeDefs.len != 0:
      result.add "type # enums and bitmasks\n"
      result &= typeDefs.mapIt(it.join("\n").indent(2)).join("\n\n").LF.LF

  block Solve_types:
    var typeDefs: seq[seq[string]]
    for fileRequire in libFile.requires:
      for require in fileRequire:
        let typeTargets = require.targets.filterIt(it.kind in {nkrType})
        if typeTargets.len == 0: continue

        var typeDef: seq[string]

        for req in typeTargets:
          if req.name in renderedNodes: continue

          if resources.structs.hasKey(req.name):
            typeDef.add resources.structs[req.name].render
            renderedNodes.add req.name
          elif resources.funcPtrs.hasKey(req.name):
            typeDef.add resources.funcPtrs[req.name].render
            renderedNodes.add req.name
          elif resources.handles.hasKey(req.name):
            typeDef.add resources.handles[req.name].render
            renderedNodes.add req.name

        if typeDef.len != 0:
          typeDefs.add case require.comment.isSome
            of true: concat(@[require.comment.get.underline('-').commentify], typeDef)
            of false: typeDef

    if typeDefs.len != 0:
      result.add "type".LF
      result &= typeDefs.mapIt(it.join("\n").indent(2)).join("\n\n").LF.LF

  block Solve_others:
    var reqDefs: seq[seq[string]]
    for fileRequire in libFile.requires:
      for require in fileRequire:
        reqDefs.add @[]
        # result &= require.render.LF
        if require.comment.isSome:
          reqDefs[^1].add require.comment.get.underline('-').commentify

        for req in require.targets.filter(x => x.kind == nkrType):
          if req.name notin renderedNodes:
            if resources.defines.hasKey(req.name):
              reqDefs[^1].add resources.defines[req.name].render
              renderedNodes.add req.name
          if resources.enumAliases.hasKey(req.name):
            reqDefs[^1].add resources.enumAliases[req.name].render(resources.vendorTags)

        let reqCommands = require.targets.filter(x => x.kind == nkrCommand)
        if reqCommands.len != 0:
          for reqCommand in reqCommands:
            if reqCommand.name in renderedNodes: continue
            if resources.commands.hasKey(reqCommand.name):
              reqDefs[^1].add resources.commands[reqCommand.name].render
              renderedNodes.add reqCommand.name

        let reqEnumExts = require.targets.filter(x => x.kind == nkrEnumExtendAlias)
        let enumAliases = newTable[string, NodeEnumAliases]()
        for reqEnumExt in reqEnumExts:
          if enumAliases.hasKey(reqEnumExt.extends):
            enumAliases[reqEnumExt.extends].aliases.add NodeEnumAlias(
              name: reqEnumExt.name,
              alias: reqEnumExt.enumAlias,
            )
          else:
            enumAliases[reqEnumExt.extends] = NodeEnumAliases(
              name: reqEnumExt.extends,
              aliases: @[NodeEnumAlias(
                name: reqEnumExt.name,
                alias: reqEnumExt.enumAlias,
              )]
            )
        for key, val in enumAliases:
          reqDefs[^1].add val.render(resources.vendorTags)

    if reqDefs.len != 0:
      result &= reqDefs.mapIt(it.join("\n")).filterIt(it.len != 0).join("\n\n\n")
      result.LF
      result.LF

  if libFile.fileName == "features/vk10":
    result &= readFile("src/vulkan/generator/resources/loadoperators.nim")
    result.LF
    result.LF

  block Render_command_loaders:
    let loadAll = libFile.renderCommandLoader(resources)
    if loadAll.len != 0:
      result &= loadAll
      result.LF
      result.LF
    let loadInstance = libFile.renderCommandLoader(resources, crmInstance)
    if loadInstance.len != 0:
      result &= loadInstance
      result.LF
      result.LF
    let loadDevice = libFile.renderCommandLoader(resources, crmDevice)
    if loadDevice.len != 0:
      result &= loadDevice
      result.LF
      result.LF

  if not libFile.fileFooter.isEmptyOrWhitespace:
    result.LF
    result &= libFile.fileFooter

#!SECTION

# SECTION extractors
func extractNodeEnumValue*(typeDef: XmlNode): (Option[NodeEnumVal], Option[NodeEnumAlias]) {.raises: [UnexpectedXmlStructureError].} =
  # Extract enum data from each <enum> tag of <enums>.
  #   <enums name="VkResult" type="enum" comment="API result codes">
  #           <comment>Return codes (positive values)</comment>
  #       <enum value="0"     name="VK_SUCCESS" comment="Command completed successfully"/>
  #       <enum value="1"     name="VK_NOT_READY" comment="A fence or query has not yet completed"/>
  # ...
  #       <enum value="5"     name="VK_INCOMPLETE" comment="A return array was too small for the result"/>
  #           <comment>Error codes (negative values)</comment>
  #       <enum value="-1"    name="VK_ERROR_OUT_OF_HOST_MEMORY" comment="A host memory allocation has failed"/>
  #       <enum value="-2"    name="VK_ERROR_OUT_OF_DEVICE_MEMORY" comment="A device memory allocation has failed"/>
  # ...
  #       <enum value="-13"   name="VK_ERROR_UNKNOWN" comment="An unknown error has occurred, due to an implementation or application bug"/>
  #           <unused start="-14" comment="This is the next unused available error code (negative value)"/>
  #   </enums>
  block Handle_invalid_nodes:
    if typeDef.kind in {xnText, xnComment}: # Meaningless blank value
      return
    if typeDef.kind != xnElement:
      xmlError title"@Enum Value Extraction >": $typeDef

    if typeDef.tag in ["unused", "comment"]:
      # Since enum values are later sorted, it is difficult to handle such comment tag.
      return
    if typeDef.tag != "enum":
      xmlError title"@Enum Value Extraction >": $typeDef

  let value: Option[tuple[val: int; isHex: bool]] =
    # input        100  0x100 abcde
    # -------------------------------
    # parseInt      o     x     x
    # parseHexInt   o     o     x
    try: some (typeDef{"value"}.parseInt, false)
    except:
      try:    some (typeDef{"value"}.parseHexInt, true)
      except: none (int, bool)
  let bitpos =
    try: some typeDef{"bitpos"}.parseInt.int32
    except: none int32
  let alias = ?typeDef{"alias"}

  if value.isSome or bitpos.isSome:
    var resultVal = NodeEnumVal(
      name: typeDef.name,
      comment: ?typeDef.comment,
      kind:
        if value.isSome: nkeValue
        else: nkeBitpos)
    case resultVal.kind
    of nkeValue:
      resultVal.value = value.get.val
      resultVal.isHex = value.get.isHex
      return (some resultVal, none NodeEnumAlias)
    of nkeBitpos:
      resultVal.bitpos = bitpos.get
      return (some resultVal, none NodeEnumAlias)
  elif alias.isSome:
    return ( none NodeEnumVal, some NodeEnumAlias(
      name: typeDef.name,
      comment: ?typeDef.comment,
      alias: alias.get))
  else:
    xmlError title"The enum value does'nt has any value, bitpos or alias attr.": $typeDef

func extractNodeEnum*(enumDef: XmlNode): (Option[NodeEnum], Option[NodeEnumAliases]) {.raises: [UnexpectedXmlStructureError].} =
  if enumDef.kind != xnElement or
     enumDef.tag != "enums":
    return
  if enumDef.name == "API Constants":
    return

  var resultEnum = NodeEnum(
    name: enumDef.name,
    comment: ?enumDef.comment)
  var resultAliases = NodeEnumAliases(
    name: enumDef.name)

  for child in enumDef:
    let (value, alias) = child.extractNodeEnumValue
    if value.isSome: resultEnum.enumVals.add value.get
    if alias.isSome: resultAliases.aliases.add alias.get

  result[0] = some resultEnum
  if resultAliases.aliases.len != 0: result[1] = some resultAliases

func extractNodeApiConstVal*(typeDef: XmlNode): (Option[NodeConst], Option[NodeConstAlias]) {.raises: [UnexpectedXmlStructureError].} =
  if typeDef.tag != "enum":
    xmlError title"@API constant value Extraction >": $typeDef
  result = if (?typeDef.value).isSome: (
      some NodeConst(
        name: typeDef.name,
        value: typeDef.value
          .replace("~0ULL", "uint64.high")
          .replace("~0U", "uint32.high"),
        comment: ?typeDef.comment),
      none NodeConstAlias
    )
  elif (?typeDef.alias).isSome: (
      none NodeConst,
      some NodeConstAlias(
        name: typeDef.name,
        alias: typeDef.alias,
        comment: ?typeDef.comment)
    )
  else:
    xmlError title"@API constant value Extraction >": $typeDef

func extractVendorTags*(tags: XmlNode): VendorTags {.raises: [UnexpectedXmlStructureError].} =
  if tags.kind != xnElement or tags.tag != "tags":
    xmlError invalidStructure("Vendor Tag Extraction"): $tags
  tags.findAll("tag")
    .filterIt((?it.name).isSome)
    .mapIt(VendorTag(name: it.name))

func extractNodeFuncPointer*(typeDef: XmlNode): NodeFuncPtr {.raises: [UnexpectedXmlStructureError].} =
  # extract funcpointer definition data from such as following xml:
  # <type category="funcpointer">typedef void (VKAPI_PTR *<name>PFN_vkInternalAllocationNotification</name>)(
  #   <type>void</type>*                    pUserData,
  #   <type>size_t</type>                   size,
  #   <type>VkInternalAllocationType</type> allocationType,
  #   <type>VkSystemAllocationScope</type>  allocationScope);</type>
  if typeDef.kind != xnElement or
     typeDef.tag != "type" or
     typeDef.category != "funcpointer":
    xmlError invalidStructure("Funcpointer Extraction"): $typeDef
  new result
  var atArgDef: bool
  for child in typeDef:
    case child.kind
    of xnElement:
      case child.tag
      of "name": # The name tag in "funcpointer" represents the func name.
        result.name = child.innerText.parseWords[0]
      of "type": # The type tag in "funcpointer" represents the arg names.
        if not atArgDef: atArgDef = true
        #                name, theType,                     ptrLv
        result.args.add ("", child.innerText.parseWords[0], 0.Natural)
    of xnText:
      let words = child
        .innerText
        .parseWords({',', ';', '(', ')', '*'})
        .filterInvalidArgParams

      if words.len == 0: continue
      if words.len != 1:
        xmlError title"@funcpointer Extraction > cannot determine the type of return": $typeDef

      if atArgDef:
        if result.args.len == 0: # for the func that has no (void) arguments
          continue
        result.args[^1].ptrLv += child.innerText.count("*")
        result.args[^1].name = words[0]
      else:
        result.ptrLv += child.innerText.count("*")
        result.theType = words[0]
    else:
      xmlError title"@funcpointer Extraction > unhandled xml has found": $typeDef

  #  <type category="funcpointer">typedef void (VKAPI_PTR *<name>PFN_vkFreeFunction</name>)(
  #                     This one means the above astarisk ^
  result.ptrLv -= 1

func extractNodeDefine*(typeDef: XmlNode): NodeDefine {.raises: [UnexpectedXmlStructureError].} =
  if typeDef.kind != xnElement or typeDef.tag != "type":
    xmlError invalidStructure("define Extraction"): $typeDef
  result = NodeDefine(
    name:
      if (?typeDef.name).isSome: typeDef.name
      else: typeDef["name"].innerText.parseWords[0])
  result.str =
    define(result.name, typeDef) |> (x => (
      if x.isSome: x.get
      else: xmlError title"@define Extraction > the define has not found": $typeDef
    ))

func extractNodeStructMember*(typeDef: XmlNode): (NodeStructMember, seq[string]) {.raises: [].} =

    result[0] = NodeStructMember(
      theType: typeDef["type"].innerText.parseWords[0],
      name: typeDef["name"].innerText.parseWords[0],
      arrayStyle:
        if ((?typeDef{"len"}).isSome or (?typeDef{"altlen"}).isSome):
          nasPtr
        elif typeDef.findAll("enum").len != 0 or typeDef.innerText.find({'[', ']'}) != -1:
          nasFix
        else:
          nasNotArray
    )

    if (?typeDef{"values"}).isSome:
      result[0].values = some typeDef{"values"}
    else:
      result[0].optional = (typeDef{"optional"} == "true") or (result[0].name == "pNext")


    if result[0].arrayStyle == nasPtr:
      let ptrcnt = typedef.`$`.count("*")
      if ptrcnt != 0:
        result[0].ptrLen.setlen(ptrcnt)

      if (?typeDef{"altlen"}).isSome:
        result[0].ptrLen[0] = some typeDef{"altlen"}.replace("/", " /")
      elif (?typeDef{"len"}).isSome:
        for i, v in typeDef{"len"}.parseWords({','}):
          if v == "null-terminated": continue
          result[0].ptrLen[i] = some v

    if result[0].arrayStyle == nasNotArray:
      result[0].ptrLv = typedef.`$`.count("*")

    for m in typeDef:
      if m.kind == xnElement and m.tag == "enum":
        result[0].dim.add NodeArrayDimention(useConst: true, name: m.innerText.parseWords[0])
        result[1].add m.innerText.parseWords[0]

      if m.kind != xnText: continue
      let words = m.text.parseWords.filterInvalidArgParams
      if words.len == 0: continue
      #  E.g. "[3]", "[2][3]" or "[1][2][3]".
      #  Raise exception if it pattern is as "[a][b]"
      if words[0][0] == '[' and words[0][^1] == ']':
        result[0].dim.add words[0]
          .parseWords({'[', ']'})
          .mapIt(try:    some it.parseInt.Natural
                 except: none Natural)
          .filterIt(it.isSome)
          .mapIt(NodeArrayDimention(useConst: false, value: it.get))


func extractNodeStruct*(typeDef: XmlNode): NodeStruct {.raises: [UnexpectedXmlStructureError].} =
  # Extract struct definition data from such as following xml:
  #
  # <type category="struct" name="VkImageBlit">
  #   <member><type>VkImageSubresourceLayers</type> <name>srcSubresource</name></member>
  #   <member><type>VkOffset3D</type>             <name>srcOffsets</name>[2]<comment>Specified in pixels for both compressed and uncompressed images</comment></member>
  #   <member><type>VkImageSubresourceLayers</type> <name>dstSubresource</name></member>
  #   <member><type>VkOffset3D</type>             <name>dstOffsets</name>[2]<comment>Specified in pixels for both compressed and uncompressed images</comment></member>
  # </type>
  if typeDef.kind != xnElement or
     typeDef.tag != "type" or
     typeDef.category notin ["struct", "union"]:
    xmlError invalidStructure("struct Extraction"): $typeDef

  result = NodeStruct(
    name: typeDef.name,
    comment: ?typeDef.comment,
    isUnion: typeDef.category == "union")
  for member in typeDef.findAll("member"):
    let (memberNode, requiredConsts) = member.extractNodeStructMember
    result.members.add memberNode
    result.requiredConstNames.add requiredConsts

func extractNodeBitmask*(typeDef: Xmlnode): NodeBitmask {.raises: [UnexpectedXmlStructureError]} =
  if typeDef.kind != xnElement or
     typeDef.tag != "type" or
     typeDef.category != "bitmask":
    xmlError invalidStructure("bitmask Extraction"): $typeDef

  result = NodeBitmask(
    kind:
      if typeDef["type"] != nil and
         typeDef["name"] != nil :
        nkbrNormal
      elif (?typeDef{"alias"}).isSome and
           (?typeDef{"name"}).isSome:
        nkbrAlias
      else:
        xmlError title"@Flagbits Extraction >": $typeDef
  )
  case result.kind
  of nkbrNormal:
    result.name = typeDef["name"].innerText.parseWords[0]
    result.flagbitsReq = ?typeDef{"requires"}
  of nkbrAlias:
    result.name = typeDef{"name"}
    result.alias = typeDef{"alias"}

func extractNodeHandle*(typeDef: XmlNode): NodeHandle {.raises: [UnexpectedXmlStructureError].} =
  if typeDef.kind != xnElement or
     typeDef.tag != "type" or
     typeDef.category != "handle":
    xmlError invalidStructure("handle Extraction"): $typeDef
  if (?typeDef{"name"}).isSome and (?typeDef{"alias"}).isSome:
    NodeHandle(
      kind: nkbrAlias,
      name: typeDef{"name"},
      alias: typeDef{"alias"})
  else:
    NodeHandle(
      kind: nkbrNormal,
      name: typeDef["name"].innerText.parseWords[0],
      handleKind: case typeDef["type"].innerText.parseWords[0]
        of "VK_DEFINE_HANDLE": HandleKind.Handle
        of "VK_DEFINE_NON_DISPATCHABLE_HANDLE": HandleKind.NonDispatchableHandle
        else: xmlError title"@handle Extraction > Unknowun handle": $typeDef
      ,
      parent: ?typeDef{"parent"})

proc extractNodeCommand*(typeDef: XmlNode): NodeCommand {.raises: [UnexpectedXmlStructureError].} =
  # Extract command definition data from such as following xml:
  #
  # <command name="vkGetDeviceMemoryOpaqueCaptureAddressKHR"        alias="vkGetDeviceMemoryOpaqueCaptureAddress"/>
  #
  # <command successcodes="VK_SUCCESS,VK_INCOMPLETE" errorcodes="VK_ERROR_OUT_OF_HOST_MEMORY,VK_ERROR_OUT_OF_DEVICE_MEMORY">
  #     <proto><type>VkResult</type> <name>vkGetPipelineExecutablePropertiesKHR</name></proto>
  #     <param><type>VkDevice</type>                        <name>device</name></param>
  #     <param>const <type>VkPipelineInfoKHR</type>*        <name>pPipelineInfo</name></param>
  #     <param optional="false,true"><type>uint32_t</type>* <name>pExecutableCount</name></param>
  #     <param optional="true" len="pExecutableCount"><type>VkPipelineExecutablePropertiesKHR</type>* <name>pProperties</name></param>
  # </command>
  const preloadableProcs = [
    "vkGetInstanceProcAddr",
    "vkGetDeviceProcAddr",
    "vkEnumerateInstanceVersion",
    "vkEnumerateInstanceExtensionProperties",
    "vkEnumerateInstanceLayerProperties",
    "vkCreateInstance",
  ]
  if typeDef.kind != xnElement or
     typeDef.tag != "command":
    xmlError invalidStructure("command Extraction"): $typeDef
  result = NodeCommand(
    kind: if (?typeDef{"alias"}).isSome: nkbrAlias
          else: nkbrNormal)
  case result.kind
  of nkbrAlias:
    result.name = typeDef{"name"}
    result.alias= typeDef{"alias"}
  of nkbrNormal:
    result.successCodes = typeDef{"successcodes"}.parseWords({','})
    result.errorCodes = typeDef{"errorcodes"}.parseWords({','})
    result.name = typeDef["proto"]["name"].innerText.parseWords[0]
    result.theType = typeDef["proto"]["type"].innerText.parseWords[0]
    for param in typeDef:
      if param.tag != "param": continue
      result.params.add NodeCommandParam(
        name: param["name"].innerText.parseWords[0],
        theType: param["type"].innerText.parseWords[0],
        optional: param{"optional"} == "true",
        arrayStyle:
          if param{"len"}.`?`.isSome: nasPtr
          else: nasNotArray
      )
      case result.params[^1].arrayStyle
      of nasNotArray:
        result.params[^1].ptrLv = param.`$`.count("*")
      of nasPtr:
        result.params[^1].ptrLen.setLen(param.`$`.count("*"))
        for i, x in param{"len"}.parseWords({','}):
          if x == "null-terminated": continue
          result.params[^1].ptrLen[i] = some x
      else: discard


    result.loadMode =
      if result.name in preloadableProcs: lmPreload
      elif result.params[0].theType in ["VkInstance", "VkPhysicalDevice"]: lmWithInstance
      else: lmWithDevice


func extractNodeBasetype*(typeDef: XmlNode): NodeBasetype {.raises: [UnexpectedXmlStructureError].} =
  if typeDef.kind != xnElement or
     typeDef.tag != "type" or
     typeDef.category != "basetype":
    xmlError invalidStructure("basetype Extraction"): $typeDef
  NodeBasetype(
    kind: nkbNormal,
    name: typeDef["name"].innerText.parseWords[0],
    theType: block:
      let ctype = typeDef["type"]
      if ctype != nil: ctype.innerText.parseWords[0]
      else: "object"
  )
func extractNodeExternalReq*(typeDef: XmlNode): NodeBasetype {.raises: [UnexpectedXmlStructureError].} =
  if typeDef.kind != xnElement or
     typeDef.tag != "type" or
     (?typeDef{"requires"}).isNone:
    xmlError invalidStructure("external requires Extraction"): $typeDef
  NodeBasetype(
    kind: nkbExternal,
    name: typeDef.name,
    path: typeDef{"requires"},
  )

proc extractAllNodeEnumExtensions*(rootXml: XmlNode; resources: var Resources) {.raises: [UnexpectedXmlStructureError].} =
  for enumsRoot in concat(
        rootXml.findAll("feature"),
        rootXml["extensions"].findAll("extension"),):
    let enums = enumsRoot
      .findAll("enum")
      .filterIt((?it{"extends"}).isSome)
    for theEnum in enums:
      let extnumber =
        try: some theEnum{"extnumber"}.parseInt
        except: 
          try: some enumsRoot{"number"}.parseInt
          except: none int
      let value =
        try: some theEnum{"value"}.parseInt
        except: none int
      let offset =
        try: some theEnum{"offset"}.parseInt
        except: none int
      let bitpos =
        try: some theEnum{"bitpos"}.parseInt
        except: none int
      if (extnumber.isSome and offset.isSome) or value.isSome or bitpos.isSome:
        var nodeEnumVal = NodeEnumVal(
          name: theEnum.name,
          comment: ?theEnum.comment,
          isExtended: true,
          extends: theEnum{"extends"},
          providedBy: enumsRoot.name,
          kind:
            if bitpos.isSome: nkeBitpos
            else: nkeValue
        )
        case nodeEnumVal.kind
        of nkeValue:
          try:
            nodeEnumVal.value =
              if value.isSome: value.get
              else: "1000{extnumber.get-1:03}{offset.get:03}".fmt.parseInt
            if resources.enums[nodeEnumVal.extends].enumVals.findIt(it.kind == nkeValue and it.value == nodeEnumVal.value) == nil:
              resources.enums[nodeEnumVal.extends].enumVals.add nodeEnumVal
          except ValueError:
            xmlError title"@enum extends Extraction > cannot parse the value": $theEnum
          except KeyError:
            xmlError title"@enum extends Extraction >": $theEnum
        of nkeBitpos:
          try:
            nodeEnumVal.bitpos = bitpos.get
            if resources.enums[nodeEnumVal.extends].enumVals.findIt(it.kind == nkeBitpos and it.bitpos == nodeEnumVal.bitpos) == nil:
              resources.enums[nodeEnumVal.extends].enumVals.add nodeEnumVal
          except KeyError:
            xmlError title"@enum extends Extraction >": $theEnum
      else: continue

#!SECTION

func extractNodeRequire*(typeDef: XmlNode): NodeRequire {.raises: [UnexpectedXmlStructureError].} =
  template lastTarget(x: untyped): untyped =
    x.targets[^1]
  if typeDef.kind != xnElement or typeDef.tag != "require":
    xmlError invalidStructure("require Extraction"): $typeDef
  result = NodeRequire(comment: ?typeDef.comment)
  for child in typeDef:
    if child.kind != xnElement: continue
    result.targets.add NodeRequireVal(
      name: child.name,
      kind: case child.tag
        of "comment": continue
        of "type":                       nkrType
        of "command":                    nkrCommand
        of "enum":
          if (?child{"extends"}).isSome and
             (?child{"alias"}).isSome:   nkrEnumExtendAlias
          elif (?child{"value"}).isSome: nkrConst
          elif (?child{"alias"}).isSome: nkrConstAlias
          else:                          nkrApiConst
        else: xmlError title"@require Extraction > A resource of the unexpected type has required": $child
    )
    case result.lastTarget.kind
    of nkrConst:
      result.lastTarget.value = child{"value"}
    of nkrConstAlias:
      result.lastTarget.alias = child{"alias"}
    of nkrEnumExtendAlias:
      result.lastTarget.enumAlias = child{"alias"}
      result.lastTarget.extends = child{"extends"}
    else: discard

proc extractResources*(rootXml: XmlNode): Resources {.raises: [LoggingFailure, Exception].}=
  template zipTable(s: untyped): untyped =
    s.mapIt((it.name, it)).newTable
  let
    enumsXmlTable = rootXml
      .findAll("enums")
      .mapIt((it.name, it))
      .newTable
    typeXmlSeq = rootXml
      .child("types")
      .findAll("type")

  result = Resources(
    consts: newTable[string, NodeConst](),
    constAliases: newTable[string, NodeConstAlias](),
    structs: newTable[string, NodeStruct](),
    enums: newTable[string, NodeEnum](),
    enumAliases: newTable[string, NodeEnumAliases](),
  )

  try:
    result.vendorTags = rootXml["tags"].extractVendorTags
  except UnexpectedXmlStructureError:
    error getCurrentExceptionMsg()

  try:
    for apiConst in enumsXmlTable["API Constants"].findAll("enum"):
      try:
        let (cons, alias) = apiConst.extractNodeApiConstVal
        if cons.isSome:
          result.consts[cons.get.name] = cons.get
        if alias.isSome:
          result.constAliases[alias.get.name] = alias.get
      except UnexpectedXmlStructureError:
        error getCurrentExceptionMsg()
  except KeyError:
    error title"@resources Extraction > API Constants was not found."

  result.defines = typeXmlSeq
    .filterByCategory("define")
    .mapIt(it.extractNodeDefine)
    .zipTable

  result.commands = rootXml
    .child("commands")
    .findAll("command")
    .mapIt(it.extractNodeCommand)
    .zipTable

  for xmlType in typeXmlSeq.filterByCategory("enum"):
    try:
      let (theEnum, enumAliases) = enumsXmlTable[xmlType.name].extractNodeEnum()
      if theEnum.isSome:
        result.enums[xmlType.name] = theEnum.get
      if enumAliases.isSome:
        result.enumAliases[xmlType.name] = enumAliases.get
    except KeyError:
      result.enums[xmlType.name] = NodeEnum(name: xmlType.name, enumVals: @[])
    except UnexpectedXmlStructureError:
      error getCurrentExceptionMsg()

  try:
    rootXml.extractAllNodeEnumExtensions(result)
  except UnexpectedXmlStructureError:
    error getCurrentExceptionMsg()

  for xmlStruct in typeXmlSeq.filterByCategory("struct", "union"):
    try:
      let struct = xmlStruct.extractNodeStruct()
      result.structs[struct.name] = struct
    except UnexpectedXmlStructureError:
      error getCurrentExceptionMsg()

  result.bitmasks = typeXmlSeq
    .filterByCategory("bitmask")
    .mapIt(
      try: it.extractNodeBitmask
      except UnexpectedXmlStructureError:
        error getCurrentExceptionMsg(); nil)
    .filterIt(not it.isNil)
    .zipTable
  result.funcPtrs = typeXmlSeq
    .filterByCategory("funcpointer")
    .mapIt(
      try: it.extractNodeFuncPointer
      except UnexpectedXmlStructureError:
        error getCurrentExceptionMsg(); nil)
    .filterIt(not it.isNil)
    .zipTable
  result.basetypes = concat(
    typeXmlSeq
      .filterByCategory("basetype")
      .mapIt(it.extractNodeBasetype),
    typeXmlSeq.filterIt((?it{"requires"}).isSome)
      .mapIt(it.extractNodeExternalReq),
    ).zipTable
  result.handles = typeXmlSeq
    .filterByCategory("handle")
    .mapIt(it.extractNodehandle)
    .zipTable

proc merge*(library: var Library; base: string; materials: varargs[string]) =
  if not library.hasKey(base) or
     materials.anyIt(not library.hasKey(it)):
    return

  var result: LibFile = library[base]
  for material in materials:
    let lib = library[material]
    library[material] = result
    result.requires.add lib.requires
    result.deps.add lib.deps
    result.mergedFileNames.add lib.fileName

  result.requires = result.requires.deduplicate

  for i in countdown(result.deps.high, result.deps.low):
    if result.deps[i].filename in materials or
       result.deps[i].filename == result.fileName:
      result.deps.delete(i)

