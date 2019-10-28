//Autoscaling group
variable "region" {
  description = "The region ID used to launch this module resources. If not set, it will be sourced from followed by ALICLOUD_REGION environment variable and profile."
  default     = ""
}

variable "profile" {
  description = "The profile name as set in the shared credentials file. If not set, it will be sourced from the ALICLOUD_PROFILE environment variable."
  default     = ""
}
variable "shared_credentials_file" {
  description = "This is the path to the shared credentials file. If this is not set and a profile is specified, $HOME/.aliyun/config.json will be used."
  default     = ""
}

variable "skip_region_validation" {
  description = "Skip static validation of region ID. Used by users of alternative AlibabaCloud-like APIs or users w/ access to regions that are not public (yet)."
  default     = false
}

variable "scaling_group_id" {
  description = "Specifying existing autoscaling group ID"
  default     = ""
}

variable "scaling_group_name" {
  description = "The name for autoscaling group"
  default     = ""
}

variable "min_size" {
  description = "Minimum number of ECS instances in the scaling group"
}

variable "max_size" {
  description = "Maximum number of ECS instance in the scaling group"
}

variable "default_cooldown" {
  description = "The amount of time (in seconds),after a scaling activity completes before another scaling activity can start"
  default     = 300
}

variable "vswitch_ids" {
  description = "List of virtual switch IDs in which the ecs instances to be launched"
  type        = list(string)

  default = [
    "",
  ]
}

variable "removal_policies" {
  description = "RemovalPolicy is used to select the ECS instances you want to remove from the scaling group when multiple candidates for removal exist"
  type        = list(string)

  default = [
    "OldestScalingConfiguration",
    "OldestInstance",
  ]
}

variable "db_instance_ids" {
  description = "A list of rds instance ids to add to the autoscaling group"
  type        = list(string)

  default = [
    "",
  ]
}

variable "loadbalancer_ids" {
  description = "A list of loadbalancer ids to add to the autoscaling group"
  type        = list(string)
  default     = []
}

# Autoscaling configuration
variable "image_id" {
  description = "The Ecs image ID to launch"
}

variable "instance_type" {
  description = "Resource type of an ECS instance"
}

variable "security_group_id" {
  description = "(Deprecated) Used new parameter security_group_ids instead."
  default     = ""
}
variable "security_group_ids" {
  type        = "list"
  description = "List IDs of the security group to which a newly created instance belongs"
  default     = []
}

variable "instance_name" {
  description = "Name of an ECS instance"
}

variable "scaling_configuration_name" {
  description = "Name for the autoscaling configuration"
  default     = ""
}

variable "internet_charge_type" {
  description = "Network billing type"
  default     = "PayByTraffic"
}

variable "internet_max_bandwidth_in" {
  description = "Maximum incoming bandwidth from the public network"
  default     = 200
}

variable "internet_max_bandwidth_out" {
  description = "Maximum outgoing bandwidth from the public network"
  default     = 0
}

variable "system_disk_category" {
  description = "Category of the system disk"
  default     = "cloud_efficiency"
}

variable "enable" {
  description = "Whether enable the specified scaling group(make it active) to which the current scaling configuration belongs."
  default     = "true"
}

variable "active" {
  description = "Whether active current scaling configuration in the specified scaling group"
  default     = "true"
}

variable "user_data" {
  description = "User-defined data to customize the startup behaviors of the ECS instance and to pass data into the ECS instance"
  default     = ""
}

variable "key_name" {
  description = "The name of key pair that login ECS"
  default     = ""
}

variable "role_name" {
  description = "Instance RAM role name"
  default     = ""
}

variable "force_delete" {
  description = "The last scaling configuration will be deleted forcibly with deleting its scaling group"
  default     = false
}

variable "data_disk_size" {
  description = "DataDisk size to attach to ecs instance"
  type        = string
  default     = "20"
}

variable "data_disk_category" {
  description = "DataDisk category to attach to ecs instance"
  type        = string
  default     = "cloud_efficiency"
}

variable "tags" {
  description = "A mapping of tags to assign to the resource"
  type        = map(string)
  default     = {}
}

