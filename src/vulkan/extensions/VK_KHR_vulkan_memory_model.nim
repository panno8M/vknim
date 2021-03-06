# Generated at 2021-10-24T02:03:04Z
# VK_KHR_vulkan_memory_model

import ../platform
import ../features/vk10
import ../features/vk12

prepareVulkanLibDef()

const
  KhrVulkanMemoryModelSpecVersion* = 3
  KhrVulkanMemoryModelExtensionName* = "VK_KHR_vulkan_memory_model"

type
  PhysicalDeviceVulkanMemoryModelFeaturesKHR* = object

StructureType.defineAliases:
  physicalDeviceVulkanMemoryModelFeatures as physicalDeviceVulkanMemoryModelFeaturesKhr


