
import ../platform
import ../features/vk10
import VK_KHR_get_physical_device_properties2


type
  PhysicalDeviceMeshShaderFeaturesNV* = object
    sType*: StructureType
    pNext*: pointer
    taskShader*: Bool32
    meshShader*: Bool32
  DrawMeshTasksIndirectCommandNV* = object
    taskCount*: uint32
    firstTask*: uint32
  PhysicalDeviceMeshShaderPropertiesNV* = object
    sType*: StructureType
    pNext*: pointer
    maxDrawMeshTasksCount*: uint32
    maxTaskWorkGroupInvocations*: uint32
    maxTaskWorkGroupSize*: array[3, uint32]
    maxTaskTotalMemorySize*: uint32
    maxTaskOutputCount*: uint32
    maxMeshWorkGroupInvocations*: uint32
    maxMeshWorkGroupSize*: array[3, uint32]
    maxMeshTotalMemorySize*: uint32
    maxMeshOutputVertices*: uint32
    maxMeshOutputPrimitives*: uint32
    maxMeshMultiviewViewCount*: uint32
    meshOutputPerVertexGranularity*: uint32
    meshOutputPerPrimitiveGranularity*: uint32

const NvMeshShaderExtensionName* = "VK_NV_mesh_shader"
const NvMeshShaderSpecVersion* = 1
var # commands
  cmdDrawMeshTasksIndirectNVCage: proc(commandBuffer: CommandBuffer; buffer: Buffer; offset: DeviceSize; drawCount: uint32; stride: uint32;): void {.cdecl.}
  cmdDrawMeshTasksIndirectCountNVCage: proc(commandBuffer: CommandBuffer; buffer: Buffer; offset: DeviceSize; countBuffer: Buffer; countBufferOffset: DeviceSize; maxDrawCount: uint32; stride: uint32;): void {.cdecl.}
  cmdDrawMeshTasksNVCage: proc(commandBuffer: CommandBuffer; taskCount: uint32; firstTask: uint32;): void {.cdecl.}

proc cmdDrawMeshTasksIndirectNV*(
      commandBuffer: CommandBuffer;
      buffer: Buffer;
      offset: DeviceSize;
      drawCount: uint32;
      stride: uint32;
    ): void {.cdecl.} =
  cmdDrawMeshTasksIndirectNVCage(commandBuffer,buffer,offset,drawCount,stride)

proc cmdDrawMeshTasksIndirectCountNV*(
      commandBuffer: CommandBuffer;
      buffer: Buffer;
      offset: DeviceSize;
      countBuffer: Buffer;
      countBufferOffset: DeviceSize;
      maxDrawCount: uint32;
      stride: uint32;
    ): void {.cdecl.} =
  cmdDrawMeshTasksIndirectCountNVCage(commandBuffer,buffer,offset,countBuffer,countBufferOffset,maxDrawCount,stride)

proc cmdDrawMeshTasksNV*(
      commandBuffer: CommandBuffer;
      taskCount: uint32;
      firstTask: uint32;
    ): void {.cdecl.} =
  cmdDrawMeshTasksNVCage(commandBuffer,taskCount,firstTask)


proc loadVK_NV_mesh_shader*(instance: Instance) =
  instance.defineLoader(`<<`)

  cmdDrawMeshTasksIndirectNVCage << "vkCmdDrawMeshTasksIndirectNV"
  cmdDrawMeshTasksIndirectCountNVCage << "vkCmdDrawMeshTasksIndirectCountNV"
  cmdDrawMeshTasksNVCage << "vkCmdDrawMeshTasksNV"