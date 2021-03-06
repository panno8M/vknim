# Generated at 2021-10-24T09:33:17Z
# VK_KHR_ray_tracing
# VK_NV_ray_tracing
# Explicit sort order to require processing after VK_NV_ray_tracing
# =================================================================

import ../platform
import ../features/vk11
import ./VK_EXT_debug_report
import ./VK_KHR_get_physical_device_properties2
import ./VK_KHR_get_memory_requirements2
import ./VK_EXT_descriptor_indexing
import ./VK_KHR_buffer_device_address
import ./VK_KHR_deferred_host_operations
import ./VK_KHR_pipeline_library
import ../features/vk10
export VK_KHR_get_physical_device_properties2
export VK_KHR_get_memory_requirements2
export VK_EXT_descriptor_indexing
export VK_KHR_buffer_device_address
export VK_KHR_deferred_host_operations
export VK_KHR_pipeline_library

prepareVulkanLibDef()

const
  KhrRayTracingSpecVersion* = 8
  KhrRayTracingExtensionName* = "VK_KHR_ray_tracing"
  ShaderUnusedKhr* = (uint32.high)

  NvRayTracingSpecVersion* = 3
  NvRayTracingExtensionName* = "VK_NV_ray_tracing"
  ShaderUnusedNv* = ShaderUnusedKhr

type # enums and bitmasks
  AccelerationStructureTypeKHR* {.size: sizeof(int32), pure.} = enum
    topLevelKhr = 0
    bottomLevelKhr = 1
  RayTracingShaderGroupTypeKHR* {.size: sizeof(int32), pure.} = enum
    generalKhr = 0
    trianglesHitGroupKhr = 1
    proceduralHitGroupKhr = 2
  AccelerationStructureBuildTypeKHR* {.size: sizeof(int32), pure.} = enum
    hostKhr = 0
    deviceKhr = 1
    hostOrDeviceKhr = 2
  GeometryFlagsKHR* = Flags[GeometryFlagBitsKHR]
  GeometryInstanceFlagsKHR* = Flags[GeometryInstanceFlagBitsKHR]
  GeometryFlagBitsKHR* {.size: sizeof(int32), pure.} = enum
    opaqueKhr = 0x00000001
    noDuplicateAnyHitInvocationKhr = 0x00000002
  GeometryInstanceFlagBitsKHR* {.size: sizeof(int32), pure.} = enum
    triangleFacingCullDisableKhr = 0x00000001
    triangleFrontCounterclockwiseKhr = 0x00000002
    forceOpaqueKhr = 0x00000004
    forceNoOpaqueKhr = 0x00000008
  BuildAccelerationStructureFlagBitsKHR* {.size: sizeof(int32), pure.} = enum
    allowUpdateKhr = 0x00000001
    allowCompactionKhr = 0x00000002
    preferFastTraceKhr = 0x00000004
    preferFastBuildKhr = 0x00000008
    lowMemoryKhr = 0x00000010
  BuildAccelerationStructureFlagsKHR* = Flags[BuildAccelerationStructureFlagBitsKHR]
  CopyAccelerationStructureModeKHR* {.size: sizeof(int32), pure.} = enum
    cloneKhr = 0
    compactKhr = 1
    serializeKhr = 2
    deserializeKhr = 3
  GeometryTypeKHR* {.size: sizeof(int32), pure.} = enum
    trianglesKhr = 0
    aabbsKhr = 1
    # Provided by VK_KHR_ray_tracing
    instancesKhr = 1000150000
  AccelerationStructureMemoryRequirementsTypeKHR* {.size: sizeof(int32), pure.} = enum
    objectKhr = 0
    buildScratchKhr = 1
    updateScratchKhr = 2

  RayTracingShaderGroupTypeNV* = distinct UnusedEnum
  GeometryTypeNV* = distinct UnusedEnum
  AccelerationStructureTypeNV* = distinct UnusedEnum
  GeometryFlagsNV* = GeometryFlagsKHR
  GeometryFlagBitsNV* = distinct UnusedEnum
  GeometryInstanceFlagsNV* = GeometryInstanceFlagsKHR
  GeometryInstanceFlagBitsNV* = distinct UnusedEnum
  BuildAccelerationStructureFlagBitsNV* = distinct UnusedEnum
  BuildAccelerationStructureFlagsNV* = BuildAccelerationStructureFlagsKHR
  CopyAccelerationStructureModeNV* = distinct UnusedEnum
  AccelerationStructureMemoryRequirementsTypeNV* = distinct UnusedEnum

