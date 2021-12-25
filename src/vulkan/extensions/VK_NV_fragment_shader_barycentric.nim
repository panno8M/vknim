# Generated at 2021-12-25T14:19:30Z
# VK_NV_fragment_shader_barycentric

import ../platform
import ../features/vk10
import ./VK_KHR_get_physical_device_properties2
export VK_KHR_get_physical_device_properties2

prepareVulkanLibDef()

const
  NvFragmentShaderBarycentricSpecVersion* = 1
  NvFragmentShaderBarycentricExtensionName* = "VK_NV_fragment_shader_barycentric"

type
  PhysicalDeviceFragmentShaderBarycentricFeaturesNV* = object
    sType* {.constant: (StructureType.physicalDeviceFragmentShaderBarycentricFeaturesNv).}: StructureType
    pNext* {.optional.}: pointer
    fragmentShaderBarycentric*: Bool32



