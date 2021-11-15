// Autoscaling Group
resource "alicloud_ess_scaling_group" "this" {
  count                                    = var.scaling_group_id == "" ? 1 : 0
  scaling_group_name                       = local.scaling_group_name
  max_size                                 = var.max_size
  min_size                                 = var.min_size
  default_cooldown                         = var.default_cooldown
  vswitch_ids                              = local.vswitch_ids
  removal_policies                         = var.removal_policies
  db_instance_ids                          = local.rds_instance_ids
  loadbalancer_ids                         = local.slb_instance_ids
  multi_az_policy                          = var.multi_az_policy
  on_demand_base_capacity                  = var.on_demand_base_capacity
  on_demand_percentage_above_base_capacity = var.on_demand_percentage_above_base_capacity
  spot_instance_pools                      = var.spot_instance_pools
  spot_instance_remedy                     = var.spot_instance_remedy
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
  password_inherit           = var.password_inherit
  password                   = var.password_inherit == true ? "" : var.password
  kms_encrypted_password     = local.kms_encrypted_password
  kms_encryption_context     = local.kms_encrypted_password == "" ? null : length(var.kms_encryption_context) > 0 ? var.kms_encryption_context : null
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
