# Generated at 2021-10-24T02:03:03Z
# VK_EXT_shader_atomic_float

import ../platform
import ../features/vk10
import ./VK_KHR_get_physical_device_properties2
export VK_KHR_get_physical_device_properties2

prepareVulkanLibDef()

const
  ExtShaderAtomicFloatSpecVersion* = 1
  ExtShaderAtomicFloatExtensionName* = "VK_EXT_shader_atomic_float"

type
  PhysicalDeviceShaderAtomicFloatFeaturesEXT* = object
    sType* {.constant: (StructureType.physicalDeviceShaderAtomicFloatFeaturesExt).}: StructureType
    pNext* {.optional.}: pointer
    shaderBufferFloat32Atomics*: Bool32
    shaderBufferFloat32AtomicAdd*: Bool32
    shaderBufferFloat64Atomics*: Bool32
    shaderBufferFloat64AtomicAdd*: Bool32
    shaderSharedFloat32Atomics*: Bool32
    shaderSharedFloat32AtomicAdd*: Bool32
    shaderSharedFloat64Atomics*: Bool32
    shaderSharedFloat64AtomicAdd*: Bool32
    shaderImageFloat32Atomics*: Bool32
    shaderImageFloat32AtomicAdd*: Bool32
    sparseImageFloat32Atomics*: Bool32
    sparseImageFloat32AtomicAdd*: Bool32



