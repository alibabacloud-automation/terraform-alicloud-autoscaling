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

variable "filter_with_name_regex" {
  description = "A default filter applied to retrieve existing vswitches, security groups, load balancers, and rds instances by name regex."
  default     = ""
}

variable "filter_with_tags" {
  description = "A default filter applied to retrieve existing vswitches, security groups, load balancers, and rds instances by tags."
  type        = map(string)
  default     = {}
}
variable "slb_name_regex" {
  description = "A default filter applied to retrieve existing load balancers by name regex. If not set, `filter_with_name_regex` will be used."
  default     = ""
}

variable "slb_tags" {
  description = "A default filter applied to retrieve existing load balancers by tags. If not set, `filter_with_tags` will be used."
  type        = map(string)
  default     = {}
}
variable "vswitch_name_regex" {
  description = "A default filter applied to retrieve existing vswitches by name regex. If not set, `filter_with_name_regex` will be used."
  default     = ""
}

variable "vswitch_tags" {
  description = "A default filter applied to retrieve existing vswitches by tags. If not set, `filter_with_tags` will be used."
  type        = map(string)
  default     = {}
}
variable "rds_name_regex" {
  description = "A default filter applied to retrieve existing rds instances by name regex. If not set, `filter_with_name_regex` will be used."
  default     = ""
}

variable "rds_tags" {
  description = "A default filter applied to retrieve existing rds instances by tags. If not set, `filter_with_tags` will be used."
  type        = map(string)
  default     = {}
}
variable "sg_name_regex" {
  description = "A default filter applied to retrieve existing security groups by name regex. If not set, `filter_with_name_regex` will be used."
  default     = ""
}

variable "sg_tags" {
  description = "A default filter applied to retrieve existing security groups by tags. If not set, `filter_with_tags` will be used."
  type        = map(string)
  default     = {}
}

# Image variables
variable "image_id" {
  description = "The image id used to launch ecs instances. If not set, a system image with `image_name_regex` will be returned."
  default     = ""
}
variable "image_owners" {
  description = "The image owner used to retrieve ECS images."
  default     = "system"
}
variable "image_name_regex" {
  description = "The name regex used to retrieve ECS images."
  default     = "^ubuntu_18.*64"
}

# Instance typs variables
variable "cpu_core_count" {
  description = "CPU core count used to fetch instance types."
  default     = 2
}

variable "memory_size" {
  description = "Memory size used to fetch instance types."
  default     = 4
}

variable "scaling_group_id" {
  description = "Specifying existing autoscaling group ID. If not set, a new one will be created named with `scaling_group_name`."
  default     = ""
}

variable "scaling_group_name" {
  description = "The name for autoscaling group. Default to a random string prefixed with `terraform-ess-group-`."
  default     = ""
}

variable "min_size" {
  description = "Minimum number of ECS instances in the scaling group"
  default     = 1
}

variable "max_size" {
  description = "Maximum number of ECS instance in the scaling group"
  default     = 3
}

variable "default_cooldown" {
  description = "The amount of time (in seconds),after a scaling activity completes before another scaling activity can start"
  default     = 300
}

variable "vswitch_ids" {
  description = "List of virtual switch IDs in which the ecs instances to be launched. If not set, it can be retrieved automatically by specifying filter `vswitch_name_regex` or `vswitch_tags`."
  type        = list(string)
  default     = []
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
  description = "A list of rds instance ids to add to the autoscaling group. If not set, it can be retrieved automatically by specifying filter `rds_name_regex` or `rds_tags`."
  type        = list(string)
  default     = []
}

variable "loadbalancer_ids" {
  description = "A list of loadbalancer ids to add to the autoscaling group. If not set, it can be retrieved automatically by specifying filter `slb_name_regex` or `slb_tags`."
  type        = list(string)
  default     = []
}

variable "multi_az_policy" {
  description = "Multi-AZ scaling group ECS instance expansion and contraction strategy. PRIORITY, BALANCE or COST_OPTIMIZED"
  type        = string
  default     = null
}
variable "on_demand_base_capacity" {
  description = "The minimum amount of the Auto Scaling group's capacity that must be fulfilled by On-Demand Instances. This base portion is provisioned first as your group scales."
  type        = number
  default     = null
}
variable "on_demand_percentage_above_base_capacity" {
  description = "Controls the percentages of On-Demand Instances and Spot Instances for your additional capacity beyond OnDemandBaseCapacity."
  type        = number
  default     = null
}
variable "spot_instance_pools" {
  description = "The number of Spot pools to use to allocate your Spot capacity. The Spot pools is composed of instance types of lowest price."
  type        = number
  default     = null
}
variable "spot_instance_remedy" {
  description = "Whether to replace spot instances with newly created spot/onDemand instance when receive a spot recycling message."
  type        = bool
  default     = null
}

