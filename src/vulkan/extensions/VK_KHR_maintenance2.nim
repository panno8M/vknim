# Generated at 2021-10-24T02:03:04Z
# VK_KHR_maintenance2

import ../platform
import ../features/vk10
import ../features/vk11

prepareVulkanLibDef()

const
  KhrMaintenance2SpecVersion* = 1
  KhrMaintenance2ExtensionName* = "VK_KHR_maintenance2"

type # enums and bitmasks
  PointClippingBehaviorKHR* = distinct UnusedEnum
  TessellationDomainOriginKHR* = distinct UnusedEnum

type
  PhysicalDevicePointClippingPropertiesKHR* = object
  RenderPassInputAttachmentAspectCreateInfoKHR* = object
  InputAttachmentAspectReferenceKHR* = object
  ImageViewUsageCreateInfoKHR* = object
  PipelineTessellationDomainOriginStateCreateInfoKHR* = object

PointClippingBehavior.defineAliases:
  allClipPlanes as allClipPlanesKhr
  userClipPlanesOnly as userClipPlanesOnlyKhr

StructureType.defineAliases:
  physicalDevicePointClippingProperties as physicalDevicePointClippingPropertiesKhr
  renderPassInputAttachmentAspectCreateInfo as renderPassInputAttachmentAspectCreateInfoKhr
  imageViewUsageCreateInfo as imageViewUsageCreateInfoKhr
  pipelineTessellationDomainOriginStateCreateInfo as pipelineTessellationDomainOriginStateCreateInfoKhr

TessellationDomainOrigin.defineAliases:
  upperLeft as upperLeftKhr
  lowerLeft as lowerLeftKhr

ImageCreateFlagBits.defineAliases:
  blockTexelViewCompatible as blockTexelViewCompatibleKhr
  extendedUsage as extendedUsageKhr

ImageLayout.defineAliases:
  depthReadOnlyStencilAttachmentOptimal as depthReadOnlyStencilAttachmentOptimalKhr
  depthAttachmentStencilReadOnlyOptimal as depthAttachmentStencilReadOnlyOptimalKhr


