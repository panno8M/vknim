# Generated at 2021-08-27T06:01:02Z
# VK_EXT_conditional_rendering
# =================================

import ../platform
import ../features/vk10


const
  ExtConditionalRenderingSpecVersion* = 2
  ExtConditionalRenderingExtensionName* = "VK_EXT_conditional_rendering"

type
  ConditionalRenderingFlagsEXT* = distinct Flags
  ConditionalRenderingFlagBitsEXT* {.size: sizeof(int32), pure.} = enum
    InvertedBitExt = 0x00000001
  ConditionalRenderingBeginInfoEXT* = object
    sType*: StructureType
    pNext*: pointer
    buffer*: Buffer
    offset*: DeviceSize
    flags*: ConditionalRenderingFlagsEXT
  PhysicalDeviceConditionalRenderingFeaturesEXT* = object
    sType*: StructureType
    pNext*: pointer
    conditionalRendering*: Bool32
    inheritedConditionalRendering*: Bool32
  CommandBufferInheritanceConditionalRenderingInfoEXT* = object
    sType*: StructureType
    pNext*: pointer
    conditionalRenderingEnable*: Bool32

var # commands
  cmdBeginConditionalRenderingEXTCage: proc(commandBuffer: CommandBuffer; pConditionalRenderingBegin: ptr ConditionalRenderingBeginInfoEXT;): void {.cdecl.}
  cmdEndConditionalRenderingEXTCage: proc(commandBuffer: CommandBuffer;): void {.cdecl.}
proc cmdBeginConditionalRenderingEXT*(
      commandBuffer: CommandBuffer;
      pConditionalRenderingBegin: ptr ConditionalRenderingBeginInfoEXT;
    ): void {.cdecl.} =
  cmdBeginConditionalRenderingEXTCage(commandBuffer,pConditionalRenderingBegin)
proc cmdEndConditionalRenderingEXT*(
      commandBuffer: CommandBuffer;
    ): void {.cdecl.} =
  cmdEndConditionalRenderingEXTCage(commandBuffer)
proc loadVK_EXT_conditional_rendering*(instance: Instance) =
  instance.defineLoader(`<<`)

  cmdBeginConditionalRenderingEXTCage << "vkCmdBeginConditionalRenderingEXT"
  cmdEndConditionalRenderingEXTCage << "vkCmdEndConditionalRenderingEXT"