output "this_autoscaling_configuration_id" {
  description = "The id of the autoscaling configuration"
  value       = "${alicloud_ess_scaling_configuration.this.id}"
}

output "this_autoscaling_configuration_name" {
  description = "The name of the autoscaling configuration"
  value       = "${alicloud_ess_scaling_configuration.this.scaling_configuration_name}"
}

output "this_autoscaling_group_id" {
  description = "The id of the autoscaling group"
  value       = "${var.scaling_group_id=="" ? join("",alicloud_ess_scaling_group.this.*.id) : var.scaling_group_id}"
}

output "this_autoscaling_group_name" {
  description = "The name of the autoscaling group"
  value       = "${element(concat(alicloud_ess_scaling_group.this.*.scaling_group_name,list("")), 0)}"
}

output "this_autoscaling_group_min_size" {
  description = "The minimum size of the autoscaling group"
  value       = "${element(concat(alicloud_ess_scaling_group.this.*.min_size,list("")), 0)}"
}

output "this_autoscaling_group_max_size" {
  description = "The maximum size of the autoscaling group"
  value       = "${element(concat(alicloud_ess_scaling_group.this.*.max_size,list("")), 0)}"
}

output "this_autoscaling_group_default_cooldown" {
  description = "The default cooldown of the autoscaling group"
  value       = "${element(concat(alicloud_ess_scaling_group.this.*.default_cooldown,list("")), 0)}"
}
