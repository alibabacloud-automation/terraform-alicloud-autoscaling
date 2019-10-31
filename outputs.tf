output "this_autoscaling_configuration_id" {
  description = "The id of the autoscaling configuration"
  value       = alicloud_ess_scaling_configuration.this.0.id
}

output "this_autoscaling_configuration_name" {
  description = "The name of the autoscaling configuration"
  value       = alicloud_ess_scaling_configuration.this.0.scaling_configuration_name
}

output "this_autoscaling_group_id" {
  description = "The id of the autoscaling group"
  value       = local.scaling_group_id
}

output "this_autoscaling_group_name" {
  description = "The name of the autoscaling group"
  value       = alicloud_ess_scaling_group.this.0.scaling_group_name
}

output "this_autoscaling_group_min_size" {
  description = "The minimum size of the autoscaling group"
  value       = alicloud_ess_scaling_group.this.0.min_size
}

output "this_autoscaling_group_max_size" {
  description = "The maximum size of the autoscaling group"
  value       = alicloud_ess_scaling_group.this.0.max_size
}

output "this_autoscaling_group_default_cooldown" {
  description = "The default cooldown of the autoscaling group"
  value       = alicloud_ess_scaling_group.this.0.default_cooldown
}

output "this_autoscaling_group_load_balancers" {
  description = "The load balancer ids associated with the autoscaling group"
  value       = alicloud_ess_scaling_group.this.0.loadbalancer_ids
}
output "this_autoscaling_group_slb_ids" {
  description = "Same with `this_autoscaling_group_load_balancers`"
  value       = alicloud_ess_scaling_group.this.0.loadbalancer_ids
}
output "this_autoscaling_group_rds_instance_ids" {
  description = "The rds instance ids associated with the autoscaling group"
  value       = alicloud_ess_scaling_group.this.0.db_instance_ids
}
output "this_autoscaling_group_vswitch_ids" {
  description = "The vswitch ids associated with the autoscaling group"
  value       = alicloud_ess_scaling_group.this.0.vswitch_ids
}
output "this_autoscaling_group_sg_ids" {
  description = "The security group ids associated with the autoscaling group"
  value       = alicloud_ess_scaling_configuration.this.0.security_group_ids
}
output "this_autoscaling_group_instance_ids" {
  description = "The ECS instance ids associated with the autoscaling group"
  value       = alicloud_ess_scaling_configuration.this.0.instance_ids
}
output "this_autoscaling_lifecycle_hook_id" {
  description = "The id of the lifecycle hook"
  value       = alicloud_ess_lifecycle_hook.this.0.id
}
output "this_autoscaling_lifecycle_hook_name" {
  description = "The name of the lifecycle hook"
  value       = alicloud_ess_lifecycle_hook.this.0.name
}
output "this_autoscaling_lifecycle_hook_notification_arn" {
  description = "The notification arn of the lifecycle hook"
  value       = alicloud_ess_lifecycle_hook.this.0.notification_arn
}