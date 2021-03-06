# Generated at 2021-10-24T09:33:17Z
# VK_KHR_xlib_surface

import ../platform
import ../features/vk10
import ./VK_KHR_surface
export VK_KHR_surface

prepareVulkanLibDef()

const
  KhrXlibSurfaceSpecVersion* = 6
  KhrXlibSurfaceExtensionName* = "VK_KHR_xlib_surface"

type # enums and bitmasks
  XlibSurfaceCreateFlagsKHR* = Flags[distinct UnusedEnum]

type
  XlibSurfaceCreateInfoKHR* = object
    sType* {.constant: (StructureType.xlibSurfaceCreateInfoKhr).}: StructureType
    pNext* {.optional.}: pointer
    flags* {.optional.}: XlibSurfaceCreateFlagsKHR
    dpy*: ptr Display
    window*: Window

proc createXlibSurfaceKHR*(
      instance: Instance;
      pCreateInfo: ptr XlibSurfaceCreateInfoKHR;
      pAllocator = default(ptr AllocationCallbacks);
      pSurface: ptr SurfaceKHR;
    ): Result {.cdecl,
      successCodes(success),
      errorCodes(errorOutOfHostMemory, errorOutOfDeviceMemory),
      lazyload("vkCreateXlibSurfaceKHR", InstanceLevel).}
proc getPhysicalDeviceXlibPresentationSupportKHR*(
      physicalDevice: PhysicalDevice;
      queueFamilyIndex: uint32;
      dpy: ptr Display;
      visualID: VisualID;
    ): Bool32 {.cdecl, lazyload("vkGetPhysicalDeviceXlibPresentationSupportKHR", InstanceLevel).}

proc loadAllVK_KHR_xlib_surface*(instance: Instance) =
  instance.loadCommand createXlibSurfaceKHR
  instance.loadCommand getPhysicalDeviceXlibPresentationSupportKHR

proc loadVK_KHR_xlib_surface*(instance: Instance) =
  instance.loadCommand createXlibSurfaceKHR
  instance.loadCommand getPhysicalDeviceXlibPresentationSupportKHR

