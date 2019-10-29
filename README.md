Alicloud Auto Scaling Terraform Module  
terraform-alicloud-autoscaling
---

Terraform moudle which create Auto Scaling resource on Alicloud.

These types of resources are supported:

* [Auto Scaling Group](https://www.terraform.io/docs/providers/alicloud/r/ess_scaling_group.html)
* [Auto Scaling Configuration](https://www.terraform.io/docs/providers/alicloud/r/ess_scaling_configuration.html)

## Usage

```hcl
module "example" {
  source = "terraform-alicloud-modules/autoscaling/alicloud"
  profile = "default"
  // Autoscaling Group
  scaling_group_name = "testAccEssScalingGroup"
  min_size           = 0
  max_size           = 1
  vswitch_ids = [
    "vsw-2ze0rxn9houkr2j00sfu0",
  ]
  // Autoscaling Configuration
  image_id                   = "centos_7_03_64_20G_alibase_20170818.vhd"
  instance_types              = ["ecs.n1.small"]
  security_group_ids         = ["sg-2ze0zgaj3hne6aiddmxx"]
  scaling_configuration_name = "testAccEssScalingConfiguration"
  internet_max_bandwidth_out = "1"
  instance_name              = "testAccEss"
  tags = {
    tag1 = "tag_value1"
    tag2 = "tag_value2"
  }
  force_delete = "true"
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

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| region  | The region ID used to launch this module resources. If not set, it will be sourced from followed by ALICLOUD_REGION environment variable and profile | string  | ''  | no  |
| profile  | The profile name as set in the shared credentials file. If not set, it will be sourced from the ALICLOUD_PROFILE environment variable. | string  | ''  | no  |
| shared_credentials_file  | This is the path to the shared credentials file. If this is not set and a profile is specified, $HOME/.aliyun/config.json will be used. | string  | ''  | no  |
| skip_region_validation  | Skip static validation of region ID. Used by users of alternative AlibabaCloud-like APIs or users w/ access to regions that are not public (yet). | bool  | false | no  |
| scaling_group_id  | Specifying existing autoscaling group ID. If not set, a new one will be created named with `scaling_group_name`.  | string  | ''  | no  |
| scaling_group_name  | The name for autoscaling group. Default to a random string prefixed with `terraform-ess-group-` | string  | ''  | no  |
| min_size  | Minimum number of ECS instances in the scaling group  | string  | 1  | yes  |
| max_size  | Maximum number of ECS instance in the scaling group  | string  | 3  | yes  |
| default_cooldown  | The amount of time (in seconds),after a scaling activity completes before another scaling activity can start  | string  | 300  | no  |
| removal_policies  | RemovalPolicy is used to select the ECS instances you want to remove from the scaling group when multiple candidates for removal exist  | list  | ["OldestScalingConfiguration", "OldestInstance"]  | no  |
| image_id  | The Ecs image ID to launch  | string  | -  | yes  |
| image_owners  | The image owner used to retrieve ECS images | string  | "system" | yes  |
| image_name_regex  | The name regex used to retrieve ECS images  | string  | "^ubuntu_18.*_64" | yes  |
| instance_type  | Resource type of an ECS instance. If not set, it can be retrieved by `cpu_core_count` and `memory_size`  | string  | -  | no  |
| cpu_core_count  | CPU core count used to fetch instance types | int  | 2  | no  |
| memory_size  | Memory size used to fetch instance types  | int  | 4 | no  |
| instance_name  | Name of an ECS instance. Default to a random string prefixed with `terraform-ess-instance-` | string  |  - | no  |
| scaling_configuration_name  | Name for the autoscaling configuration. Default to a random string prefixed with `terraform-ess-configuration-` | string  | ''  | no |
| internet_charge_type  | The ECS instance network billing type: PayByTraffic or PayByBandwidth. | string  | 'PayByTraffic' | no  |
| internet_max_bandwidth_in  | Maximum incoming bandwidth from the public network  | string  | 200  | no  |
| internet_max_bandwidth_out  | Maximum outgoing bandwidth from the public network  | string  | 0  | no  |
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
| this_autoscaling_group_rds_instance_ids | The rds instance ids associated with the autoscaling group |
|this_autoscaling_group_vswitch_ids | The vswitch ids associated with the autoscaling group |
| this_autoscaling_group_sg_ids | The security group ids associated with the autoscaling group |
| this_autoscaling_group_instance_ids | The ECS instance ids associated with the autoscaling group |

Authors
----
Created and maintained by Tong Kangning(@TalentNing, xiaoxiaoerke@163.com) and He Guimin(@xiaozhu36, heguimin36@163.com)

License
----
Apache 2 Licensed. See LICENSE for full details.

Reference
---------
* [Terraform-Provider-Alicloud Github](https://github.com/terraform-providers/terraform-provider-alicloud)
* [Terraform-Provider-Alicloud Release](https://releases.hashicorp.com/terraform-provider-alicloud/)
* [Terraform-Provider-Alicloud Docs](https://www.terraform.io/docs/providers/alicloud/index.html)
