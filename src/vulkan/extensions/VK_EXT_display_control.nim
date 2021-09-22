# Generated at 2021-09-22T15:02:54Z
# VK_EXT_display_control


import ../platform
import ../features/vk10
import ./VK_EXT_display_surface_counter
import ./VK_KHR_swapchain
export VK_EXT_display_surface_counter
export VK_KHR_swapchain

const
  ExtDisplayControlSpecVersion* = 1
  ExtDisplayControlExtensionName* = "VK_EXT_display_control"

type # enums and bitmasks
  DisplayPowerStateEXT* {.size: sizeof(int32), pure.} = enum
    offExt = 0
    suspendExt = 1
    onExt = 2
  DeviceEventTypeEXT* {.size: sizeof(int32), pure.} = enum
    displayHotplugExt = 0
  DisplayEventTypeEXT* {.size: sizeof(int32), pure.} = enum
    firstPixelOutExt = 0

type
  DisplayPowerInfoEXT* = object
    sType* {.constant: (StructureType.displayPowerInfoExt).}: StructureType
    pNext* {.optional.}: pointer
    powerState*: DisplayPowerStateEXT
  DeviceEventInfoEXT* = object
    sType* {.constant: (StructureType.deviceEventInfoExt).}: StructureType
    pNext* {.optional.}: pointer
    deviceEvent*: DeviceEventTypeEXT
  DisplayEventInfoEXT* = object
    sType* {.constant: (StructureType.displayEventInfoExt).}: StructureType
    pNext* {.optional.}: pointer
    displayEvent*: DisplayEventTypeEXT
  SwapchainCounterCreateInfoEXT* = object
    sType* {.constant: (StructureType.swapchainCounterCreateInfoExt).}: StructureType
    pNext* {.optional.}: pointer
    surfaceCounters* {.optional.}: SurfaceCounterFlagsEXT

proc displayPowerControlEXT*(
      device: Device;
      display: DisplayKHR;
      pDisplayPowerInfo: ptr DisplayPowerInfoEXT;
    ): Result {.cdecl, lazyload("vkDisplayPowerControlEXT", DeviceLevel).}
proc registerDeviceEventEXT*(
      device: Device;
      pDeviceEventInfo: ptr DeviceEventInfoEXT;
      pAllocator = default(ptr AllocationCallbacks);
      pFence: ptr Fence;
    ): Result {.cdecl, lazyload("vkRegisterDeviceEventEXT", DeviceLevel).}
proc registerDisplayEventEXT*(
      device: Device;
      display: DisplayKHR;
      pDisplayEventInfo: ptr DisplayEventInfoEXT;
      pAllocator = default(ptr AllocationCallbacks);
      pFence: ptr Fence;
    ): Result {.cdecl, lazyload("vkRegisterDisplayEventEXT", DeviceLevel).}
proc getSwapchainCounterEXT*(
      device: Device;
      swapchain: SwapchainKHR;
      counter: SurfaceCounterFlagBitsEXT;
      pCounterValue: ptr uint64;
    ): Result {.cdecl, lazyload("vkGetSwapchainCounterEXT", DeviceLevel).}

proc loadAllVK_EXT_display_control*(instance: Instance) =
  displayPowerControlEXT.load(instance)
  registerDeviceEventEXT.load(instance)
  registerDisplayEventEXT.load(instance)
  getSwapchainCounterEXT.load(instance)

proc loadVK_EXT_display_control*(device: Device) =
  displayPowerControlEXT.load(device)
  registerDeviceEventEXT.load(device)
  registerDisplayEventEXT.load(device)
  getSwapchainCounterEXT.load(device)

