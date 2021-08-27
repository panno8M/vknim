
import ../platform
import ../features/vk10
import VK_AMD_shader_core_properties


const
  AmdShaderCoreProperties2SpecVersion* = 1
  AmdShaderCoreProperties2ExtensionName* = "VK_AMD_shader_core_properties2"

type
  PhysicalDeviceShaderCoreProperties2AMD* = object
    sType*: StructureType
    pNext*: pointer
    shaderCoreFeatures*: ShaderCorePropertiesFlagsAMD
    activeComputeUnitCount*: uint32
  ShaderCorePropertiesFlagBitsAMD* = UnusedEnum
  ShaderCorePropertiesFlagsAMD* = distinct Flags


