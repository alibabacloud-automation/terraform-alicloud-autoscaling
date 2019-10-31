locals {
  default_ess_group_name          = "terraform-ess-group-${random_uuid.this.result}"
  default_ess_configuration_name  = "terraform-ess-configuration-${random_uuid.this.result}"
  default_ess_instance            = "terraform-ess-instance-${random_uuid.this.result}"
  default_ess_lifecycle_hook_name = "terraform-ess-hook-${random_uuid.this.result}"
  scaling_group_name              = var.scaling_group_name != "" ? var.scaling_group_name : local.default_ess_group_name
  scaling_configuration_name      = var.scaling_configuration_name != "" ? var.scaling_configuration_name : local.default_ess_configuration_name
  scaling_instance_name           = var.instance_name != "" ? var.instance_name : local.default_ess_instance
  lifecycle_hook_name             = var.lifecycle_hook_name != "" ? var.lifecycle_hook_name : local.default_ess_lifecycle_hook_name
  mns_arn_name                    = var.mns_topic_name != "" ? var.mns_topic_name : var.mns_queue_name != "" ? var.mns_queue_name : ""
  mns_arn_type                    = var.mns_topic_name != "" ? "topic" : var.mns_queue_name != "" ? "queue" : ""
  notification_arn                = "acs:ess:${data.alicloud_regions.this.regions.0.id}:${data.alicloud_account.this.id}:${local.mns_arn_type}/${local.mns_arn_name}"
  slb_name_regex                  = var.slb_name_regex != "" ? var.slb_name_regex : var.filter_with_name_regex
  slb_tags                        = length(var.slb_tags) > 0 ? var.slb_tags : var.filter_with_tags
  slb_instance_ids                = length(var.loadbalancer_ids) > 0 ? var.loadbalancer_ids : local.slb_name_regex != "" || length(local.slb_tags) > 0 ? data.alicloud_slbs.this.ids : null
  rds_name_regex                  = var.rds_name_regex != "" ? var.rds_name_regex : var.filter_with_name_regex
  //  rds_tags                       = length(var.rds_tags) > 0 ? var.rds_tags : var.filter_with_tags
  rds_instance_ids   = length(var.db_instance_ids) > 0 ? var.db_instance_ids : local.rds_name_regex != "" ? data.alicloud_db_instances.this.ids : null
  vswitch_name_regex = var.vswitch_name_regex != "" ? var.vswitch_name_regex : var.filter_with_name_regex
  vswitch_tags       = length(var.vswitch_tags) > 0 ? var.vswitch_tags : var.filter_with_tags
  vswitch_ids        = length(var.vswitch_ids) > 0 ? var.vswitch_ids : local.vswitch_name_regex != "" || length(local.vswitch_tags) > 0 ? data.alicloud_vswitches.this.ids : null
  sg_name_regex      = var.sg_name_regex != "" ? var.sg_name_regex : var.filter_with_name_regex
  sg_tags            = length(var.sg_tags) > 0 ? var.sg_tags : var.filter_with_tags
  security_group_ids = var.security_group_id != "" ? [var.security_group_id] : length(var.security_group_ids) > 0 ? var.security_group_ids : local.sg_name_regex != "" || length(local.sg_tags) > 0 ? data.alicloud_security_groups.this.ids : null
  zone_id            = length(var.vswitch_ids) > 0 ? data.alicloud_vswitches.this.vswitches.0.zone_id : data.alicloud_zones.this.ids.0
  scaling_group_id   = var.scaling_group_id == "" ? alicloud_ess_scaling_group.this.0.id : var.scaling_group_id
}

resource "random_uuid" "this" {}

data "alicloud_regions" "this" {
  current = true
}

data "alicloud_account" "this" {}

data "alicloud_images" "this" {
  most_recent = true
  owners      = var.image_owners
  name_regex  = var.image_name_regex
}

data "alicloud_vswitches" "this" {
  ids         = var.vswitch_ids
  name_regex  = local.vswitch_name_regex
  tags        = local.vswitch_tags
  output_file = "vsw.json"
}

data "alicloud_zones" "this" {
  available_resource_creation = "VSwitch"
}

data "alicloud_security_groups" "this" {
  name_regex = local.sg_name_regex
  tags       = local.sg_tags
}

data "alicloud_slbs" "this" {
  name_regex = local.slb_name_regex
  tags       = local.slb_tags
}
data "alicloud_db_instances" "this" {
  name_regex = local.rds_name_regex
  //  tags       = local.rds_tags
}
data "alicloud_instance_types" "this" {
  cpu_core_count    = var.cpu_core_count
  memory_size       = var.memory_size
  availability_zone = local.zone_id
}