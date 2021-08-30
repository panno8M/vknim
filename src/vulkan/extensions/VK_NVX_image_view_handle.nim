# Generated at 2021-08-30T22:51:48Z
# VK_NVX_image_view_handle


import ../platform
import ../features/vk10

const
  NvxImageViewHandleSpecVersion* = 2
  NvxImageViewHandleExtensionName* = "VK_NVX_image_view_handle"

type
  ImageViewHandleInfoNVX* = object
    sType*: StructureType
    pNext*: pointer
    imageView*: ImageView
    descriptorType*: DescriptorType
    sampler*: Sampler
  ImageViewAddressPropertiesNVX* = object
    sType*: StructureType
    pNext*: pointer
    deviceAddress*: DeviceAddress
    size*: DeviceSize

var # command cages
  getImageViewHandleNVXCage: proc(device: Device; pInfo: ptr ImageViewHandleInfoNVX;): uint32 {.cdecl.}
  getImageViewAddressNVXCage: proc(device: Device; imageView: ImageView; pProperties: ptr ImageViewAddressPropertiesNVX;): Result {.cdecl.}
proc getImageViewHandleNVX*(
      device: Device;
      pInfo: ptr ImageViewHandleInfoNVX;
    ): uint32 {.cdecl.} =
  getImageViewHandleNVXCage(device,pInfo)
proc getImageViewAddressNVX*(
      device: Device;
      imageView: ImageView;
      pProperties: ptr ImageViewAddressPropertiesNVX;
    ): Result {.cdecl, discardable.} =
  getImageViewAddressNVXCage(device,imageView,pProperties)
proc loadVK_NVX_image_view_handle*(instance: Instance) =
  instance.defineLoader(`<<`)

  getImageViewHandleNVXCage << "vkGetImageViewHandleNVX"
  getImageViewAddressNVXCage << "vkGetImageViewAddressNVX"