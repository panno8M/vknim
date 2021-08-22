
import ../platform
import ../features/vk10
import VK_KHR_external_fence


type
  FenceGetWin32HandleInfoKHR* = object
    sType*: StructureType
    pNext*: pointer
    fence*: Fence
    handleType*: ExternalFenceHandleTypeFlagBits
  ExportFenceWin32HandleInfoKHR* = object
    sType*: StructureType
    pNext*: pointer
    pAttributes*: ptr SECURITY_ATTRIBUTES
    dwAccess*: DWORD
    name*: LPCWSTR
  ImportFenceWin32HandleInfoKHR* = object
    sType*: StructureType
    pNext*: pointer
    fence*: Fence
    flags*: FenceImportFlags
    handleType*: ExternalFenceHandleTypeFlagBits
    handle*: HANDLE
    name*: LPCWSTR

const KhrExternalFenceWin32ExtensionName* = "VK_KHR_external_fence_win32"
const KhrExternalFenceWin32SpecVersion* = 1
var # commands
  importFenceWin32HandleKHRCage: proc(device: Device; pImportFenceWin32HandleInfo: ptr ImportFenceWin32HandleInfoKHR;): Result {.cdecl.}
  getFenceWin32HandleKHRCage: proc(device: Device; pGetWin32HandleInfo: ptr FenceGetWin32HandleInfoKHR; pHandle: ptr HANDLE;): Result {.cdecl.}

proc importFenceWin32HandleKHR*(
      device: Device;
      pImportFenceWin32HandleInfo: ptr ImportFenceWin32HandleInfoKHR;
    ): Result {.cdecl.} =
  importFenceWin32HandleKHRCage(device,pImportFenceWin32HandleInfo)

proc getFenceWin32HandleKHR*(
      device: Device;
      pGetWin32HandleInfo: ptr FenceGetWin32HandleInfoKHR;
      pHandle: ptr HANDLE;
    ): Result {.cdecl.} =
  getFenceWin32HandleKHRCage(device,pGetWin32HandleInfo,pHandle)


proc loadVK_KHR_external_fence_win32*(instance: Instance) =
  instance.defineLoader(`<<`)

  importFenceWin32HandleKHRCage << "vkImportFenceWin32HandleKHR"
  getFenceWin32HandleKHRCage << "vkGetFenceWin32HandleKHR"