# Generated at 2021-10-24T02:03:03Z
# VK_KHR_depth_stencil_resolve

import ../platform
import ../features/vk10
import ./VK_KHR_create_renderpass2
import ../features/vk12
export VK_KHR_create_renderpass2

prepareVulkanLibDef()

const
  KhrDepthStencilResolveSpecVersion* = 1
  KhrDepthStencilResolveExtensionName* = "VK_KHR_depth_stencil_resolve"

type # enums and bitmasks
  ResolveModeFlagBitsKHR* = distinct UnusedEnum
  ResolveModeFlagsKHR* = ResolveModeFlags

type
  SubpassDescriptionDepthStencilResolveKHR* = object
  PhysicalDeviceDepthStencilResolvePropertiesKHR* = object

ResolveModeFlagBits.defineAliases:
  none as noneKhr
  sampleZero as sampleZeroKhr
  average as averageKhr
  min as minKhr
  max as maxKhr

StructureType.defineAliases:
  physicalDeviceDepthStencilResolveProperties as physicalDeviceDepthStencilResolvePropertiesKhr
  subpassDescriptionDepthStencilResolve as subpassDescriptionDepthStencilResolveKhr


