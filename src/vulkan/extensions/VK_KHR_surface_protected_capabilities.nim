# Generated at 2021-12-25T14:19:30Z
# VK_KHR_surface_protected_capabilities

import ../platform
import ../features/vk10
import ./VK_KHR_get_surface_capabilities2
export VK_KHR_get_surface_capabilities2

prepareVulkanLibDef()

const
  KhrSurfaceProtectedCapabilitiesSpecVersion* = 1
  KhrSurfaceProtectedCapabilitiesExtensionName* = "VK_KHR_surface_protected_capabilities"

type
  SurfaceProtectedCapabilitiesKHR* = object
    sType* {.constant: (StructureType.surfaceProtectedCapabilitiesKhr).}: StructureType
    pNext* {.optional.}: pointer
    supportsProtected*: Bool32