type
  DeviceOrHostAddressKHR* {.union.} = object
    deviceAddress*: DeviceAddress
    hostAddress*: pointer
  DeviceOrHostAddressConstKHR* {.union.} = object
    deviceAddress*: DeviceAddress
    hostAddress*: pointer
  AccelerationStructureBuildOffsetInfoKHR* = object
    primitiveCount*: uint32
    primitiveOffset*: uint32
    firstVertex* {.optional.}: uint32
    transformOffset* {.optional.}: uint32
  RayTracingShaderGroupCreateInfoKHR* = object
    sType* {.constant: (StructureType.rayTracingShaderGroupCreateInfoKhr).}: StructureType
    pNext* {.optional.}: pointer
    theType*: RayTracingShaderGroupTypeKHR
    generalShader*: uint32
    closestHitShader*: uint32
    anyHitShader*: uint32
    intersectionShader*: uint32
    pShaderGroupCaptureReplayHandle* {.optional.}: pointer
  RayTracingPipelineCreateInfoKHR* = object
    sType* {.constant: (StructureType.rayTracingPipelineCreateInfoKhr).}: StructureType
    pNext* {.optional.}: pointer
    flags* {.optional.}: PipelineCreateFlags
    stageCount* {.optional.}: uint32
    pStages* {.length: stageCount.}: arrPtr[PipelineShaderStageCreateInfo]
    groupCount* {.optional.}: uint32
    pGroups* {.length: groupCount.}: arrPtr[RayTracingShaderGroupCreateInfoKHR]
    maxRecursionDepth*: uint32
    libraries*: PipelineLibraryCreateInfoKHR
    pLibraryInterface* {.optional.}: ptr RayTracingPipelineInterfaceCreateInfoKHR
    layout*: PipelineLayout
    basePipelineHandle* {.optional.}: Pipeline
    basePipelineIndex*: int32
  AabbPositionsKHR* = object
    minX*: float32
    minY*: float32
    minZ*: float32
    maxX*: float32
    maxY*: float32
    maxZ*: float32
  AccelerationStructureGeometryTrianglesDataKHR* = object
    sType* {.constant: (StructureType.accelerationStructureGeometryTrianglesDataKhr).}: StructureType
    pNext* {.optional.}: pointer
    vertexFormat*: Format
    vertexData*: DeviceOrHostAddressConstKHR
    vertexStride*: DeviceSize
    indexType*: IndexType
    indexData* {.optional.}: DeviceOrHostAddressConstKHR
    transformData* {.optional.}: DeviceOrHostAddressConstKHR
  TransformMatrixKHR* = object
    matrix*: array[3, array[4, float32]]
  AccelerationStructureBuildGeometryInfoKHR* = object
    sType* {.constant: (StructureType.accelerationStructureBuildGeometryInfoKhr).}: StructureType
    pNext* {.optional.}: pointer
    theType*: AccelerationStructureTypeKHR
    flags* {.optional.}: BuildAccelerationStructureFlagsKHR
    update*: Bool32
    srcAccelerationStructure* {.optional.}: AccelerationStructureKHR
    dstAccelerationStructure*: AccelerationStructureKHR
    geometryArrayOfPointers*: Bool32
    geometryCount* {.optional.}: uint32
    ppGeometries*: ptr ptr AccelerationStructureGeometryKHR
    scratchData*: DeviceOrHostAddressKHR
  AccelerationStructureGeometryAabbsDataKHR* = object
    sType* {.constant: (StructureType.accelerationStructureGeometryAabbsDataKhr).}: StructureType
    pNext* {.optional.}: pointer
    data*: DeviceOrHostAddressConstKHR
    stride*: DeviceSize
  AccelerationStructureInstanceKHR* = object
    transform*: TransformMatrixKHR
    instanceCustomIndex*: uint32
    mask*: uint32
    instanceShaderBindingTableRecordOffset*: uint32
    flags* {.optional.}: GeometryInstanceFlagsKHR
    accelerationStructureReference*: uint64
  AccelerationStructureGeometryInstancesDataKHR* = object
    sType* {.constant: (StructureType.accelerationStructureGeometryInstancesDataKhr).}: StructureType
    pNext* {.optional.}: pointer
    arrayOfPointers*: Bool32
    data*: DeviceOrHostAddressConstKHR
  AccelerationStructureGeometryDataKHR* {.union.} = object
    triangles*: AccelerationStructureGeometryTrianglesDataKHR
    aabbs*: AccelerationStructureGeometryAabbsDataKHR
    instances*: AccelerationStructureGeometryInstancesDataKHR
  AccelerationStructureGeometryKHR* = object
    sType* {.constant: (StructureType.accelerationStructureGeometryKhr).}: StructureType
    pNext* {.optional.}: pointer
    geometryType*: GeometryTypeKHR
    geometry*: AccelerationStructureGeometryDataKHR
    flags* {.optional.}: GeometryFlagsKHR
  AccelerationStructureCreateGeometryTypeInfoKHR* = object
    sType* {.constant: (StructureType.accelerationStructureCreateGeometryTypeInfoKhr).}: StructureType
    pNext* {.optional.}: pointer
    geometryType*: GeometryTypeKHR
    maxPrimitiveCount*: uint32
    indexType*: IndexType
    maxVertexCount* {.optional.}: uint32
    vertexFormat* {.optional.}: Format
    allowsTransforms* {.optional.}: Bool32
  AccelerationStructureCreateInfoKHR* = object
    sType* {.constant: (StructureType.accelerationStructureCreateInfoKhr).}: StructureType
    pNext* {.optional.}: pointer
    compactedSize*: DeviceSize
    theType*: AccelerationStructureTypeKHR
    flags* {.optional.}: BuildAccelerationStructureFlagsKHR
    maxGeometryCount* {.optional.}: uint32
    pGeometryInfos* {.length: maxGeometryCount.}: arrPtr[AccelerationStructureCreateGeometryTypeInfoKHR]
    deviceAddress* {.optional.}: DeviceAddress
  HtAccelerationStructureKHR* = object of HandleType
  AccelerationStructureKHR* = NonDispatchableHandle[HtAccelerationStructureKHR]
  BindAccelerationStructureMemoryInfoKHR* = object
    sType* {.constant: (StructureType.bindAccelerationStructureMemoryInfoKhr).}: StructureType
    pNext* {.optional.}: pointer
    accelerationStructure*: AccelerationStructureKHR
    memory*: DeviceMemory
    memoryOffset*: DeviceSize
    deviceIndexCount* {.optional.}: uint32
    pDeviceIndices* {.length: deviceIndexCount.}: arrPtr[uint32]
  WriteDescriptorSetAccelerationStructureKHR* = object
    sType* {.constant: (StructureType.writeDescriptorSetAccelerationStructureKhr).}: StructureType
    pNext* {.optional.}: pointer
    accelerationStructureCount*: uint32
    pAccelerationStructures* {.length: accelerationStructureCount.}: arrPtr[AccelerationStructureKHR]
  AccelerationStructureMemoryRequirementsInfoKHR* = object
    sType* {.constant: (StructureType.accelerationStructureMemoryRequirementsInfoKhr).}: StructureType
    pNext* {.optional.}: pointer
    theType*: AccelerationStructureMemoryRequirementsTypeKHR
    buildType*: AccelerationStructureBuildTypeKHR
    accelerationStructure*: AccelerationStructureKHR
  PhysicalDeviceRayTracingFeaturesKHR* = object
    sType* {.constant: (StructureType.physicalDeviceRayTracingFeaturesKhr).}: StructureType
    pNext* {.optional.}: pointer
    rayTracing*: Bool32
    rayTracingShaderGroupHandleCaptureReplay*: Bool32
    rayTracingShaderGroupHandleCaptureReplayMixed*: Bool32
    rayTracingAccelerationStructureCaptureReplay*: Bool32
    rayTracingIndirectTraceRays*: Bool32
    rayTracingIndirectAccelerationStructureBuild*: Bool32
    rayTracingHostAccelerationStructureCommands*: Bool32
    rayQuery*: Bool32
    rayTracingPrimitiveCulling*: Bool32
  PhysicalDeviceRayTracingPropertiesKHR* = object
    sType* {.constant: (StructureType.physicalDeviceRayTracingPropertiesKhr).}: StructureType
    pNext* {.optional.}: pointer
    shaderGroupHandleSize*: uint32
    maxRecursionDepth*: uint32
    maxShaderGroupStride*: uint32
    shaderGroupBaseAlignment*: uint32
    maxGeometryCount*: uint64
    maxInstanceCount*: uint64
    maxPrimitiveCount*: uint64
    maxDescriptorSetAccelerationStructures*: uint32
    shaderGroupHandleCaptureReplaySize*: uint32
  AccelerationStructureDeviceAddressInfoKHR* = object
    sType* {.constant: (StructureType.accelerationStructureDeviceAddressInfoKhr).}: StructureType
    pNext* {.optional.}: pointer
    accelerationStructure*: AccelerationStructureKHR
  AccelerationStructureVersionKHR* = object
    sType* {.constant: (StructureType.accelerationStructureVersionKhr).}: StructureType
    pNext* {.optional.}: pointer
    versionData* {.length: 2*VK_UUID_SIZE.}: arrPtr[arrPtr[uint8]]
  StridedBufferRegionKHR* = object
    buffer* {.optional.}: Buffer
    offset*: DeviceSize
    stride*: DeviceSize
    size*: DeviceSize
  TraceRaysIndirectCommandKHR* = object
    width*: uint32
    height*: uint32
    depth*: uint32
  CopyAccelerationStructureToMemoryInfoKHR* = object
    sType* {.constant: (StructureType.copyAccelerationStructureToMemoryInfoKhr).}: StructureType
    pNext* {.optional.}: pointer
    src*: AccelerationStructureKHR
    dst*: DeviceOrHostAddressKHR
    mode*: CopyAccelerationStructureModeKHR
  CopyMemoryToAccelerationStructureInfoKHR* = object
    sType* {.constant: (StructureType.copyMemoryToAccelerationStructureInfoKhr).}: StructureType
    pNext* {.optional.}: pointer
    src*: DeviceOrHostAddressConstKHR
    dst*: AccelerationStructureKHR
    mode*: CopyAccelerationStructureModeKHR
  CopyAccelerationStructureInfoKHR* = object
    sType* {.constant: (StructureType.copyAccelerationStructureInfoKhr).}: StructureType
    pNext* {.optional.}: pointer
    src*: AccelerationStructureKHR
    dst*: AccelerationStructureKHR
    mode*: CopyAccelerationStructureModeKHR
  RayTracingPipelineInterfaceCreateInfoKHR* = object
    sType* {.constant: (StructureType.rayTracingPipelineInterfaceCreateInfoKhr).}: StructureType
    pNext* {.optional.}: pointer
    maxPayloadSize*: uint32
    maxAttributeSize*: uint32
    maxCallableSize*: uint32

  RayTracingShaderGroupCreateInfoNV* = object
    sType* {.constant: (StructureType.rayTracingShaderGroupCreateInfoNv).}: StructureType
    pNext* {.optional.}: pointer
    theType*: RayTracingShaderGroupTypeKHR
    generalShader*: uint32
    closestHitShader*: uint32
    anyHitShader*: uint32
    intersectionShader*: uint32
  RayTracingPipelineCreateInfoNV* = object
    sType* {.constant: (StructureType.rayTracingPipelineCreateInfoNv).}: StructureType
    pNext* {.optional.}: pointer
    flags* {.optional.}: PipelineCreateFlags
    stageCount*: uint32
    pStages* {.length: stageCount.}: arrPtr[PipelineShaderStageCreateInfo]
    groupCount*: uint32
    pGroups* {.length: groupCount.}: arrPtr[RayTracingShaderGroupCreateInfoNV]
    maxRecursionDepth*: uint32
    layout*: PipelineLayout
    basePipelineHandle* {.optional.}: Pipeline
    basePipelineIndex*: int32
  GeometryTrianglesNV* = object
    sType* {.constant: (StructureType.geometryTrianglesNv).}: StructureType
    pNext* {.optional.}: pointer
    vertexData* {.optional.}: Buffer
    vertexOffset*: DeviceSize
    vertexCount*: uint32
    vertexStride*: DeviceSize
    vertexFormat*: Format
    indexData* {.optional.}: Buffer
    indexOffset*: DeviceSize
    indexCount*: uint32
    indexType*: IndexType
    transformData* {.optional.}: Buffer
    transformOffset*: DeviceSize
  GeometryAABBNV* = object
    sType* {.constant: (StructureType.geometryAabbNv).}: StructureType
    pNext* {.optional.}: pointer
    aabbData* {.optional.}: Buffer
    numAABBs*: uint32
    stride*: uint32
    offset*: DeviceSize
  GeometryDataNV* = object
    triangles*: GeometryTrianglesNV
    aabbs*: GeometryAABBNV
  GeometryNV* = object
    sType* {.constant: (StructureType.geometryNv).}: StructureType
    pNext* {.optional.}: pointer
    geometryType*: GeometryTypeKHR
    geometry*: GeometryDataNV
    flags* {.optional.}: GeometryFlagsKHR
  AccelerationStructureInfoNV* = object
    sType* {.constant: (StructureType.accelerationStructureInfoNv).}: StructureType
    pNext* {.optional.}: pointer
    theType*: AccelerationStructureTypeNV
    flags* {.optional.}: BuildAccelerationStructureFlagsNV
    instanceCount* {.optional.}: uint32
    geometryCount* {.optional.}: uint32
    pGeometries* {.length: geometryCount.}: arrPtr[GeometryNV]
  AccelerationStructureCreateInfoNV* = object
    sType* {.constant: (StructureType.accelerationStructureCreateInfoNv).}: StructureType
    pNext* {.optional.}: pointer
    compactedSize*: DeviceSize
    info*: AccelerationStructureInfoNV
  AccelerationStructureNV* = AccelerationStructureKHR
  BindAccelerationStructureMemoryInfoNV* = object
  WriteDescriptorSetAccelerationStructureNV* = object
  AccelerationStructureMemoryRequirementsInfoNV* = object
    sType* {.constant: (StructureType.accelerationStructureMemoryRequirementsInfoNv).}: StructureType
    pNext* {.optional.}: pointer
    theType*: AccelerationStructureMemoryRequirementsTypeNV
    accelerationStructure*: AccelerationStructureNV
  PhysicalDeviceRayTracingPropertiesNV* = object
    sType* {.constant: (StructureType.physicalDeviceRayTracingPropertiesNv).}: StructureType
    pNext* {.optional.}: pointer
    shaderGroupHandleSize*: uint32
    maxRecursionDepth*: uint32
    maxShaderGroupStride*: uint32
    shaderGroupBaseAlignment*: uint32
    maxGeometryCount*: uint64
    maxInstanceCount*: uint64
    maxTriangleCount*: uint64
    maxDescriptorSetAccelerationStructures*: uint32
  MemoryRequirements2KHR* = object
  TransformMatrixNV* = object
  AabbPositionsNV* = object
  AccelerationStructureInstanceNV* = object

