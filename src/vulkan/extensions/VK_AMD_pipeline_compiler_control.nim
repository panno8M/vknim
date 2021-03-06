# Generated at 2021-10-24T02:03:03Z
# VK_AMD_pipeline_compiler_control

import ../platform
import ../features/vk10

prepareVulkanLibDef()

const
  AmdPipelineCompilerControlSpecVersion* = 1
  AmdPipelineCompilerControlExtensionName* = "VK_AMD_pipeline_compiler_control"

type # enums and bitmasks
  PipelineCompilerControlFlagBitsAMD* = distinct UnusedEnum
  PipelineCompilerControlFlagsAMD* = Flags[PipelineCompilerControlFlagBitsAMD]

type
  PipelineCompilerControlCreateInfoAMD* = object
    sType* {.constant: (StructureType.pipelineCompilerControlCreateInfoAmd).}: StructureType
    pNext* {.optional.}: pointer
    compilerControlFlags* {.optional.}: PipelineCompilerControlFlagsAMD



