# Generated at 2021-10-24T02:03:04Z
# VK_KHR_external_fence

import ../platform
import ../features/vk10
import ./VK_KHR_external_fence_capabilities
import ../features/vk11
export VK_KHR_external_fence_capabilities

prepareVulkanLibDef()

const
  KhrExternalFenceSpecVersion* = 1
  KhrExternalFenceExtensionName* = "VK_KHR_external_fence"

type # enums and bitmasks
  FenceImportFlagsKHR* = FenceImportFlags
  FenceImportFlagBitsKHR* = distinct UnusedEnum

type
  ExportFenceCreateInfoKHR* = object

StructureType.defineAliases:
  exportFenceCreateInfo as exportFenceCreateInfoKhr

FenceImportFlagBits.defineAliases:
  temporary as temporaryKhr


