# Generated at 2021-12-31T11:28:24Z
# VK_KHR_device_group

import ../platform

import ../features/vk10
import ./VK_KHR_device_group_creation
import ../features/vk11
import ./VK_KHR_bind_memory2
import ./VK_KHR_surface
import ./VK_KHR_swapchain
export VK_KHR_device_group_creation
export VK_KHR_bind_memory2
export VK_KHR_surface
export VK_KHR_swapchain
prepareVulkanLibDef()

const
  KhrDeviceGroupSpecVersion* = 4
  KhrDeviceGroupExtensionName* = "VK_KHR_device_group"

type
  MemoryAllocateFlagsInfoKHR* = object
  DeviceGroupRenderPassBeginInfoKHR* = object
  DeviceGroupCommandBufferBeginInfoKHR* = object
  DeviceGroupSubmitInfoKHR* = object
  DeviceGroupBindSparseInfoKHR* = object

  BindBufferMemoryDeviceGroupInfoKHR* = object
  BindImageMemoryDeviceGroupInfoKHR* = object

  DeviceGroupPresentCapabilitiesKHR* = object
    sType* {.constant: (StructureType.deviceGroupPresentCapabilitiesKhr).}: StructureType
    pNext* {.optional.}: pointer
    presentMask*: array[MaxDeviceGroupSize, uint32]
    modes*: DeviceGroupPresentModeFlagsKHR

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

const getDeviceGroupPeerMemoryFeaturesKHR* = getDeviceGroupPeerMemoryFeatures
const cmdSetDeviceMaskKHR* = cmdSetDeviceMask
const cmdDispatchBaseKHR* = cmdDispatchBase


proc getDeviceGroupPresentCapabilitiesKHR*(
      device: Device;
      pDeviceGroupPresentCapabilities: ptr DeviceGroupPresentCapabilitiesKHR;
    ): Result {.cdecl,
      successCodes: @[Result.success],
      errorCodes: @[Result.errorOutOfHostMemory, Result.errorOutOfDeviceMemory],
      lazyload("vkGetDeviceGroupPresentCapabilitiesKHR", DeviceLevel).}
proc getDeviceGroupSurfacePresentModesKHR*(
      device: Device;
      surface: SurfaceKHR;
      pModes: ptr DeviceGroupPresentModeFlagsKHR;
    ): Result {.cdecl,
      successCodes: @[Result.success],
      errorCodes: @[Result.errorOutOfHostMemory, Result.errorOutOfDeviceMemory, Result.errorSurfaceLostKhr],
      lazyload("vkGetDeviceGroupSurfacePresentModesKHR", DeviceLevel).}
proc getPhysicalDevicePresentRectanglesKHR*(
      physicalDevice: PhysicalDevice;
      surface: SurfaceKHR;
      pRectCount: ptr uint32;
      pRects {.length: pRectCount.} = default(arrPtr[Rect2D]);
    ): Result {.cdecl,
      successCodes: @[Result.success, Result.incomplete],
      errorCodes: @[Result.errorOutOfHostMemory, Result.errorOutOfDeviceMemory],
      lazyload("vkGetPhysicalDevicePresentRectanglesKHR", InstanceLevel).}


proc acquireNextImage2KHR*(
      device: Device;
      pAcquireInfo: ptr AcquireNextImageInfoKHR;
      pImageIndex: ptr uint32;
    ): Result {.cdecl,
      successCodes: @[Result.success, Result.timeout, Result.notReady, Result.suboptimalKhr],
      errorCodes: @[Result.errorOutOfHostMemory, Result.errorOutOfDeviceMemory, Result.errorDeviceLost, Result.errorOutOfDateKhr, Result.errorSurfaceLostKhr, Result.errorFullScreenExclusiveModeLostExt],
      lazyload("vkAcquireNextImage2KHR", DeviceLevel).}

proc loadAllVK_KHR_device_group*(instance: Instance) = instance.loadCommands:
  getDeviceGroupPresentCapabilitiesKHR
  getDeviceGroupSurfacePresentModesKHR
  getPhysicalDevicePresentRectanglesKHR
  acquireNextImage2KHR
proc loadVK_KHR_device_group*(instance: Instance) = instance.loadCommands:
  getPhysicalDevicePresentRectanglesKHR
proc loadVK_KHR_device_group*(device: Device) = device.loadCommands:
  getDeviceGroupPresentCapabilitiesKHR
  getDeviceGroupSurfacePresentModesKHR
  acquireNextImage2KHR