proc createAccelerationStructureKHR*(
      device: Device;
      pCreateInfo: ptr AccelerationStructureCreateInfoKHR;
      pAllocator = default(ptr AllocationCallbacks);
      pAccelerationStructure: ptr AccelerationStructureKHR;
    ): Result {.cdecl,
      successCodes(success),
      errorCodes(errorOutOfHostMemory, errorInvalidOpaqueCaptureAddressKhr),
      lazyload("vkCreateAccelerationStructureKHR", DeviceLevel).}
proc destroyAccelerationStructureKHR*(
      device: Device;
      accelerationStructure = default(AccelerationStructureKHR);
      pAllocator = default(ptr AllocationCallbacks);
    ): void {.cdecl, lazyload("vkDestroyAccelerationStructureKHR", DeviceLevel).}
proc getAccelerationStructureMemoryRequirementsKHR*(
      device: Device;
      pInfo: ptr AccelerationStructureMemoryRequirementsInfoKHR;
      pMemoryRequirements: ptr MemoryRequirements2;
    ): void {.cdecl, lazyload("vkGetAccelerationStructureMemoryRequirementsKHR", DeviceLevel).}
proc bindAccelerationStructureMemoryKHR*(
      device: Device;
      bindInfoCount: uint32;
      pBindInfos {.length: bindInfoCount.}: arrPtr[BindAccelerationStructureMemoryInfoKHR];
    ): Result {.cdecl,
      successCodes(success),
      errorCodes(errorOutOfHostMemory, errorOutOfDeviceMemory),
      lazyload("vkBindAccelerationStructureMemoryKHR", DeviceLevel).}
