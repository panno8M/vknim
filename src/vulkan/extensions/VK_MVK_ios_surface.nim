# Generated at 2021-10-24T09:33:17Z
# VK_MVK_ios_surface

import ../platform
import ../features/vk10
import ./VK_KHR_surface
export VK_KHR_surface

prepareVulkanLibDef()

const
  MiosSurfaceSpecVersion* = 3
  MiosSurfaceExtensionName* = "VK_MVK_ios_surface"

type # enums and bitmasks
  IOSSurfaceCreateFlagsMVK* = Flags[distinct UnusedEnum]

type
  IOSSurfaceCreateInfoMVK* = object
    sType* {.constant: (StructureType.iosSurfaceCreateInfoM).}: StructureType
    pNext* {.optional.}: pointer
    flags* {.optional.}: IOSSurfaceCreateFlagsMVK
    pView*: pointer

proc createIOSSurfaceMVK*(
      instance: Instance;
      pCreateInfo: ptr IOSSurfaceCreateInfoMVK;
      pAllocator = default(ptr AllocationCallbacks);
      pSurface: ptr SurfaceKHR;
    ): Result {.cdecl,
      successCodes(success),
      errorCodes(errorOutOfHostMemory, errorOutOfDeviceMemory, errorNativeWindowInUseKhr),
      lazyload("vkCreateIOSSurfaceMVK", InstanceLevel).}

proc loadAllVK_MVK_ios_surface*(instance: Instance) =
  instance.loadCommand createIOSSurfaceMVK

proc loadVK_MVK_ios_surface*(instance: Instance) =
  instance.loadCommand createIOSSurfaceMVK

