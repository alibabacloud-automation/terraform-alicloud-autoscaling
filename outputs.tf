output "this_autoscaling_configuration_id" {
  description = "The id of the autoscaling configuration"
  value       = concat(alicloud_ess_scaling_configuration.this.*.id, [""])[0]
}

output "this_autoscaling_configuration_name" {
  description = "The name of the autoscaling configuration"
  value       = concat(alicloud_ess_scaling_configuration.this.*.scaling_configuration_name, [""])[0]
}

output "this_autoscaling_group_id" {
  description = "The id of the autoscaling group"
  value       = local.scaling_group_id
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
  value       = alicloud_ess_scaling_group.this.*.loadbalancer_ids
}
output "this_autoscaling_group_slb_ids" {
  description = "Same with `this_autoscaling_group_load_balancers`"
  value       = alicloud_ess_scaling_group.this.*.loadbalancer_ids
}
output "this_autoscaling_group_rds_instance_ids" {
  description = "The rds instance ids associated with the autoscaling group"
  value       = alicloud_ess_scaling_group.this.*.db_instance_ids
}
output "this_autoscaling_group_vswitch_ids" {
  description = "The vswitch ids associated with the autoscaling group"
  value       = alicloud_ess_scaling_group.this.*.vswitch_ids
}
output "this_autoscaling_group_sg_ids" {
  description = "The security group ids associated with the autoscaling group"
  value       = alicloud_ess_scaling_configuration.this.*.security_group_ids
}

output "this_autoscaling_group_multi_az_policy" {
  description = "Multi-AZ scaling group ECS instance expansion and contraction strategy"
  value       = concat(alicloud_ess_scaling_group.this.*.multi_az_policy, [""])[0]
}
output "this_autoscaling_group_on_demand_base_capacity" {
  description = "The minimum amount of the Auto Scaling group's capacity that must be fulfilled by On-Demand Instances"
  value       = concat(alicloud_ess_scaling_group.this.*.on_demand_base_capacity, [""])[0]
}
output "this_autoscaling_group_on_demand_percentage_above_base_capacity" {
  description = "Controls the percentages of On-Demand Instances and Spot Instances for your additional capacity beyond OnDemandBaseCapacity"
  value       = concat(alicloud_ess_scaling_group.this.*.on_demand_percentage_above_base_capacity, [""])[0]
}
output "this_autoscaling_group_spot_instance_pools" {
  description = "The number of Spot pools to use to allocate your Spot capacity."
  value       = concat(alicloud_ess_scaling_group.this.*.spot_instance_pools, [""])[0]
}
output "this_autoscaling_group_spot_instance_remedy" {
  description = "Whether to replace spot instances with newly created spot/onDemand instance when receive a spot recycling message."
  value       = concat(alicloud_ess_scaling_group.this.*.spot_instance_remedy, [""])[0]
}

output "this_autoscaling_lifecycle_hook_id" {
  description = "The id of the lifecycle hook"
  value       = concat(alicloud_ess_lifecycle_hook.this.*.id, [""])[0]
}
output "this_autoscaling_lifecycle_hook_name" {
  description = "The name of the lifecycle hook"
  value       = concat(alicloud_ess_lifecycle_hook.this.*.name, [""])[0]
}
output "this_autoscaling_lifecycle_hook_notification_arn" {
  description = "The notification arn of the lifecycle hook"
  value       = concat(alicloud_ess_lifecycle_hook.this.*.notification_arn, [""])[0]
}