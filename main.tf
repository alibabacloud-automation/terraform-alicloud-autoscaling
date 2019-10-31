// Profile configure
provider "alicloud" {
  version                 = ">=1.56.0"
  profile                 = var.profile != "" ? var.profile : null
  shared_credentials_file = var.shared_credentials_file != "" ? var.shared_credentials_file : null
  region                  = var.region != "" ? var.region : null
  skip_region_validation  = var.skip_region_validation
  configuration_source    = "terraform-alicloud-modules/autoscaling"
}

// Autoscaling Group
resource "alicloud_ess_scaling_group" "this" {
  count              = var.scaling_group_id == "" ? 1 : 0
  scaling_group_name = local.scaling_group_name
  max_size           = var.max_size
  min_size           = var.min_size
  default_cooldown   = var.default_cooldown
  vswitch_ids        = local.vswitch_ids
  removal_policies   = var.removal_policies
  db_instance_ids    = local.rds_instance_ids
  loadbalancer_ids   = local.slb_instance_ids
}

// Autoscaling configuration
resource "alicloud_ess_scaling_configuration" "this" {
  count                      = var.create_scaling_configuration ? 1 : 0
  scaling_group_id           = local.scaling_group_id
  image_id                   = var.image_id != "" ? var.image_id : data.alicloud_images.this.ids.0
  instance_types             = length(var.instance_types) > 0 ? var.instance_types : var.instance_type != "" ? [var.instance_type] : [data.alicloud_instance_types.this.ids.0]
  security_group_ids         = local.security_group_ids
  instance_name              = local.scaling_instance_name
  scaling_configuration_name = local.scaling_configuration_name
  internet_charge_type       = var.internet_charge_type
  internet_max_bandwidth_in  = var.internet_max_bandwidth_in
  internet_max_bandwidth_out = var.associate_public_ip_address ? var.internet_max_bandwidth_out : 0
  system_disk_category       = var.system_disk_category
  system_disk_size           = var.system_disk_size
  enable                     = var.enable
  active                     = var.active
  user_data                  = var.user_data
  key_name                   = var.key_name
  role_name                  = var.role_name
  force_delete               = var.force_delete
  tags                       = var.tags
  dynamic "data_disk" {
    for_each = var.data_disks
    content {
      delete_with_instance = lookup(data_disk.value, "delete_with_instance", null)
      snapshot_id          = lookup(data_disk.value, "snapshot_id", null)
      size                 = lookup(data_disk.value, "size", null)
      category             = lookup(data_disk.value, "category", null)
    }
  }
}

resource "alicloud_ess_lifecycle_hook" "this" {
  count                 = var.create_lifecycle_hook ? 1 : 0
  scaling_group_id      = var.scaling_group_id == "" ? alicloud_ess_scaling_group.this.0.id : var.scaling_group_id
  name                  = local.lifecycle_hook_name
  lifecycle_transition  = var.lifecycle_transition
  heartbeat_timeout     = var.heartbeat_timeout
  default_result        = var.hook_action_policy
  notification_arn      = local.notification_arn
  notification_metadata = var.notification_metadata
}
