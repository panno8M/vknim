# Generated at 2021-10-24T02:03:03Z
# VK_NV_shader_sm_builtins

import ../platform
import ../features/vk10

prepareVulkanLibDef()

const
  NvShaderSmBuiltinsSpecVersion* = 1
  NvShaderSmBuiltinsExtensionName* = "VK_NV_shader_sm_builtins"

type
  PhysicalDeviceShaderSMBuiltinsPropertiesNV* = object
    sType* {.constant: (StructureType.physicalDeviceShaderSmBuiltinsPropertiesNv).}: StructureType
    pNext* {.optional.}: pointer
    shaderSMCount*: uint32
    shaderWarpsPerSM*: uint32
  PhysicalDeviceShaderSMBuiltinsFeaturesNV* = object
    sType* {.constant: (StructureType.physicalDeviceShaderSmBuiltinsFeaturesNv).}: StructureType
    pNext* {.optional.}: pointer
    shaderSMBuiltins*: Bool32



