# Generated at 2021-10-24T02:03:03Z
# VK_NV_external_memory

import ../platform
import ../features/vk10
import ./VK_NV_external_memory_capabilities
export VK_NV_external_memory_capabilities

prepareVulkanLibDef()

const
  NvExternalMemorySpecVersion* = 1
  NvExternalMemoryExtensionName* = "VK_NV_external_memory"

type
  ExternalMemoryImageCreateInfoNV* = object
    sType* {.constant: (StructureType.externalMemoryImageCreateInfoNv).}: StructureType
    pNext* {.optional.}: pointer
    handleTypes* {.optional.}: ExternalMemoryHandleTypeFlagsNV
  ExportMemoryAllocateInfoNV* = object
    sType* {.constant: (StructureType.exportMemoryAllocateInfoNv).}: StructureType
    pNext* {.optional.}: pointer
    handleTypes* {.optional.}: ExternalMemoryHandleTypeFlagsNV



