# Generated at 2021-12-26T16:57:01Z
# VK_FUCHSIA_external_memory

import ../platform

import ../features/vk10
import ./VK_KHR_external_memory_capabilities
import ./VK_KHR_external_memory
export VK_KHR_external_memory_capabilities
export VK_KHR_external_memory
prepareVulkanLibDef()

const
  FuchsiaExternalMemorySpecVersion* = 1
  FuchsiaExternalMemoryExtensionName* = "VK_FUCHSIA_external_memory"

type
  ImportMemoryZirconHandleInfoFUCHSIA* = object
    sType* {.constant: (StructureType.importMemoryZirconHandleInfoFuchsia).}: StructureType
    pNext* {.optional.}: pointer
    handleType* {.optional.}: ExternalMemoryHandleTypeFlagBits
    handle* {.optional.}: zx_handle_t
  MemoryZirconHandlePropertiesFUCHSIA* = object
    sType* {.constant: (StructureType.memoryZirconHandlePropertiesFuchsia).}: StructureType
    pNext* {.optional.}: pointer
    memoryTypeBits*: uint32
  MemoryGetZirconHandleInfoFUCHSIA* = object
    sType* {.constant: (StructureType.memoryGetZirconHandleInfoFuchsia).}: StructureType
    pNext* {.optional.}: pointer
    memory*: DeviceMemory
    handleType*: ExternalMemoryHandleTypeFlagBits

proc getMemoryZirconHandleFUCHSIA*(
      device: Device;
      pGetZirconHandleInfo: ptr MemoryGetZirconHandleInfoFUCHSIA;
      pZirconHandle: ptr zx_handle_t;
    ): Result {.cdecl,
      successCodes(success),
      errorCodes(errorTooManyObjects, errorOutOfHostMemory),
      lazyload("vkGetMemoryZirconHandleFUCHSIA", DeviceLevel).}
proc getMemoryZirconHandlePropertiesFUCHSIA*(
      device: Device;
      handleType: ExternalMemoryHandleTypeFlagBits;
      zirconHandle: zx_handle_t;
      pMemoryZirconHandleProperties: ptr MemoryZirconHandlePropertiesFUCHSIA;
    ): Result {.cdecl,
      successCodes(success),
      errorCodes(errorInvalidExternalHandle),
      lazyload("vkGetMemoryZirconHandlePropertiesFUCHSIA", DeviceLevel).}

proc loadAllVK_FUCHSIA_external_memory*(instance: Instance) =
  instance.loadCommand getMemoryZirconHandleFUCHSIA
  instance.loadCommand getMemoryZirconHandlePropertiesFUCHSIA

proc loadVK_FUCHSIA_external_memory*(device: Device) =
  device.loadCommand getMemoryZirconHandleFUCHSIA
  device.loadCommand getMemoryZirconHandlePropertiesFUCHSIA
