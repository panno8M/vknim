# Generated at 2021-10-24T02:03:03Z
# VK_EXT_pipeline_creation_feedback

import ../platform
import ../features/vk10

prepareVulkanLibDef()

const
  ExtPipelineCreationFeedbackSpecVersion* = 1
  ExtPipelineCreationFeedbackExtensionName* = "VK_EXT_pipeline_creation_feedback"

type # enums and bitmasks
  PipelineCreationFeedbackFlagBitsEXT* {.size: sizeof(int32), pure.} = enum
    validExt = 0x00000001
    applicationPipelineCacheHitExt = 0x00000002
    basePipelineAccelerationExt = 0x00000004
  PipelineCreationFeedbackFlagsEXT* = Flags[PipelineCreationFeedbackFlagBitsEXT]

type
  PipelineCreationFeedbackCreateInfoEXT* = object
    sType* {.constant: (StructureType.pipelineCreationFeedbackCreateInfoExt).}: StructureType
    pNext* {.optional.}: pointer
    pPipelineCreationFeedback*: ptr PipelineCreationFeedbackEXT
    pipelineStageCreationFeedbackCount*: uint32
    pPipelineStageCreationFeedbacks* {.length: pipelineStageCreationFeedbackCount.}: arrPtr[arrPtr[PipelineCreationFeedbackEXT]]
  PipelineCreationFeedbackEXT* = object
    flags*: PipelineCreationFeedbackFlagsEXT
    duration*: uint64



