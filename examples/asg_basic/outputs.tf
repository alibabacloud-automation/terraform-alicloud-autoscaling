output "this_scaling_group_id" {
  description = "The id of scaling group"
  value       = module.example.this_autoscaling_group_id
}

output "this_scaling_configuration_id" {
  description = "The id of scaling configuration"
  value       = module.example.this_autoscaling_configuration_id
}
