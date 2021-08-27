
import ../platform
import ../features/vk10


const
  NvDedicatedAllocationSpecVersion* = 1
  NvDedicatedAllocationExtensionName* = "VK_NV_dedicated_allocation"

type
  DedicatedAllocationImageCreateInfoNV* = object
    sType*: StructureType
    pNext*: pointer
    dedicatedAllocation*: Bool32
  DedicatedAllocationBufferCreateInfoNV* = object
    sType*: StructureType
    pNext*: pointer
    dedicatedAllocation*: Bool32
  DedicatedAllocationMemoryAllocateInfoNV* = object
    sType*: StructureType
    pNext*: pointer
    image*: Image
    buffer*: Buffer


