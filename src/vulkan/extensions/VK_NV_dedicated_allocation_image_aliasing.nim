# Generated at 2021-10-24T02:03:04Z
# VK_NV_dedicated_allocation_image_aliasing

import ../platform
import ../features/vk10
import ./VK_KHR_dedicated_allocation
export VK_KHR_dedicated_allocation

prepareVulkanLibDef()

const
  NvDedicatedAllocationImageAliasingSpecVersion* = 1
  NvDedicatedAllocationImageAliasingExtensionName* = "VK_NV_dedicated_allocation_image_aliasing"

type
  PhysicalDeviceDedicatedAllocationImageAliasingFeaturesNV* = object
    sType* {.constant: (StructureType.physicalDeviceDedicatedAllocationImageAliasingFeaturesNv).}: StructureType
    pNext* {.optional.}: pointer
    dedicatedAllocationImageAliasing*: Bool32