proc cmdBuildAccelerationStructureKHR*(
      commandBuffer: CommandBuffer;
      infoCount: uint32;
      pInfos {.length: infoCount.}: arrPtr[AccelerationStructureBuildGeometryInfoKHR];
      ppOffsetInfos {.length: infoCount.}: arrPtr[arrPtr[AccelerationStructureBuildOffsetInfoKHR]];
    ): void {.cdecl, lazyload("vkCmdBuildAccelerationStructureKHR", DeviceLevel).}
proc cmdBuildAccelerationStructureIndirectKHR*(
      commandBuffer: CommandBuffer;
      pInfo: ptr AccelerationStructureBuildGeometryInfoKHR;
      indirectBuffer: Buffer;
      indirectOffset: DeviceSize;
      indirectStride: uint32;
    ): void {.cdecl, lazyload("vkCmdBuildAccelerationStructureIndirectKHR", DeviceLevel).}
proc buildAccelerationStructureKHR*(
      device: Device;
      infoCount: uint32;
      pInfos {.length: infoCount.}: arrPtr[AccelerationStructureBuildGeometryInfoKHR];
      ppOffsetInfos {.length: infoCount.}: arrPtr[arrPtr[AccelerationStructureBuildOffsetInfoKHR]];
    ): Result {.cdecl,
      successCodes(success, operationDeferredKhr, operationNotDeferredKhr),
      errorCodes(errorOutOfHostMemory, errorOutOfDeviceMemory),
      lazyload("vkBuildAccelerationStructureKHR", DeviceLevel).}
