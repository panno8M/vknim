
import ../platform
import ../features/vk10
import VK_KHR_swapchain
import VK_KHR_display


type
  DisplayPresentInfoKHR* = object
    sType*: StructureType
    pNext*: pointer
    srcRect*: Rect2D
    dstRect*: Rect2D
    persistent*: Bool32

const KhrDisplaySwapchainSpecVersion* = 10
const KhrDisplaySwapchainExtensionName* = "VK_KHR_display_swapchain"
var # commands
  createSharedSwapchainsKHRCage: proc(device: Device; swapchainCount: uint32; pCreateInfos: ptr SwapchainCreateInfoKHR; pAllocator: ptr AllocationCallbacks; pSwapchains: ptr SwapchainKHR;): Result {.cdecl.}

proc createSharedSwapchainsKHR*(
      device: Device;
      swapchainCount: uint32;
      pCreateInfos: ptr SwapchainCreateInfoKHR;
      pAllocator: ptr AllocationCallbacks;
      pSwapchains: ptr SwapchainKHR;
    ): Result {.cdecl.} =
  createSharedSwapchainsKHRCage(device,swapchainCount,pCreateInfos,pAllocator,pSwapchains)


proc loadVK_KHR_display_swapchain*(instance: Instance) =
  instance.defineLoader(`<<`)

  createSharedSwapchainsKHRCage << "vkCreateSharedSwapchainsKHR"