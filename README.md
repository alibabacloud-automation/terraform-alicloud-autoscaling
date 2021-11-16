Alicloud Auto Scaling Terraform Module  
terraform-alicloud-autoscaling
---

Terraform moudle which create Auto Scaling resources on Alicloud.

These types of resources are supported:

* [Auto Scaling Group](https://www.terraform.io/docs/providers/alicloud/r/ess_scaling_group.html)
* [Auto Scaling Configuration](https://www.terraform.io/docs/providers/alicloud/r/ess_scaling_configuration.html)
* [Auto Scaling Lifecycle Hook](https://www.terraform.io/docs/providers/alicloud/r/ess_scaling_lifecycle_hook.html)

## Terraform versions

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.12.0 |
| <a name="requirement_alicloud"></a> [alicloud](#requirement\_alicloud) | >= 1.62.0

## Usage

```hcl
module "example" {
  source = "terraform-alicloud-modules/autoscaling/alicloud"
  // Autoscaling Group
  scaling_group_name = "testAccEssScalingGroup"
  min_size           = 0
  max_size           = 1
  vswitch_ids = [
    "vsw-2ze0rxn9houkr2j00sfu0",
  ]
  // Autoscaling Configuration
  image_id                   = "centos_7_03_64_20G_alibase_20170818.vhd"
  instance_types              = ["ecs.n4.small"]
  security_group_ids         = ["sg-2ze0zgaj3hne6aiddmxx"]
  scaling_configuration_name = "testAccEssScalingConfiguration"
  internet_max_bandwidth_out = 1
  instance_name              = "testAccEss"
  tags = {
    tag1 = "tag_value1"
    tag2 = "tag_value2"
  }
  force_delete = true
  data_disks = [{
    size     = 20
    category = "cloud_ssd"
    },
    {
      size                 = 20
      category             = "cloud_ssd"
      delete_with_instance = false
  }]
}
```
## Notes
From the version v1.7.0, the module has removed the following `provider` setting:

```hcl
provider "alicloud" {
  profile                 = var.profile != "" ? var.profile : null
  shared_credentials_file = var.shared_credentials_file != "" ? var.shared_credentials_file : null
  region                  = var.region != "" ? var.region : null
  skip_region_validation  = var.skip_region_validation
  configuration_source    = "terraform-alicloud-modules/autoscaling"
}
```

If you still want to use the `provider` setting to apply this module, you can specify a supported version, like 1.6.0:

```hcl
module "autoscaling" {
  source = "terraform-alicloud-modules/autoscaling/alicloud"
  version     = "1.6.0"
  region      = "cn-hangzhou"
  profile     = "Your-Profile-Name"

  scaling_group_name = "testAccEssScalingGroup"
  min_size           = 0
  max_size           = 1
  vswitch_ids = [
    "vsw-2ze0rxn9houkr2j00sfu0",
  ]
}
```

If you want to upgrade the module to 1.7.0 or higher in-place, you can define a provider which same region with
previous region:

```hcl
provider "alicloud" {
   region  = "cn-hangzhou"
   profile = "Your-Profile-Name"
}
module "autoscaling" {
  source = "terraform-alicloud-modules/autoscaling/alicloud"
  scaling_group_name = "testAccEssScalingGroup"
  min_size           = 0
  max_size           = 1
  vswitch_ids = [
    "vsw-2ze0rxn9houkr2j00sfu0",
  ]
}
```
or specify an alias provider with a defined region to the module using `providers`:

```hcl
provider "alicloud" {
  region  = "cn-hangzhou"
  profile = "Your-Profile-Name"
  alias   = "hz"
}
module "autoscaling" {
  source = "terraform-alicloud-modules/autoscaling/alicloud"
  providers = {
    alicloud = alicloud.hz
  }
  scaling_group_name = "testAccEssScalingGroup"
  min_size           = 0
  max_size           = 1
  vswitch_ids = [
    "vsw-2ze0rxn9houkr2j00sfu0",
  ]
}
```

and then run `terraform init` and `terraform apply` to make the defined provider effect to the existing module state.
More details see [How to use provider in the module](https://www.terraform.io/docs/language/modules/develop/providers.html#passing-providers-explicitly)

## Conditional creation

This moudle can create both Auto Scaling group(ASG) and Auto Scaling configuration(ASC), it 
is possible to use external scaling group only if you specify `scaling_group_id` parameter or
use filter to get othere resources like security groups, load balancers and son on automatically.

1. To create ASC, but not ASG:
```hcl
scaling_group_id = "existing-scaling-group-id"
```

1. Retrieve the existed vswitches and security groups automatically, but not specify them ids:
```hcl
  vswitch_name_regex = "my-vswitch*"
  vswitch_tags = {
    name = "ess-module"
    from = "tf"
  }
  sg_name_regex = "my-sg*"
  sg_tags = {
    name = "ess-module"
    from = "tf"
  }
```

1. Retrieve the existed load balancers and rds instances automatically and attach them to ASG, but not specify them ids:
```hcl
  rds_name_regex = "my-rds"
  slb_name_regex = "my-slb"
  slb_tags = {
    name = "ess-module"
    from = "tf"
  }
```

1. If some resources(like vswitches, security groups, load balancers and so on) have same `name_regex` or `tags`, the filter needs to be set only once:
```hcl
  filter_with_name_regex = "my-ess*"
  filter_with_tags = {
    name = "ess-module"
    from = "tf"
  }
```

1. Create a lifecycle hook:
```hcl
  resource "alicloud_mns_topic" "this" {
    name = "for-ess-hook"
  }
```
```hcl
  create_lifecycle_hook = true
  lifecycle_hook_name = "ess-hook"
  mns_topic_name = alicloud_mns_topic.this.id
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| scaling_group_id  | Specifying existing autoscaling group ID. If not set, a new one will be created named with `scaling_group_name`.  | string  | ''  | no  |
| scaling_group_name  | The name for autoscaling group. Default to a random string prefixed with `terraform-ess-group-` | string  | ''  | no  |
| min_size  | Minimum number of ECS instances in the scaling group  | string  | 1  | yes  |
| max_size  | Maximum number of ECS instance in the scaling group  | string  | 3  | yes  |
| default_cooldown  | The amount of time (in seconds),after a scaling activity completes before another scaling activity can start  | string  | 300  | no  |
| removal_policies  | RemovalPolicy is used to select the ECS instances you want to remove from the scaling group when multiple candidates for removal exist  | list  | ["OldestScalingConfiguration", "OldestInstance"]  | no  |
| create_scaling_configuration  | Whether to create a new scaling configuraion  | bool  | true  | no  |
| scaling_configuration_name  | Name for the autoscaling configuration. Default to a random string prefixed with `terraform-ess-configuration-` | string  | ''  | no |
| image_id  | The Ecs image ID to launch  | string  | -  | yes  |
| image_owners  | The image owner used to retrieve ECS images | string  | "system" | yes  |
| image_name_regex  | The name regex used to retrieve ECS images  | string  | "^ubuntu_18.*_64" | yes  |
| instance_type  | (Deprecated) It has been deprecated from 1.4.0 and use `instance_types` instead  | string  | "" | no  |
| instance_types  | A list of ECS instance types. If not set, one will be returned automatically by specifying `cpu_core_count` and `memory_size`. If it is set, `instance_type` will be ignored  | list | [] | no  |
| cpu_core_count  | CPU core count used to fetch instance types | int  | 2  | no  |
| memory_size  | Memory size used to fetch instance types  | int  | 4 | no  |
| instance_name  | Name of an ECS instance. Default to a random string prefixed with `terraform-ess-instance-` | string  | "" | no  |
| internet_charge_type  | The ECS instance network billing type: PayByTraffic or PayByBandwidth. | string  | 'PayByTraffic' | no  |
| internet_max_bandwidth_in  | Maximum incoming bandwidth from the public network  | string  | 200  | no  |
| internet_max_bandwidth_out  | Maximum outgoing bandwidth from the public network. It will be ignored when `associate_public_ip_address` is false  | string  | 0  | no  |
| associate_public_ip_address | Whether to associate a public ip address with an instance in a VPC" | bool | false | no |
| system_disk_category  | Category of the system disk  | string  | cloud_efficiency  | no  |
| system_disk_size  | Size of the system disk  | int  | 40  | no  |
| enable  | Whether enable the specified scaling group(make it active) to which the current scaling configuration belongs  | string  | true  | no  |
| active  | Whether active current scaling configuration in the specified scaling group  | string  | true  | no  |
| user_data  | User-defined data to customize the startup behaviors of the ECS instance and to pass data into the ECS instance  | string  | ''  | no  |
| key_name  | The name of key pair that login ECS  | string  | ''  | no  |
| role_name  | Instance RAM role name  | string  | ''  | no  |
| force_delete  | The last scaling configuration will be deleted forcibly with deleting its scaling group  | string  | false  | no  |
| data_disk_category  | (Removed) It has been removed from version 1.3.0 and use `data_disks` instead  | string  | 'cloud_efficiency'  |  no |
| data_disk_size  | (Removed) It has been removed from version 1.3.0 and use `data_disks` instead  | string  | '20'  |  no |
| data_disks  | Additional data disks to attach to the scaled ECS instance | list(map(string))| [] | no |
| tags  | A mapping of tags used to create a new scaling configuration | map  | {}  | no  |
| create_lifecycle_hook  | Whether to create lifecycle hook for this scaling group | bool  | false | no |
| lifecycle_hook_name  | The name for lifecyle hook. Default to a random string prefixed with `terraform-ess-hook-` | string  | ''  | no |
| lifecycle_transition  | Type of Scaling activity attached to lifecycle hook. Supported value: SCALE_OUT, SCALE_IN | string  | 'SCALE_IN'  | no |
| heartbeat_timeout  | Defines the amount of time, in seconds, that can elapse before the lifecycle hook times out. When the lifecycle hook times out, Auto Scaling performs the action defined in the default_result parameter | int  | 600  | no |
| hook_action_policy  | Defines the action which scaling group should take when the lifecycle hook timeout elapses. Valid value: CONTINUE, ABANDON | string  | "CONTINUE"  | no |
| mns_topic_name  | Specify a MNS topic to send notification | string  | ""  | no |
| mns_queue_name  | Specify a MNS queue to send notification. It will be ignored when `mns_topic_name` is set | string  | ""  | no |
| notification_metadata  | Additional information that you want to include when Auto Scaling sends a message to the notification target | string  | ""  | no |
| filter_with_name_regex  | A default filter applied to retrieve existing vswitches, security groups, load balancers, and rds instances by name regex | string  | ""  | no  |
| filter_with_tags  | A default filter applied to retrieve existing vswitches, security groups, load balancers, and rds instances by tags | map(string)  | {}  | no  |
| vswitch_ids  | List of virtual switch IDs in which the ecs instances to be launched. If not set, it can be retrieved automatically by specifying filter `vswitch_name_regex` or `vswitch_tags`  | list  | []  | no  |
| vswitch_name_regex  | A default filter applied to retrieve existing vswitches by name regex. If not set, `filter_with_name_regex` will be used | string  | ""  | no  |
| vswitch_tags  | A default filter applied to retrieve existing vswitches by tags. If not set, `filter_with_tags` will be used | map(string)  | {}  | no  |
| db_instance_ids  | A list of rds instance ids to add to the autoscaling group. If not set, it can be retrieved automatically by specifying filter `rds_name_regex` or `rds_tags`  | list  | `<list>`  |  no |
| rds_name_regex  | A default filter applied to retrieve existing rds instances by name regex. If not set, `filter_with_name_regex` will be used | string  | ""  | no  |
| loadbalancer_ids  | A list of loadbalancer ids to add to the autoscaling group. If not set, it can be retrieved automatically by specifying filter `slb_name_regex` or `slb_tags` | list  | `<list>`  | no  |
| slb_name_regex  | A default filter applied to retrieve existing load balancers by name regex. If not set, `filter_with_name_regex` will be used | string  | ""  | no  |
| slb_tags  | A default filter applied to retrieve existing load balancers by tags. If not set, `filter_with_tags` will be used | map(string)  | {}  | no  |
| security_group_id  | (Deprecated) It is deprecated from 1.3.0 and used new parameter security_group_ids instead | string  | -  | no  |
| security_group_ids  | List IDs of the security group to which a newly created instance belongs. If not set, it can be retrieved automatically by specifying filter `sg_name_regex` or `sg_tags` | list  | -  | no  |
| sg_name_regex  | A default filter applied to retrieve existing security groups by name regex. If not set, `filter_with_name_regex` will be used | string  | ""  | no  |
| sg_tags  | A default filter applied to retrieve existing security groups by tags. If not set, `filter_with_tags` will be used | map(string)  | {}  | no  |

## Outputs

| Name | Description |
|------|-------------|
| this_autoscaling_configuration_id  | The ID of Autoscaling Configuration  |
| this_autoscaling_configuration_name  | The Name of Autoscaling Configuration  |
| this_autoscaling_group_id  | The ID of Autoscaling Group  |
| this_autoscaling_group_name  | The Name of Autoscaling Group  |
| this_autoscaling_group_min_size  | The maximum size of the autoscaling group  |
| this_autoscaling_group_max_size  | The minimum size of the autoscaling group  |
| this_autoscaling_group_default_cooldown  | The amount of time (in seconds),after a scaling activity completes before another scaling activity can start |
| this_autoscaling_group_load_balancers | The load balancer ids associated with the autoscaling group |
| this_autoscaling_group_slb_ids | Same with `this_autoscaling_group_load_balancers` |
| this_autoscaling_group_rds_instance_ids | The rds instance ids associated with the autoscaling group |
|this_autoscaling_group_vswitch_ids | The vswitch ids associated with the autoscaling group |
| this_autoscaling_group_sg_ids | The security group ids associated with the autoscaling group |
| this_autoscaling_group_instance_ids | The ECS instance ids associated with the autoscaling group |
| this_autoscaling_lifecycle_hook_id | The id of the lifecycle hook |
| this_autoscaling_lifecycle_hook_name | The name of the lifecycle hook |
| this_autoscaling_lifecycle_hook_notification_arn | The notification arn of the lifecycle hook |

Submit Issues
-------------
If you have any problems when using this module, please opening a [provider issue](https://github.com/terraform-providers/terraform-provider-alicloud/issues/new) and let us know.

**Note:** There does not recommend to open an issue on this repo.

Authors
----
Created and maintained by Alibaba Cloud Terraform Team(terraform@alibabacloud.com)

License
----
Apache 2 Licensed. See LICENSE for full details.

Reference
---------
* [Terraform-Provider-Alicloud Github](https://github.com/terraform-providers/terraform-provider-alicloud)
* [Terraform-Provider-Alicloud Release](https://releases.hashicorp.com/terraform-provider-alicloud/)
* [Terraform-Provider-Alicloud Docs](https://www.terraform.io/docs/providers/alicloud/index.html)