proc copyAccelerationStructureKHR*(
      device: Device;
      pInfo: ptr CopyAccelerationStructureInfoKHR;
    ): Result {.cdecl,
      successCodes(success, operationDeferredKhr, operationNotDeferredKhr),
      errorCodes(errorOutOfHostMemory, errorOutOfDeviceMemory),
      lazyload("vkCopyAccelerationStructureKHR", DeviceLevel).}
proc copyAccelerationStructureToMemoryKHR*(
      device: Device;
      pInfo: ptr CopyAccelerationStructureToMemoryInfoKHR;
    ): Result {.cdecl,
      successCodes(success, operationDeferredKhr, operationNotDeferredKhr),
      errorCodes(errorOutOfHostMemory, errorOutOfDeviceMemory),
      lazyload("vkCopyAccelerationStructureToMemoryKHR", DeviceLevel).}
proc copyMemoryToAccelerationStructureKHR*(
      device: Device;
      pInfo: ptr CopyMemoryToAccelerationStructureInfoKHR;
    ): Result {.cdecl,
      successCodes(success, operationDeferredKhr, operationNotDeferredKhr),
      errorCodes(errorOutOfHostMemory, errorOutOfDeviceMemory),
      lazyload("vkCopyMemoryToAccelerationStructureKHR", DeviceLevel).}
proc writeAccelerationStructuresPropertiesKHR*(
      device: Device;
      accelerationStructureCount: uint32;
      pAccelerationStructures {.length: accelerationStructureCount.}: arrPtr[AccelerationStructureKHR];
      queryType: QueryType;
      dataSize: uint;
      pData {.length: dataSize.}: pointer;
      stride: uint;
    ): Result {.cdecl,
      successCodes(success),
      errorCodes(errorOutOfHostMemory, errorOutOfDeviceMemory),
      lazyload("vkWriteAccelerationStructuresPropertiesKHR", DeviceLevel).}
proc cmdCopyAccelerationStructureKHR*(
      commandBuffer: CommandBuffer;
      pInfo: ptr CopyAccelerationStructureInfoKHR;
    ): void {.cdecl, lazyload("vkCmdCopyAccelerationStructureKHR", DeviceLevel).}
proc cmdCopyAccelerationStructureToMemoryKHR*(
      commandBuffer: CommandBuffer;
      pInfo: ptr CopyAccelerationStructureToMemoryInfoKHR;
    ): void {.cdecl, lazyload("vkCmdCopyAccelerationStructureToMemoryKHR", DeviceLevel).}
proc cmdCopyMemoryToAccelerationStructureKHR*(
      commandBuffer: CommandBuffer;
      pInfo: ptr CopyMemoryToAccelerationStructureInfoKHR;
    ): void {.cdecl, lazyload("vkCmdCopyMemoryToAccelerationStructureKHR", DeviceLevel).}
