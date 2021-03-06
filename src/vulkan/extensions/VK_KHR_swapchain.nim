# Generated at 2021-10-24T09:33:17Z
# VK_KHR_swapchain

import ../platform
import ../features/vk10
import ./VK_KHR_surface
export VK_KHR_surface

prepareVulkanLibDef()

const
  KhrSwapchainSpecVersion* = 70
  KhrSwapchainExtensionName* = "VK_KHR_swapchain"

  MaxDeviceGroupSize* = 32

type # enums and bitmasks
  SwapchainCreateFlagBitsKHR* {.size: sizeof(int32), pure.} = enum
    # Provided by VK_KHR_swapchain
    splitInstanceBindRegionsKhr = 0x00000001 # Allow images with VK_IMAGE_CREATE_SPLIT_INSTANCE_BIND_REGIONS_BIT
    # Provided by VK_KHR_swapchain
    protectedKhr = 0x00000002 # Swapchain is protected
    # Provided by VK_KHR_swapchain_mutable_format
    mutableFormatKhr = 0x00000004
  SwapchainCreateFlagsKHR* = Flags[SwapchainCreateFlagBitsKHR]

  DeviceGroupPresentModeFlagBitsKHR* {.size: sizeof(int32), pure.} = enum
    localKhr = 0x00000001 # Present from local memory
    remoteKhr = 0x00000002 # Present from remote memory
    sumKhr = 0x00000004 # Present sum of local and/or remote memory
    localMultiDeviceKhr = 0x00000008 # Each physical device presents from local memory
  DeviceGroupPresentModeFlagsKHR* = Flags[DeviceGroupPresentModeFlagBitsKHR]

type
  SwapchainCreateInfoKHR* = object
    sType* {.constant: (StructureType.swapchainCreateInfoKhr).}: StructureType
    pNext* {.optional.}: pointer
    flags* {.optional.}: SwapchainCreateFlagsKHR
    surface*: SurfaceKHR
    minImageCount*: uint32
    imageFormat*: Format
    imageColorSpace*: ColorSpaceKHR
    imageExtent*: Extent2D
    imageArrayLayers*: uint32
    imageUsage*: ImageUsageFlags
    imageSharingMode*: SharingMode
    queueFamilyIndexCount* {.optional.}: uint32
    pQueueFamilyIndices* {.length: queueFamilyIndexCount.}: arrPtr[uint32]
    preTransform*: SurfaceTransformFlagBitsKHR
    compositeAlpha*: CompositeAlphaFlagBitsKHR
    presentMode*: PresentModeKHR
    clipped*: Bool32
    oldSwapchain* {.optional.}: SwapchainKHR
  HtSwapchainKHR* = object of HandleType
  SwapchainKHR* = NonDispatchableHandle[HtSwapchainKHR]
  PresentInfoKHR* = object
    sType* {.constant: (StructureType.presentInfoKhr).}: StructureType
    pNext* {.optional.}: pointer
    waitSemaphoreCount* {.optional.}: uint32
    pWaitSemaphores* {.length: waitSemaphoreCount.}: arrPtr[Semaphore]
    swapchainCount*: uint32
    pSwapchains* {.length: swapchainCount.}: arrPtr[SwapchainKHR]
    pImageIndices* {.length: swapchainCount.}: arrPtr[uint32]
    pResults* {.optional, length: swapchainCount.}: arrPtr[Result]

  ImageSwapchainCreateInfoKHR* = object
    sType* {.constant: (StructureType.imageSwapchainCreateInfoKhr).}: StructureType
    pNext* {.optional.}: pointer
    swapchain* {.optional.}: SwapchainKHR
  BindImageMemorySwapchainInfoKHR* = object
    sType* {.constant: (StructureType.bindImageMemorySwapchainInfoKhr).}: StructureType
    pNext* {.optional.}: pointer
    swapchain*: SwapchainKHR
    imageIndex*: uint32
  AcquireNextImageInfoKHR* = object
    sType* {.constant: (StructureType.acquireNextImageInfoKhr).}: StructureType
    pNext* {.optional.}: pointer
    swapchain*: SwapchainKHR
    timeout*: uint64
    semaphore* {.optional.}: Semaphore
    fence* {.optional.}: Fence
    deviceMask*: uint32
  DeviceGroupPresentCapabilitiesKHR* = object
    sType* {.constant: (StructureType.deviceGroupPresentCapabilitiesKhr).}: StructureType
    pNext* {.optional.}: pointer
    presentMask*: array[MaxDeviceGroupSize, uint32]
    modes*: DeviceGroupPresentModeFlagsKHR
  DeviceGroupPresentInfoKHR* = object
    sType* {.constant: (StructureType.deviceGroupPresentInfoKhr).}: StructureType
    pNext* {.optional.}: pointer
    swapchainCount* {.optional.}: uint32
    pDeviceMasks* {.length: swapchainCount.}: arrPtr[uint32]
    mode*: DeviceGroupPresentModeFlagBitsKHR
  DeviceGroupSwapchainCreateInfoKHR* = object
    sType* {.constant: (StructureType.deviceGroupSwapchainCreateInfoKhr).}: StructureType
    pNext* {.optional.}: pointer
    modes*: DeviceGroupPresentModeFlagsKHR

