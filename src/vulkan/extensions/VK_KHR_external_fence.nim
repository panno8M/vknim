# Generated at 2021-12-26T10:16:14Z
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

type
  ExportFenceCreateInfoKHR* = object



