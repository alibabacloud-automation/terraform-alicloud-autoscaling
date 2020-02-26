 terraform-alicloud-autoscaling
-------------------------------

Terraform模块用于在阿里云上创建自动缩放资源。

支持以下类型的资源：

* [Auto Scaling Group](https://www.terraform.io/docs/providers/alicloud/r/ess_scaling_group.html)
* [Auto Scaling Configuration](https://www.terraform.io/docs/providers/alicloud/r/ess_scaling_configuration.html)
* [Auto Scaling Lifecycle Hook](https://www.terraform.io/docs/providers/alicloud/r/ess_scaling_lifecycle_hook.html)

## Terraform 版本

本 Module 要求使用 Terraform 0.12 和 阿里云 Provider 1.62.0+。

## 用法

```hcl
module "example" {
  source = "terraform-alicloud-modules/autoscaling/alicloud"
  region = "cn-beijing"
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

## 注意事项

* 本 Module 使用的 AccessKey 和 SecretKey 可以直接从 `profile` 和 `shared_credentials_file` 中获取。如果未设置，可通过下载安装 [aliyun-cli](https://github.com/aliyun/aliyun-cli#installation) 后进行配置。

* 如果一个缩放组只有一个缩放配置，则可以在 `force_delete = true` 时删除。

## 条件创建

这个模型可以创建自动缩放组 (ASG) 和自动缩放配置 (ASC)，它仅当您指定 'scaling_group_id' 参数或使用过滤器自动获取安全组、负载平衡器等其他资源。

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

## 入参

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

## 出参

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

提交问题
-------
如果在使用该 Terraform Module 的过程中有任何问题，可以直接创建一个 [Provider Issue](https://github.com/terraform-providers/terraform-provider-alicloud/issues/new)，我们将根据问题描述提供解决方案。

**注意:** 不建议在该 Module 仓库中直接提交 Issue。

作者
----
Created and maintained by Tong Kangning(@TalentNing, xiaoxiaoerke@163.com) and He Guimin(@xiaozhu36, heguimin36@163.com)

许可
----
Apache 2 Licensed. See LICENSE for full details.

参考
---------
* [Terraform-Provider-Alicloud Github](https://github.com/terraform-providers/terraform-provider-alicloud)
* [Terraform-Provider-Alicloud Release](https://releases.hashicorp.com/terraform-provider-alicloud/)
* [Terraform-Provider-Alicloud Docs](https://www.terraform.io/docs/providers/alicloud/index.html)