proc cmdTraceRaysKHR*(
      commandBuffer: CommandBuffer;
      pRaygenShaderBindingTable: ptr StridedBufferRegionKHR;
      pMissShaderBindingTable: ptr StridedBufferRegionKHR;
      pHitShaderBindingTable: ptr StridedBufferRegionKHR;
      pCallableShaderBindingTable: ptr StridedBufferRegionKHR;
      width: uint32;
      height: uint32;
      depth: uint32;
    ): void {.cdecl, lazyload("vkCmdTraceRaysKHR", DeviceLevel).}
proc createRayTracingPipelinesKHR*(
      device: Device;
      pipelineCache = default(PipelineCache);
      createInfoCount: uint32;
      pCreateInfos {.length: createInfoCount.}: arrPtr[RayTracingPipelineCreateInfoKHR];
      pAllocator = default(ptr AllocationCallbacks);
      pPipelines {.length: createInfoCount.}: arrPtr[Pipeline];
    ): Result {.cdecl,
      successCodes(success, operationDeferredKhr, operationNotDeferredKhr, pipelineCompileRequiredExt),
      errorCodes(errorOutOfHostMemory, errorOutOfDeviceMemory, errorInvalidOpaqueCaptureAddress),
      lazyload("vkCreateRayTracingPipelinesKHR", DeviceLevel).}
proc getRayTracingShaderGroupHandlesKHR*(
      device: Device;
      pipeline: Pipeline;
      firstGroup: uint32;
      groupCount: uint32;
      dataSize: uint;
      pData {.length: dataSize.}: pointer;
    ): Result {.cdecl,
      successCodes(success),
      errorCodes(errorOutOfHostMemory, errorOutOfDeviceMemory),
      lazyload("vkGetRayTracingShaderGroupHandlesKHR", DeviceLevel).}
proc getAccelerationStructureDeviceAddressKHR*(
      device: Device;
      pInfo: ptr AccelerationStructureDeviceAddressInfoKHR;
    ): DeviceAddress {.cdecl, lazyload("vkGetAccelerationStructureDeviceAddressKHR", DeviceLevel).}
proc getRayTracingCaptureReplayShaderGroupHandlesKHR*(
      device: Device;
      pipeline: Pipeline;
      firstGroup: uint32;
      groupCount: uint32;
      dataSize: uint;
      pData {.length: dataSize.}: pointer;
    ): Result {.cdecl,
      successCodes(success),
      errorCodes(errorOutOfHostMemory, errorOutOfDeviceMemory),
      lazyload("vkGetRayTracingCaptureReplayShaderGroupHandlesKHR", DeviceLevel).}
proc cmdWriteAccelerationStructuresPropertiesKHR*(
      commandBuffer: CommandBuffer;
      accelerationStructureCount: uint32;
      pAccelerationStructures {.length: accelerationStructureCount.}: arrPtr[AccelerationStructureKHR];
      queryType: QueryType;
      queryPool: QueryPool;
      firstQuery: uint32;
    ): void {.cdecl, lazyload("vkCmdWriteAccelerationStructuresPropertiesKHR", DeviceLevel).}
proc cmdTraceRaysIndirectKHR*(
      commandBuffer: CommandBuffer;
      pRaygenShaderBindingTable: ptr StridedBufferRegionKHR;
      pMissShaderBindingTable: ptr StridedBufferRegionKHR;
      pHitShaderBindingTable: ptr StridedBufferRegionKHR;
      pCallableShaderBindingTable: ptr StridedBufferRegionKHR;
      buffer: Buffer;
      offset: DeviceSize;
    ): void {.cdecl, lazyload("vkCmdTraceRaysIndirectKHR", DeviceLevel).}
proc getDeviceAccelerationStructureCompatibilityKHR*(
      device: Device;
      version: ptr AccelerationStructureVersionKHR;
    ): Result {.cdecl,
      successCodes(success),
      errorCodes(errorIncompatibleVersionKhr),
      lazyload("vkGetDeviceAccelerationStructureCompatibilityKHR", DeviceLevel).}


proc createAccelerationStructureNV*(
      device: Device;
      pCreateInfo: ptr AccelerationStructureCreateInfoNV;
      pAllocator = default(ptr AllocationCallbacks);
      pAccelerationStructure: ptr AccelerationStructureNV;
    ): Result {.cdecl,
      successCodes(success),
      errorCodes(errorOutOfHostMemory),
      lazyload("vkCreateAccelerationStructureNV", DeviceLevel).}
const destroyAccelerationStructureNV* = destroyAccelerationStructureKHR
proc getAccelerationStructureMemoryRequirementsNV*(
      device: Device;
      pInfo: ptr AccelerationStructureMemoryRequirementsInfoNV;
      pMemoryRequirements: ptr MemoryRequirements2KHR;
    ): void {.cdecl, lazyload("vkGetAccelerationStructureMemoryRequirementsNV", DeviceLevel).}
const bindAccelerationStructureMemoryNV* = bindAccelerationStructureMemoryKHR
proc cmdBuildAccelerationStructureNV*(
      commandBuffer: CommandBuffer;
      pInfo: ptr AccelerationStructureInfoNV;
      instanceData = default(Buffer);
      instanceOffset: DeviceSize;
      update: Bool32;
      dst: AccelerationStructureKHR;
      src = default(AccelerationStructureKHR);
      scratch: Buffer;
      scratchOffset: DeviceSize;
    ): void {.cdecl, lazyload("vkCmdBuildAccelerationStructureNV", DeviceLevel).}
