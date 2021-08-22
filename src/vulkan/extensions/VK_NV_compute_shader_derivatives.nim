
import ../platform
import ../features/vk10
import VK_KHR_get_physical_device_properties2


type
  PhysicalDeviceComputeShaderDerivativesFeaturesNV* = object
    sType*: StructureType
    pNext*: pointer
    computeDerivativeGroupQuads*: Bool32
    computeDerivativeGroupLinear*: Bool32

const NvComputeShaderDerivativesExtensionName* = "VK_NV_compute_shader_derivatives"
const NvComputeShaderDerivativesSpecVersion* = 1