proc createSwapchainKHR*(
      device: Device;
      pCreateInfo: ptr SwapchainCreateInfoKHR;
      pAllocator = default(ptr AllocationCallbacks);
      pSwapchain: ptr SwapchainKHR;
    ): Result {.cdecl,
      successCodes(success),
      errorCodes(errorOutOfHostMemory, errorOutOfDeviceMemory, errorDeviceLost, errorSurfaceLostKhr, errorNativeWindowInUseKhr, errorInitializationFailed),
      lazyload("vkCreateSwapchainKHR", DeviceLevel).}
proc destroySwapchainKHR*(
      device: Device;
      swapchain = default(SwapchainKHR);
      pAllocator = default(ptr AllocationCallbacks);
    ): void {.cdecl, lazyload("vkDestroySwapchainKHR", DeviceLevel).}
proc getSwapchainImagesKHR*(
      device: Device;
      swapchain: SwapchainKHR;
      pSwapchainImageCount: ptr uint32;
      pSwapchainImages {.length: pSwapchainImageCount.} = default(arrPtr[Image]);
    ): Result {.cdecl,
      successCodes(success, incomplete),
      errorCodes(errorOutOfHostMemory, errorOutOfDeviceMemory),
      lazyload("vkGetSwapchainImagesKHR", DeviceLevel).}
proc acquireNextImageKHR*(
      device: Device;
      swapchain: SwapchainKHR;
      timeout: uint64;
      semaphore = default(Semaphore);
      fence = default(Fence);
      pImageIndex: ptr uint32;
    ): Result {.cdecl,
      successCodes(success, timeout, notReady, suboptimalKhr),
      errorCodes(errorOutOfHostMemory, errorOutOfDeviceMemory, errorDeviceLost, errorOutOfDateKhr, errorSurfaceLostKhr, errorFullScreenExclusiveModeLostExt),
      lazyload("vkAcquireNextImageKHR", DeviceLevel).}
proc queuePresentKHR*(
      queue: Queue;
      pPresentInfo: ptr PresentInfoKHR;
    ): Result {.cdecl,
      successCodes(success, suboptimalKhr),
      errorCodes(errorOutOfHostMemory, errorOutOfDeviceMemory, errorDeviceLost, errorOutOfDateKhr, errorSurfaceLostKhr, errorFullScreenExclusiveModeLostExt),
      lazyload("vkQueuePresentKHR", DeviceLevel).}


proc getDeviceGroupPresentCapabilitiesKHR*(
      device: Device;
      pDeviceGroupPresentCapabilities: ptr DeviceGroupPresentCapabilitiesKHR;
    ): Result {.cdecl,
      successCodes(success),
      errorCodes(errorOutOfHostMemory, errorOutOfDeviceMemory),
      lazyload("vkGetDeviceGroupPresentCapabilitiesKHR", DeviceLevel).}
proc getDeviceGroupSurfacePresentModesKHR*(
      device: Device;
      surface: SurfaceKHR;
      pModes: ptr DeviceGroupPresentModeFlagsKHR;
    ): Result {.cdecl,
      successCodes(success),
      errorCodes(errorOutOfHostMemory, errorOutOfDeviceMemory, errorSurfaceLostKhr),
      lazyload("vkGetDeviceGroupSurfacePresentModesKHR", DeviceLevel).}
proc getPhysicalDevicePresentRectanglesKHR*(
      physicalDevice: PhysicalDevice;
      surface: SurfaceKHR;
      pRectCount: ptr uint32;
      pRects {.length: pRectCount.} = default(arrPtr[Rect2D]);
    ): Result {.cdecl,
      successCodes(success, incomplete),
      errorCodes(errorOutOfHostMemory, errorOutOfDeviceMemory),
      lazyload("vkGetPhysicalDevicePresentRectanglesKHR", InstanceLevel).}
proc acquireNextImage2KHR*(
      device: Device;
      pAcquireInfo: ptr AcquireNextImageInfoKHR;
      pImageIndex: ptr uint32;
    ): Result {.cdecl,
      successCodes(success, timeout, notReady, suboptimalKhr),
      errorCodes(errorOutOfHostMemory, errorOutOfDeviceMemory, errorDeviceLost, errorOutOfDateKhr, errorSurfaceLostKhr, errorFullScreenExclusiveModeLostExt),
      lazyload("vkAcquireNextImage2KHR", DeviceLevel).}

proc loadAllVK_KHR_swapchain*(instance: Instance) =
  instance.loadCommand createSwapchainKHR
  instance.loadCommand destroySwapchainKHR
  instance.loadCommand getSwapchainImagesKHR
  instance.loadCommand acquireNextImageKHR
  instance.loadCommand queuePresentKHR

  instance.loadCommand getDeviceGroupPresentCapabilitiesKHR
  instance.loadCommand getDeviceGroupSurfacePresentModesKHR
  instance.loadCommand getPhysicalDevicePresentRectanglesKHR
  instance.loadCommand acquireNextImage2KHR

proc loadVK_KHR_swapchain*(instance: Instance) =
  instance.loadCommand getPhysicalDevicePresentRectanglesKHR

proc loadVK_KHR_swapchain*(device: Device) =
  device.loadCommand createSwapchainKHR
  device.loadCommand destroySwapchainKHR
  device.loadCommand getSwapchainImagesKHR
  device.loadCommand acquireNextImageKHR
  device.loadCommand queuePresentKHR

  device.loadCommand getDeviceGroupPresentCapabilitiesKHR
  device.loadCommand getDeviceGroupSurfacePresentModesKHR
  device.loadCommand acquireNextImage2KHR