proc cmdCopyAccelerationStructureNV*(
      commandBuffer: CommandBuffer;
      dst: AccelerationStructureKHR;
      src: AccelerationStructureKHR;
      mode: CopyAccelerationStructureModeKHR;
    ): void {.cdecl, lazyload("vkCmdCopyAccelerationStructureNV", DeviceLevel).}
proc cmdTraceRaysNV*(
      commandBuffer: CommandBuffer;
      raygenShaderBindingTableBuffer: Buffer;
      raygenShaderBindingOffset: DeviceSize;
      missShaderBindingTableBuffer = default(Buffer);
      missShaderBindingOffset: DeviceSize;
      missShaderBindingStride: DeviceSize;
      hitShaderBindingTableBuffer = default(Buffer);
      hitShaderBindingOffset: DeviceSize;
      hitShaderBindingStride: DeviceSize;
      callableShaderBindingTableBuffer = default(Buffer);
      callableShaderBindingOffset: DeviceSize;
      callableShaderBindingStride: DeviceSize;
      width: uint32;
      height: uint32;
      depth: uint32;
    ): void {.cdecl, lazyload("vkCmdTraceRaysNV", DeviceLevel).}
proc createRayTracingPipelinesNV*(
      device: Device;
      pipelineCache = default(PipelineCache);
      createInfoCount: uint32;
      pCreateInfos {.length: createInfoCount.}: arrPtr[RayTracingPipelineCreateInfoNV];
      pAllocator = default(ptr AllocationCallbacks);
      pPipelines {.length: createInfoCount.}: arrPtr[Pipeline];
    ): Result {.cdecl,
      successCodes(success, pipelineCompileRequiredExt),
      errorCodes(errorOutOfHostMemory, errorOutOfDeviceMemory, errorInvalidShaderNv),
      lazyload("vkCreateRayTracingPipelinesNV", DeviceLevel).}
const getRayTracingShaderGroupHandlesNV* = getRayTracingShaderGroupHandlesKHR
proc getAccelerationStructureHandleNV*(
      device: Device;
      accelerationStructure: AccelerationStructureKHR;
      dataSize: uint;
      pData {.length: dataSize.}: pointer;
    ): Result {.cdecl,
      successCodes(success),
      errorCodes(errorOutOfHostMemory, errorOutOfDeviceMemory),
      lazyload("vkGetAccelerationStructureHandleNV", DeviceLevel).}
const cmdWriteAccelerationStructuresPropertiesNV* = cmdWriteAccelerationStructuresPropertiesKHR
proc compileDeferredNV*(
      device: Device;
      pipeline: Pipeline;
      shader: uint32;
    ): Result {.cdecl,
      successCodes(success),
      errorCodes(errorOutOfHostMemory, errorOutOfDeviceMemory),
      lazyload("vkCompileDeferredNV", DeviceLevel).}
PipelineStageFlagBits.defineAliases:
  rayTracingShaderKhr as rayTracingShaderNv
  accelerationStructureBuildKhr as accelerationStructureBuildNv

ShaderStageFlagBits.defineAliases:
  raygenKhr as raygenNv
  anyHitKhr as anyHitNv
  closestHitKhr as closestHitNv
  missKhr as missNv
  intersectionKhr as intersectionNv
  callableKhr as callableNv

BufferUsageFlagBits.defineAliases:
  rayTracingKhr as rayTracingNv

DebugReportObjectTypeEXT.defineAliases:
  accelerationStructureKhrExt as accelerationStructureNvExt

RayTracingShaderGroupTypeKHR.defineAliases:
  generalKhr as generalNv
  trianglesHitGroupKhr as trianglesHitGroupNv
  proceduralHitGroupKhr as proceduralHitGroupNv

CopyAccelerationStructureModeKHR.defineAliases:
  cloneKhr as cloneNv
  compactKhr as compactNv

AccessFlagBits.defineAliases:
  accelerationStructureReadKhr as accelerationStructureReadNv
  accelerationStructureWriteKhr as accelerationStructureWriteNv

ObjectType.defineAliases:
  accelerationStructureKhr as accelerationStructureNv

GeometryFlagBitsKHR.defineAliases:
  opaqueKhr as opaqueNv
  noDuplicateAnyHitInvocationKhr as noDuplicateAnyHitInvocationNv

AccelerationStructureTypeKHR.defineAliases:
  topLevelKhr as topLevelNv
  bottomLevelKhr as bottomLevelNv

GeometryInstanceFlagBitsKHR.defineAliases:
  triangleFacingCullDisableKhr as triangleCullDisableNv
  triangleFrontCounterclockwiseKhr as triangleFrontCounterclockwiseNv
  forceOpaqueKhr as forceOpaqueNv
  forceNoOpaqueKhr as forceNoOpaqueNv

DescriptorType.defineAliases:
  accelerationStructureKhr as accelerationStructureNv

StructureType.defineAliases:
  bindAccelerationStructureMemoryInfoKhr as bindAccelerationStructureMemoryInfoNv
  writeDescriptorSetAccelerationStructureKhr as writeDescriptorSetAccelerationStructureNv

