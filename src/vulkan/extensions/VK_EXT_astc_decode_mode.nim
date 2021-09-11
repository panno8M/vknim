# Generated at 2021-09-10T05:27:58Z
# VK_EXT_astc_decode_mode


import ../platform
import ../features/vk10
import ./VK_KHR_get_physical_device_properties2
export VK_KHR_get_physical_device_properties2

const
  ExtAstcDecodeModeSpecVersion* = 1
  ExtAstcDecodeModeExtensionName* = "VK_EXT_astc_decode_mode"

type
  ImageViewASTCDecodeModeEXT* = object
    sType* {.constant: (StructureType.imageViewAstcDecodeModeExt).}: StructureType
    pNext* {.optional.}: pointer
    decodeMode*: Format
  PhysicalDeviceASTCDecodeFeaturesEXT* = object
    sType* {.constant: (StructureType.physicalDeviceAstcDecodeFeaturesExt).}: StructureType
    pNext* {.optional.}: pointer
    decodeModeSharedExponent*: Bool32



