#alicloud_kms_key
variable "pending_window_in_days" {
  description = "Duration in days after which the key is deleted after destruction of the resource, must be between 7 and 30 days. Defaults to 30 days."
  type        = string
  default     = "30"
}

#alicloud_ram_role
variable "document" {
  description = "Authorization strategy of the RAM role."
  type        = string
  default     = <<EOF
  {
    "Statement": [
      {
        "Action": "sts:AssumeRole",
        "Effect": "Allow",
        "Principal": {
          "Service": [
            "apigateway.aliyuncs.com",
            "ecs.aliyuncs.com"
          ]
        }
      }
    ],
    "Version": "1"
  }
  EOF
}

#alicloud_db_instance
variable "instance_storage" {
  description = "The specification of the instance storage."
  type        = string
  default     = "30"
}

variable "instance_charge_type" {
  description = "The specification of the instance charge type."
  type        = string
  default     = "Postpaid"
}

variable "monitoring_period" {
  description = "The specification of the monitoring period."
  type        = string
  default     = "60"
}

#alicloud_slb_load_balancer
variable "load_balancer_spec" {
  description = "The specification of the Server Load Balancer instance."
  type        = string
  default     = "slb.s2.small"
}

#alicloud_slb_listener
variable "bandwidth" {
  description = "Bandwidth peak of Listener."
  type        = number
  default     = 10
}

#alicloud_ess_scaling_group
variable "scaling_group_name" {
  description = "The name for autoscaling group. Default to a random string prefixed with `terraform-ess-group-`."
  type        = string
  default     = "tf-scaling-group-name"
}

variable "min_size" {
  description = "Minimum number of ECS instances in the scaling group"
  type        = number
  default     = 1
}

variable "max_size" {
  description = "Maximum number of ECS instance in the scaling group"
  type        = number
  default     = 3
}

variable "default_cooldown" {
  description = "The amount of time (in seconds),after a scaling activity completes before another scaling activity can start"
  type        = number
  default     = 300
}

variable "removal_policies" {
  description = "RemovalPolicy is used to select the ECS instances you want to remove from the scaling group when multiple candidates for removal exist"
  type        = list(string)
  default = [
    "OldestScalingConfiguration",
    "OldestInstance",
  ]
}

variable "on_demand_base_capacity" {
  description = "The minimum amount of the Auto Scaling group's capacity that must be fulfilled by On-Demand Instances. This base portion is provisioned first as your group scales."
  type        = number
  default     = 8
}

variable "on_demand_percentage_above_base_capacity" {
  description = "Controls the percentages of On-Demand Instances and Spot Instances for your additional capacity beyond OnDemandBaseCapacity."
  type        = number
  default     = 8
}

variable "spot_instance_pools" {
  description = "The number of Spot pools to use to allocate your Spot capacity. The Spot pools is composed of instance types of lowest price."
  type        = number
  default     = 10
}

variable "spot_instance_remedy" {
  description = "Whether to replace spot instances with newly created spot/onDemand instance when receive a spot recycling message."
  type        = bool
  default     = true
}

#alicloud_ess_scaling_configuration
variable "scaling_configuration_name" {
  description = "Name for the autoscaling configuration. Default to a random string prefixed with `terraform-ess-configuration-`."
  type        = string
  default     = "tf-scaling-configuration-name"
}

variable "internet_charge_type" {
  description = "The ECS instance network billing type: PayByTraffic or PayByBandwidth."
  type        = string
  default     = "PayByTraffic"
}

variable "internet_max_bandwidth_in" {
  description = "Maximum incoming bandwidth from the public network"
  type        = number
  default     = 10
}

variable "internet_max_bandwidth_out" {
  description = "Maximum outgoing bandwidth from the public network. It will be ignored when `associate_public_ip_address` is false."
  type        = number
  default     = 10
}

variable "system_disk_category" {
  description = "Category of the system disk"
  type        = string
  default     = "cloud_efficiency"
}

variable "system_disk_size" {
  description = "Size of the system disk"
  type        = number
  default     = 40
}

variable "enable" {
  description = "Whether enable the specified scaling group(make it active) to which the current scaling configuration belongs."
  type        = bool
  default     = true
}

variable "active" {
  description = "Whether active current scaling configuration in the specified scaling group"
  type        = bool
  default     = true
}

variable "user_data" {
  description = "User-defined data to customize the startup behaviors of the ECS instance and to pass data into the ECS instance"
  type        = string
  default     = "tf-user-data"
}

variable "force_delete" {
  description = "The last scaling configuration will be deleted forcibly with deleting its scaling group"
  type        = bool
  default     = false
}

variable "password_inherit" {
  description = "Specifies whether to use the password that is predefined in the image. If true, the `password` and `kms_encrypted_password` will be ignored. You must ensure that the selected image has a password configured."
  type        = bool
  default     = false
}

variable "tags" {
  description = "A mapping of tags used to create a new scaling configuration."
  type        = map(string)
  default = {
    Created = "tf"
  }
}

#alicloud_ess_lifecycle_hook
variable "lifecycle_transition" {
  description = "Type of Scaling activity attached to lifecycle hook. Supported value: SCALE_OUT, SCALE_IN."
  type        = string
  default     = "SCALE_IN"
}

variable "heartbeat_timeout" {
  description = "Defines the amount of time, in seconds, that can elapse before the lifecycle hook times out. When the lifecycle hook times out, Auto Scaling performs the action defined in the default_result parameter."
  type        = number
  default     = 600
}

variable "hook_action_policy" {
  description = "Defines the action which scaling group should take when the lifecycle hook timeout elapses. Valid value: CONTINUE, ABANDON."
  type        = string
  default     = "CONTINUE"
}

variable "notification_metadata" {
  description = "Additional information that you want to include when Auto Scaling sends a message to the notification target."
  type        = string
  default     = "tf-autoscaling"
}