# Generated at 2021-08-28T12:28:00Z
# VK_KHR_descriptor_update_template
# =================================

import ../platform
import ../features/vk10


const
  KhrDescriptorUpdateTemplateSpecVersion* = 1
  KhrDescriptorUpdateTemplateExtensionName* = "VK_KHR_descriptor_update_template"

  DescriptorUpdateTemplateTypePushDescriptorsKhr* = 1

type
  DescriptorUpdateTemplateKHR* = DescriptorUpdateTemplate
  {name}* = {Alias}
  DescriptorUpdateTemplateTypeKHR* = distinct UnusedEnum
  DescriptorUpdateTemplateEntryKHR* = object
  DescriptorUpdateTemplateCreateInfoKHR* = object

var # commands
  
  
  
const createDescriptorUpdateTemplateKHR* = createDescriptorUpdateTemplate
const destroyDescriptorUpdateTemplateKHR* = destroyDescriptorUpdateTemplate
const updateDescriptorSetWithTemplateKHR* = updateDescriptorSetWithTemplate
ObjectType.defineAliases:
  descriptorUpdateTemplate as descriptorUpdateTemplateKhr

StructureType.defineAliases:
  descriptorUpdateTemplateCreateInfo as descriptorUpdateTemplateCreateInfoKhr

DescriptorUpdateTemplateType.defineAliases:
  descriptorSet as descriptorSetKhr



var # commands
  cmdPushDescriptorSetWithTemplateKHRCage: proc(commandBuffer: CommandBuffer; descriptorUpdateTemplate: DescriptorUpdateTemplate; layout: PipelineLayout; set: uint32; pData: pointer;): void {.cdecl.}
proc cmdPushDescriptorSetWithTemplateKHR*(
      commandBuffer: CommandBuffer;
      descriptorUpdateTemplate: DescriptorUpdateTemplate;
      layout: PipelineLayout;
      set: uint32;
      pData: pointer;
    ): void {.cdecl.} =
  cmdPushDescriptorSetWithTemplateKHRCage(commandBuffer,descriptorUpdateTemplate,layout,set,pData)


DebugReportObjectTypeEXT.defineAliases:
  descriptorUpdateTemplateExt as descriptorUpdateTemplateKhrExt

proc loadVK_KHR_descriptor_update_template*(instance: Instance) =
  instance.defineLoader(`<<`)

  createDescriptorUpdateTemplateKHRCage << "vkCreateDescriptorUpdateTemplateKHR"
  destroyDescriptorUpdateTemplateKHRCage << "vkDestroyDescriptorUpdateTemplateKHR"
  updateDescriptorSetWithTemplateKHRCage << "vkUpdateDescriptorSetWithTemplateKHR"

  cmdPushDescriptorSetWithTemplateKHRCage << "vkCmdPushDescriptorSetWithTemplateKHR"
