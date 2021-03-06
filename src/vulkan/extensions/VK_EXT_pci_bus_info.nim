# Generated at 2021-10-24T02:03:03Z
# VK_EXT_pci_bus_info

import ../platform
import ../features/vk10
import ./VK_KHR_get_physical_device_properties2
export VK_KHR_get_physical_device_properties2

prepareVulkanLibDef()

const
  ExtPciBusInfoSpecVersion* = 2
  ExtPciBusInfoExtensionName* = "VK_EXT_pci_bus_info"

type
  PhysicalDevicePCIBusInfoPropertiesEXT* = object
    sType* {.constant: (StructureType.physicalDevicePciBusInfoPropertiesExt).}: StructureType
    pNext* {.optional.}: pointer
    pciDomain*: uint32
    pciBus*: uint32
    pciDevice*: uint32
    pciFunction*: uint32



