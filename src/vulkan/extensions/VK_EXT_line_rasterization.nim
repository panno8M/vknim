# Generated at 2021-08-30T22:51:48Z
# VK_EXT_line_rasterization


import ../platform
import ../features/vk10
import ./VK_KHR_get_physical_device_properties2

const
  ExtLineRasterizationSpecVersion* = 1
  ExtLineRasterizationExtensionName* = "VK_EXT_line_rasterization"

type
  PhysicalDeviceLineRasterizationFeaturesEXT* = object
    sType*: StructureType
    pNext*: pointer
    rectangularLines*: Bool32
    bresenhamLines*: Bool32
    smoothLines*: Bool32
    stippledRectangularLines*: Bool32
    stippledBresenhamLines*: Bool32
    stippledSmoothLines*: Bool32
  PhysicalDeviceLineRasterizationPropertiesEXT* = object
    sType*: StructureType
    pNext*: pointer
    lineSubPixelPrecisionBits*: uint32
  PipelineRasterizationLineStateCreateInfoEXT* = object
    sType*: StructureType
    pNext*: pointer
    lineRasterizationMode*: LineRasterizationModeEXT
    stippledLineEnable*: Bool32
    lineStippleFactor*: uint32
    lineStipplePattern*: uint16
  LineRasterizationModeEXT* {.size: sizeof(int32), pure.} = enum
    defaultExt = 0
    rectangularExt = 1
    bresenhamExt = 2
    rectangularSmoothExt = 3

var # command cages
  cmdSetLineStippleEXTCage: proc(commandBuffer: CommandBuffer; lineStippleFactor: uint32; lineStipplePattern: uint16;): void {.cdecl.}
proc cmdSetLineStippleEXT*(
      commandBuffer: CommandBuffer;
      lineStippleFactor: uint32;
      lineStipplePattern: uint16;
    ): void {.cdecl.} =
  cmdSetLineStippleEXTCage(commandBuffer,lineStippleFactor,lineStipplePattern)
proc loadVK_EXT_line_rasterization*(instance: Instance) =
  instance.defineLoader(`<<`)

  cmdSetLineStippleEXTCage << "vkCmdSetLineStippleEXT"