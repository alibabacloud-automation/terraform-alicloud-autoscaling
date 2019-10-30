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

output "this_autoscaling_group_load_balancers" {
  description = "The load balancer ids associated with the autoscaling group"
  value       = concat(alicloud_ess_scaling_group.this.*.loadbalancer_ids, [""])[0]
}
output "this_autoscaling_group_slb_ids" {
  description = "Same with `this_autoscaling_group_load_balancers`"
  value       = concat(alicloud_ess_scaling_group.this.*.loadbalancer_ids, [""])[0]
}
output "this_autoscaling_group_rds_instance_ids" {
  description = "The rds instance ids associated with the autoscaling group"
  value       = concat(alicloud_ess_scaling_group.this.*.db_instance_ids, [""])[0]
}
output "this_autoscaling_group_vswitch_ids" {
  description = "The vswitch ids associated with the autoscaling group"
  value       = concat(alicloud_ess_scaling_group.this.*.vswitch_ids, [""])[0]
}
output "this_autoscaling_group_sg_ids" {
  description = "The security group ids associated with the autoscaling group"
  value       = concat(alicloud_ess_scaling_configuration.this.*.security_group_ids, [""])[0]
}
output "this_autoscaling_group_instance_ids" {
  description = "The ECS instance ids associated with the autoscaling group"
  value       = concat(alicloud_ess_scaling_configuration.this.*.instance_ids, [""])[0]
}