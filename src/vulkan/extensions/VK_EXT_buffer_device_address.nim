# Generated at 2021-08-27T06:01:03Z
# VK_EXT_buffer_device_address
# =================================

import ../platform
import ../features/vk10
import VK_KHR_get_physical_device_properties2


const
  ExtBufferDeviceAddressSpecVersion* = 2
  ExtBufferDeviceAddressExtensionName* = "VK_EXT_buffer_device_address"

type
  PhysicalDeviceBufferAddressFeaturesEXT* = object
  PhysicalDeviceBufferDeviceAddressFeaturesEXT* = object
    sType*: StructureType
    pNext*: pointer
    bufferDeviceAddress*: Bool32
    bufferDeviceAddressCaptureReplay*: Bool32
    bufferDeviceAddressMultiDevice*: Bool32
  BufferDeviceAddressInfoEXT* = object
  BufferDeviceAddressCreateInfoEXT* = object
    sType*: StructureType
    pNext*: pointer
    deviceAddress*: DeviceAddress

var # commands
  
const getBufferDeviceAddressEXT* = getBufferDeviceAddress
proc loadVK_EXT_buffer_device_address*(instance: Instance) =
  instance.defineLoader(`<<`)

  getBufferDeviceAddressEXTCage << "vkGetBufferDeviceAddressEXT"