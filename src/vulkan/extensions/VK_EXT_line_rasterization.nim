# Generated at 2021-10-24T09:33:17Z
# VK_EXT_line_rasterization

import ../platform
import ../features/vk10
import ./VK_KHR_get_physical_device_properties2
export VK_KHR_get_physical_device_properties2

prepareVulkanLibDef()

const
  ExtLineRasterizationSpecVersion* = 1
  ExtLineRasterizationExtensionName* = "VK_EXT_line_rasterization"

type # enums and bitmasks
  LineRasterizationModeEXT* {.size: sizeof(int32), pure.} = enum
    defaultExt = 0
    rectangularExt = 1
    bresenhamExt = 2
    rectangularSmoothExt = 3

type
  PhysicalDeviceLineRasterizationFeaturesEXT* = object
    sType* {.constant: (StructureType.physicalDeviceLineRasterizationFeaturesExt).}: StructureType
    pNext* {.optional.}: pointer
    rectangularLines*: Bool32
    bresenhamLines*: Bool32
    smoothLines*: Bool32
    stippledRectangularLines*: Bool32
    stippledBresenhamLines*: Bool32
    stippledSmoothLines*: Bool32
  PhysicalDeviceLineRasterizationPropertiesEXT* = object
    sType* {.constant: (StructureType.physicalDeviceLineRasterizationPropertiesExt).}: StructureType
    pNext* {.optional.}: pointer
    lineSubPixelPrecisionBits*: uint32
  PipelineRasterizationLineStateCreateInfoEXT* = object
    sType* {.constant: (StructureType.pipelineRasterizationLineStateCreateInfoExt).}: StructureType
    pNext* {.optional.}: pointer
    lineRasterizationMode*: LineRasterizationModeEXT
    stippledLineEnable*: Bool32
    lineStippleFactor* {.optional.}: uint32
    lineStipplePattern* {.optional.}: uint16

proc cmdSetLineStippleEXT*(
      commandBuffer: CommandBuffer;
      lineStippleFactor: uint32;
      lineStipplePattern: uint16;
    ): void {.cdecl, lazyload("vkCmdSetLineStippleEXT", DeviceLevel).}

proc loadAllVK_EXT_line_rasterization*(instance: Instance) =
  instance.loadCommand cmdSetLineStippleEXT

proc loadVK_EXT_line_rasterization*(device: Device) =
  device.loadCommand cmdSetLineStippleEXT

