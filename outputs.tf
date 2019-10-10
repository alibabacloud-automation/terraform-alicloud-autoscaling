output "this_autoscaling_configuration_id" {
  description = "The id of the autoscaling configuration"
  value       = alicloud_ess_scaling_configuration.this.id
}

output "this_autoscaling_configuration_name" {
  description = "The name of the autoscaling configuration"
  value       = alicloud_ess_scaling_configuration.this.scaling_configuration_name
}

output "this_autoscaling_group_id" {
  description = "The id of the autoscaling group"
  value       = var.scaling_group_id == "" ? join("", alicloud_ess_scaling_group.this.*.id) : var.scaling_group_id
}

output "this_autoscaling_group_name" {
  description = "The name of the autoscaling group"
  value       = concat(alicloud_ess_scaling_group.this.*.scaling_group_name, [""])[0]
}

output "this_autoscaling_group_min_size" {
  description = "The minimum size of the autoscaling group"
  value       = concat(alicloud_ess_scaling_group.this.*.min_size, [""])[0]
}

output "this_autoscaling_group_max_size" {
  description = "The maximum size of the autoscaling group"
  value       = concat(alicloud_ess_scaling_group.this.*.max_size, [""])[0]
}

output "this_autoscaling_group_default_cooldown" {
  description = "The default cooldown of the autoscaling group"
  value       = concat(alicloud_ess_scaling_group.this.*.default_cooldown, [""])[0]
}

output "this_vswitch_ids" {
  value = alicloud_ess_scaling_group.this[0].vswitch_ids
}

output "this_removal_policies" {
  value = alicloud_ess_scaling_group.this[0].removal_policies
}

output "this_db_instance_ids" {
  value = alicloud_ess_scaling_group.this[0].db_instance_ids
}

output "this_loadbalancer_ids" {
  value = alicloud_ess_scaling_group.this[0].loadbalancer_ids
}

output "this_image_id" {
  value = alicloud_ess_scaling_configuration.this.image_id
}

output "this_instance_type" {
  value = alicloud_ess_scaling_configuration.this.instance_type
}

output "this_security_group_id" {
  value = alicloud_ess_scaling_configuration.this.security_group_id
}

output "this_instance_name" {
  value = alicloud_ess_scaling_configuration.this.instance_name
}

output "this_scaling_configuration_name" {
  value = alicloud_ess_scaling_configuration.this.scaling_configuration_name
}

output "this_internet_charge_type" {
  value = alicloud_ess_scaling_configuration.this.internet_charge_type
}

output "this_internet_max_bandwidth_in" {
  value = alicloud_ess_scaling_configuration.this.internet_max_bandwidth_in
}

output "this_internet_max_bandwidth_out" {
  value = alicloud_ess_scaling_configuration.this.internet_max_bandwidth_out
}

output "this_system_disk_category" {
  value = alicloud_ess_scaling_configuration.this.system_disk_category
}

output "this_enable" {
  value = alicloud_ess_scaling_configuration.this.enable
}

output "this_active" {
  value = alicloud_ess_scaling_configuration.this.active
}

output "this_user_data" {
  value = alicloud_ess_scaling_configuration.this.user_data
}

output "this_key_name" {
  value = alicloud_ess_scaling_configuration.this.key_name
}

output "this_role_name" {
  value = alicloud_ess_scaling_configuration.this.role_name
}

output "this_force_delete" {
  value = alicloud_ess_scaling_configuration.this.force_delete
}

output "this_data_disk_size" {
  value = alicloud_ess_scaling_configuration.this.data_disk[0].size
}

output "this_data_disk_category" {
  value = alicloud_ess_scaling_configuration.this.data_disk[0].category
}

output "this_tags" {
  value = alicloud_ess_scaling_configuration.this.tags
}

