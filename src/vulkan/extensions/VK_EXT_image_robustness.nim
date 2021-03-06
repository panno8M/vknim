# Generated at 2021-10-24T02:03:03Z
# VK_EXT_image_robustness

import ../platform
import ../features/vk10
import ./VK_KHR_get_physical_device_properties2
export VK_KHR_get_physical_device_properties2

prepareVulkanLibDef()

const
  ExtImageRobustnessSpecVersion* = 1
  ExtImageRobustnessExtensionName* = "VK_EXT_image_robustness"

type
  PhysicalDeviceImageRobustnessFeaturesEXT* = object
    sType* {.constant: (StructureType.physicalDeviceImageRobustnessFeaturesExt).}: StructureType
    pNext* {.optional.}: pointer
    robustImageAccess*: Bool32



