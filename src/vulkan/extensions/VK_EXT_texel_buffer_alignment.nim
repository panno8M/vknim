# Generated at 2021-09-22T15:02:54Z
# VK_EXT_texel_buffer_alignment


import ../platform
import ../features/vk10
import ./VK_KHR_get_physical_device_properties2
export VK_KHR_get_physical_device_properties2

const
  ExtTexelBufferAlignmentSpecVersion* = 1
  ExtTexelBufferAlignmentExtensionName* = "VK_EXT_texel_buffer_alignment"

type
  PhysicalDeviceTexelBufferAlignmentFeaturesEXT* = object
    sType* {.constant: (StructureType.physicalDeviceTexelBufferAlignmentFeaturesExt).}: StructureType
    pNext* {.optional.}: pointer
    texelBufferAlignment*: Bool32
  PhysicalDeviceTexelBufferAlignmentPropertiesEXT* = object
    sType* {.constant: (StructureType.physicalDeviceTexelBufferAlignmentPropertiesExt).}: StructureType
    pNext* {.optional.}: pointer
    storageTexelBufferOffsetAlignmentBytes*: DeviceSize
    storageTexelBufferOffsetSingleTexelAlignment*: Bool32
    uniformTexelBufferOffsetAlignmentBytes*: DeviceSize
    uniformTexelBufferOffsetSingleTexelAlignment*: Bool32



