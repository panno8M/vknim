
import ../platform
import ../features/vk10
import VK_KHR_external_semaphore


type
  ExportSemaphoreWin32HandleInfoKHR* = object
    sType*: StructureType
    pNext*: pointer
    pAttributes*: ptr SECURITY_ATTRIBUTES
    dwAccess*: DWORD
    name*: LPCWSTR
  D3D12FenceSubmitInfoKHR* = object
    sType*: StructureType
    pNext*: pointer
    waitSemaphoreValuesCount*: uint32
    pWaitSemaphoreValues*: ptr uint64
    signalSemaphoreValuesCount*: uint32
    pSignalSemaphoreValues*: ptr uint64
  ImportSemaphoreWin32HandleInfoKHR* = object
    sType*: StructureType
    pNext*: pointer
    semaphore*: Semaphore
    flags*: SemaphoreImportFlags
    handleType*: ExternalSemaphoreHandleTypeFlagBits
    handle*: HANDLE
    name*: LPCWSTR
  SemaphoreGetWin32HandleInfoKHR* = object
    sType*: StructureType
    pNext*: pointer
    semaphore*: Semaphore
    handleType*: ExternalSemaphoreHandleTypeFlagBits

const KhrExternalSemaphoreWin32ExtensionName* = "VK_KHR_external_semaphore_win32"
const KhrExternalSemaphoreWin32SpecVersion* = 1
var # commands
  importSemaphoreWin32HandleKHRCage: proc(device: Device; pImportSemaphoreWin32HandleInfo: ptr ImportSemaphoreWin32HandleInfoKHR;): Result {.cdecl.}
  getSemaphoreWin32HandleKHRCage: proc(device: Device; pGetWin32HandleInfo: ptr SemaphoreGetWin32HandleInfoKHR; pHandle: ptr HANDLE;): Result {.cdecl.}

proc importSemaphoreWin32HandleKHR*(
      device: Device;
      pImportSemaphoreWin32HandleInfo: ptr ImportSemaphoreWin32HandleInfoKHR;
    ): Result {.cdecl.} =
  importSemaphoreWin32HandleKHRCage(device,pImportSemaphoreWin32HandleInfo)

proc getSemaphoreWin32HandleKHR*(
      device: Device;
      pGetWin32HandleInfo: ptr SemaphoreGetWin32HandleInfoKHR;
      pHandle: ptr HANDLE;
    ): Result {.cdecl.} =
  getSemaphoreWin32HandleKHRCage(device,pGetWin32HandleInfo,pHandle)


proc loadVK_KHR_external_semaphore_win32*(instance: Instance) =
  instance.defineLoader(`<<`)

  importSemaphoreWin32HandleKHRCage << "vkImportSemaphoreWin32HandleKHR"
  getSemaphoreWin32HandleKHRCage << "vkGetSemaphoreWin32HandleKHR"