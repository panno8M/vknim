# Generated at 2021-09-16T08:32:06Z
# VK_EXT_validation_cache


import ../platform
import ../features/vk10

const
  ExtValidationCacheSpecVersion* = 1
  ExtValidationCacheExtensionName* = "VK_EXT_validation_cache"

type # enums and bitmasks
  ValidationCacheHeaderVersionEXT* {.size: sizeof(int32), pure.} = enum
    oneExt = 1
  ValidationCacheCreateFlagsEXT* = Flags[distinct UnusedEnum]

type
  HtValidationCacheEXT = object of HandleType
  ValidationCacheEXT* = NonDispatchableHandle[HtValidationCacheEXT]
  ValidationCacheCreateInfoEXT* = object
    sType* {.constant: (StructureType.validationCacheCreateInfoExt).}: StructureType
    pNext* {.optional.}: pointer
    flags* {.optional.}: ValidationCacheCreateFlagsEXT
    initialDataSize* {.optional.}: uint
    pInitialData*: pointer
  ShaderModuleValidationCacheCreateInfoEXT* = object
    sType* {.constant: (StructureType.shaderModuleValidationCacheCreateInfoExt).}: StructureType
    pNext* {.optional.}: pointer
    validationCache*: ValidationCacheEXT

proc createValidationCacheEXT*(
      device: Device;
      pCreateInfo: ptr ValidationCacheCreateInfoEXT;
      pAllocator = default(ptr AllocationCallbacks);
      pValidationCache: ptr ValidationCacheEXT;
    ): Result {.cdecl, lazyload("vkCreateValidationCacheEXT", DeviceLevel).}
proc destroyValidationCacheEXT*(
      device: Device;
      validationCache = default(ValidationCacheEXT);
      pAllocator = default(ptr AllocationCallbacks);
    ): void {.cdecl, lazyload("vkDestroyValidationCacheEXT", DeviceLevel).}
proc mergeValidationCachesEXT*(
      device: Device;
      dstCache: ValidationCacheEXT;
      srcCacheCount: uint32;
      pSrcCaches {.length: srcCacheCount.}: ptr ValidationCacheEXT;
    ): Result {.cdecl, lazyload("vkMergeValidationCachesEXT", DeviceLevel).}
proc getValidationCacheDataEXT*(
      device: Device;
      validationCache: ValidationCacheEXT;
      pDataSize: ptr uint;
      pData {.length: pDataSize.} = default(pointer);
    ): Result {.cdecl, lazyload("vkGetValidationCacheDataEXT", DeviceLevel).}

proc loadAllVK_EXT_validation_cache*(instance: Instance) =
  createValidationCacheEXT.load(instance)
  destroyValidationCacheEXT.load(instance)
  mergeValidationCachesEXT.load(instance)
  getValidationCacheDataEXT.load(instance)

proc loadVK_EXT_validation_cache*(device: Device) =
  createValidationCacheEXT.load(device)
  destroyValidationCacheEXT.load(device)
  mergeValidationCachesEXT.load(device)
  getValidationCacheDataEXT.load(device)

