# Generated at 2021-10-24T02:03:03Z
# VK_AMD_shader_core_properties

import ../platform
import ../features/vk10
import ./VK_KHR_get_physical_device_properties2
export VK_KHR_get_physical_device_properties2

prepareVulkanLibDef()

const
  AmdShaderCorePropertiesSpecVersion* = 2
  AmdShaderCorePropertiesExtensionName* = "VK_AMD_shader_core_properties"

type
  PhysicalDeviceShaderCorePropertiesAMD* = object
    sType* {.constant: (StructureType.physicalDeviceShaderCorePropertiesAmd).}: StructureType
    pNext* {.optional.}: pointer
    shaderEngineCount*: uint32
    shaderArraysPerEngineCount*: uint32
    computeUnitsPerShaderArray*: uint32
    simdPerComputeUnit*: uint32
    wavefrontsPerSimd*: uint32
    wavefrontSize*: uint32
    sgprsPerSimd*: uint32
    minSgprAllocation*: uint32
    maxSgprAllocation*: uint32
    sgprAllocationGranularity*: uint32
    vgprsPerSimd*: uint32
    minVgprAllocation*: uint32
    maxVgprAllocation*: uint32
    vgprAllocationGranularity*: uint32



