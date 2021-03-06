# Generated at 2021-10-24T02:03:03Z
# VK_KHR_uniform_buffer_standard_layout

import ../platform
import ../features/vk10
import ./VK_KHR_get_physical_device_properties2
import ../features/vk12
export VK_KHR_get_physical_device_properties2

prepareVulkanLibDef()

const
  KhrUniformBufferStandardLayoutSpecVersion* = 1
  KhrUniformBufferStandardLayoutExtensionName* = "VK_KHR_uniform_buffer_standard_layout"

type
  PhysicalDeviceUniformBufferStandardLayoutFeaturesKHR* = object

StructureType.defineAliases:
  physicalDeviceUniformBufferStandardLayoutFeatures as physicalDeviceUniformBufferStandardLayoutFeaturesKhr


