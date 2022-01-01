# Generated at 2021-12-31T11:28:23Z
# VK_EXT_calibrated_timestamps

import ../platform

import ../features/vk10
import ./VK_KHR_get_physical_device_properties2
export VK_KHR_get_physical_device_properties2
prepareVulkanLibDef()

const
  ExtCalibratedTimestampsSpecVersion* = 2
  ExtCalibratedTimestampsExtensionName* = "VK_EXT_calibrated_timestamps"

type
  CalibratedTimestampInfoEXT* = object
    sType* {.constant: (StructureType.calibratedTimestampInfoExt).}: StructureType
    pNext* {.optional.}: pointer
    timeDomain*: TimeDomainEXT

proc getPhysicalDeviceCalibrateableTimeDomainsEXT*(
      physicalDevice: PhysicalDevice;
      pTimeDomainCount: ptr uint32;
      pTimeDomains {.length: pTimeDomainCount.} = default(arrPtr[TimeDomainEXT]);
    ): Result {.cdecl,
      successCodes: @[Result.success, Result.incomplete],
      errorCodes: @[Result.errorOutOfHostMemory, Result.errorOutOfDeviceMemory],
      lazyload("vkGetPhysicalDeviceCalibrateableTimeDomainsEXT", InstanceLevel).}
proc getCalibratedTimestampsEXT*(
      device: Device;
      timestampCount: uint32;
      pTimestampInfos {.length: timestampCount.}: arrPtr[CalibratedTimestampInfoEXT];
      pTimestamps {.length: timestampCount.}: arrPtr[uint64];
      pMaxDeviation: ptr uint64;
    ): Result {.cdecl,
      successCodes: @[Result.success],
      errorCodes: @[Result.errorOutOfHostMemory, Result.errorOutOfDeviceMemory],
      lazyload("vkGetCalibratedTimestampsEXT", DeviceLevel).}

proc loadAllVK_EXT_calibrated_timestamps*(instance: Instance) = instance.loadCommands:
  getPhysicalDeviceCalibrateableTimeDomainsEXT
  getCalibratedTimestampsEXT
proc loadVK_EXT_calibrated_timestamps*(instance: Instance) = instance.loadCommands:
  getPhysicalDeviceCalibrateableTimeDomainsEXT
proc loadVK_EXT_calibrated_timestamps*(device: Device) = device.loadCommands:
  getCalibratedTimestampsEXT