# Autoscaling configuration
variable "instance_type" {
  description = "(Deprecated) It has been deprecated from 1.4.0 and use `instance_types` instead."
  default     = ""
}

variable "instance_types" {
  description = "A list of ECS instance types. If not set, one will be returned automatically by specifying `cpu_core_count` and `memory_size`. If it is set, `instance_type` will be ignored."
  type        = "list"
  default     = []
}
variable "create_scaling_configuration" {
  description = "Whether to create a new scaling configuraion."
  type        = bool
  default     = true
}
variable "security_group_id" {
  description = "(Deprecated) It is deprecated from 1.3.0 and used new parameter security_group_ids instead."
  default     = ""
}
variable "security_group_ids" {
  type        = "list"
  description = "List IDs of the security group to which a newly created instance belongs. If not set, it can be retrieved automatically by specifying filter `sg_name_regex` or `sg_tags`."
  default     = []
}

variable "instance_name" {
  description = "Name of an ECS instance. Default to a random string prefixed with `terraform-ess-instance-`."
  default     = ""
}

variable "scaling_configuration_name" {
  description = "Name for the autoscaling configuration. Default to a random string prefixed with `terraform-ess-configuration-`."
  default     = ""
}

variable "internet_charge_type" {
  description = "The ECS instance network billing type: PayByTraffic or PayByBandwidth."
  default     = "PayByTraffic"
}

variable "internet_max_bandwidth_in" {
  description = "Maximum incoming bandwidth from the public network"
  default     = 200
}

variable "internet_max_bandwidth_out" {
  description = "Maximum outgoing bandwidth from the public network. It will be ignored when `associate_public_ip_address` is false."
  default     = 0
}

variable "associate_public_ip_address" {
  description = "Whether to associate a public ip address with an instance in a VPC."
  type        = bool
  default     = false
}
variable "system_disk_category" {
  description = "Category of the system disk"
  default     = "cloud_efficiency"
}

variable "system_disk_size" {
  description = "Size of the system disk"
  default     = 40
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
  type        = bool
  default     = false
}

variable "data_disk_size" {
  description = "(Removed) It has been removed from version 1.3.0 and use `data_disks` instead."
  type        = string
  default     = ""
}

variable "data_disk_category" {
  description = "(Removed) It has been removed from version 1.3.0 and use `data_disks` instead."
  type        = string
  default     = ""
}

variable "data_disks" {
  description = "Additional data disks to attach to the scaled ECS instance"
  type        = list(map(string))
  default     = []
}
variable "password_inherit" {
  description = "Specifies whether to use the password that is predefined in the image. If true, the `password` and `kms_encrypted_password` will be ignored. You must ensure that the selected image has a password configured."
  type        = bool
  default     = false
}
variable "password" {
  description = "The password of the ECS instance. It is valid when `password_inherit` is false"
  default     = ""
}
variable "kms_encrypted_password" {
  description = "An KMS encrypts password used to a db account. If `password_inherit` and `password` is set, this field will be ignored."
  default     = ""
}
variable "kms_encryption_context" {
  description = "An KMS encryption context used to decrypt `kms_encrypted_password` before creating ECS instance. See Encryption Context: https://www.alibabacloud.com/help/doc-detail/42975.htm. It is valid when kms_encrypted_password is set."
  type        = map(string)
  default     = {}
}
variable "tags" {
  description = "A mapping of tags used to create a new scaling configuration."
  type        = map(string)
  default     = {}
}

// lifecycle hook
variable "create_lifecycle_hook" {
  description = "Whether to create lifecycle hook for this scaling group"
  type        = bool
  default     = false
}
variable "lifecycle_hook_name" {
  description = "The name for lifecyle hook. Default to a random string prefixed with `terraform-ess-hook-`."
  default     = ""
}
variable "lifecycle_transition" {
  description = "Type of Scaling activity attached to lifecycle hook. Supported value: SCALE_OUT, SCALE_IN."
  default     = "SCALE_IN"
}
variable "heartbeat_timeout" {
  description = "Defines the amount of time, in seconds, that can elapse before the lifecycle hook times out. When the lifecycle hook times out, Auto Scaling performs the action defined in the default_result parameter."
  default     = 600
}
variable "hook_action_policy" {
  description = "Defines the action which scaling group should take when the lifecycle hook timeout elapses. Valid value: CONTINUE, ABANDON."
  default     = "CONTINUE"
}
variable "mns_topic_name" {
  description = "Specify a MNS topic to send notification"
  default     = ""
}
variable "mns_queue_name" {
  description = "Specify a MNS queue to send notification. It will be ignored when `mns_topic_name` is set."
  default     = ""
}
variable "notification_metadata" {
  description = "Additional information that you want to include when Auto Scaling sends a message to the notification target."
  default     = ""
}