PipelineBindPoint.defineAliases:
  rayTracingKhr as rayTracingNv

QueryType.defineAliases:
  accelerationStructureCompactedSizeKhr as accelerationStructureCompactedSizeNv

AccelerationStructureMemoryRequirementsTypeKHR.defineAliases:
  objectKhr as objectNv
  buildScratchKhr as buildScratchNv
  updateScratchKhr as updateScratchNv

BuildAccelerationStructureFlagBitsKHR.defineAliases:
  allowUpdateKhr as allowUpdateNv
  allowCompactionKhr as allowCompactionNv
  preferFastTraceKhr as preferFastTraceNv
  preferFastBuildKhr as preferFastBuildNv
  lowMemoryKhr as lowMemoryNv

GeometryTypeKHR.defineAliases:
  trianglesKhr as trianglesNv
  aabbsKhr as aabbsNv

IndexType.defineAliases:
  noneKhr as noneNv


proc loadAllVK_KHR_ray_tracing*(instance: Instance) =
  instance.loadCommand createAccelerationStructureKHR
  instance.loadCommand destroyAccelerationStructureKHR
  instance.loadCommand getAccelerationStructureMemoryRequirementsKHR
  instance.loadCommand bindAccelerationStructureMemoryKHR
  instance.loadCommand cmdBuildAccelerationStructureKHR
  instance.loadCommand cmdBuildAccelerationStructureIndirectKHR
  instance.loadCommand buildAccelerationStructureKHR
  instance.loadCommand copyAccelerationStructureKHR
  instance.loadCommand copyAccelerationStructureToMemoryKHR
  instance.loadCommand copyMemoryToAccelerationStructureKHR
  instance.loadCommand writeAccelerationStructuresPropertiesKHR
  instance.loadCommand cmdCopyAccelerationStructureKHR
  instance.loadCommand cmdCopyAccelerationStructureToMemoryKHR
  instance.loadCommand cmdCopyMemoryToAccelerationStructureKHR
  instance.loadCommand cmdTraceRaysKHR
  instance.loadCommand createRayTracingPipelinesKHR
  instance.loadCommand getRayTracingShaderGroupHandlesKHR
  instance.loadCommand getAccelerationStructureDeviceAddressKHR
  instance.loadCommand getRayTracingCaptureReplayShaderGroupHandlesKHR
  instance.loadCommand cmdWriteAccelerationStructuresPropertiesKHR
  instance.loadCommand cmdTraceRaysIndirectKHR
  instance.loadCommand getDeviceAccelerationStructureCompatibilityKHR

proc loadAllVK_NV_ray_tracing*(instance: Instance) =
  instance.loadCommand createAccelerationStructureNV
  instance.loadCommand getAccelerationStructureMemoryRequirementsNV
  instance.loadCommand cmdBuildAccelerationStructureNV
  instance.loadCommand cmdCopyAccelerationStructureNV
  instance.loadCommand cmdTraceRaysNV
  instance.loadCommand createRayTracingPipelinesNV
  instance.loadCommand getAccelerationStructureHandleNV
  instance.loadCommand compileDeferredNV

proc loadVK_KHR_ray_tracing*(device: Device) =
  device.loadCommand createAccelerationStructureKHR
  device.loadCommand destroyAccelerationStructureKHR
  device.loadCommand getAccelerationStructureMemoryRequirementsKHR
  device.loadCommand bindAccelerationStructureMemoryKHR
  device.loadCommand cmdBuildAccelerationStructureKHR
  device.loadCommand cmdBuildAccelerationStructureIndirectKHR
  device.loadCommand buildAccelerationStructureKHR
  device.loadCommand copyAccelerationStructureKHR
  device.loadCommand copyAccelerationStructureToMemoryKHR
  device.loadCommand copyMemoryToAccelerationStructureKHR
  device.loadCommand writeAccelerationStructuresPropertiesKHR
  device.loadCommand cmdCopyAccelerationStructureKHR
  device.loadCommand cmdCopyAccelerationStructureToMemoryKHR
  device.loadCommand cmdCopyMemoryToAccelerationStructureKHR
  device.loadCommand cmdTraceRaysKHR
  device.loadCommand createRayTracingPipelinesKHR
  device.loadCommand getRayTracingShaderGroupHandlesKHR
  device.loadCommand getAccelerationStructureDeviceAddressKHR
  device.loadCommand getRayTracingCaptureReplayShaderGroupHandlesKHR
  device.loadCommand cmdWriteAccelerationStructuresPropertiesKHR
  device.loadCommand cmdTraceRaysIndirectKHR
  device.loadCommand getDeviceAccelerationStructureCompatibilityKHR

proc loadVK_NV_ray_tracing*(device: Device) =
  device.loadCommand createAccelerationStructureNV
  device.loadCommand getAccelerationStructureMemoryRequirementsNV
  device.loadCommand cmdBuildAccelerationStructureNV
  device.loadCommand cmdCopyAccelerationStructureNV
  device.loadCommand cmdTraceRaysNV
  device.loadCommand createRayTracingPipelinesNV
  device.loadCommand getAccelerationStructureHandleNV
  device.loadCommand compileDeferredNV

