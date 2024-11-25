 terraform-alicloud-autoscaling
-------------------------------

Terraform模块用于在阿里云上创建自动缩放资源。

支持以下类型的资源：

* [Auto Scaling Group](https://www.terraform.io/docs/providers/alicloud/r/ess_scaling_group.html)
* [Auto Scaling Configuration](https://www.terraform.io/docs/providers/alicloud/r/ess_scaling_configuration.html)
* [Auto Scaling Lifecycle Hook](https://www.terraform.io/docs/providers/alicloud/r/ess_scaling_lifecycle_hook.html)

## 用法

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

## 注意事项
本Module从版本v1.7.0开始已经移除掉如下的 provider 的显式设置：
```hcl
provider "alicloud" {
  profile                 = var.profile != "" ? var.profile : null
  shared_credentials_file = var.shared_credentials_file != "" ? var.shared_credentials_file : null
  region                  = var.region != "" ? var.region : null
  skip_region_validation  = var.skip_region_validation
  configuration_source    = "terraform-alicloud-modules/autoscaling"
}
```

如果你依然想在Module中使用这个 provider 配置，你可以在调用Module的时候，指定一个特定的版本，比如 1.6.0:

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

如果你想对正在使用中的Module升级到 1.7.0 或者更高的版本，那么你可以在模板中显式定义一个相同Region的provider：
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
或者，如果你是多Region部署，你可以利用 `alias` 定义多个 provider，并在Module中显式指定这个provider：

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

定义完provider之后，运行命令 `terraform init` 和 `terraform apply` 来让这个provider生效即可。

更多provider的使用细节，请移步[How to use provider in the module](https://www.terraform.io/docs/language/modules/develop/providers.html#passing-providers-explicitly)

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
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_alicloud"></a> [alicloud](#provider\_alicloud) | n/a |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [alicloud_ess_lifecycle_hook.this](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/resources/ess_lifecycle_hook) | resource |
| [alicloud_ess_scaling_configuration.this](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/resources/ess_scaling_configuration) | resource |
| [alicloud_ess_scaling_group.this](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/resources/ess_scaling_group) | resource |
| [random_uuid.this](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/uuid) | resource |
| [alicloud_account.this](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/data-sources/account) | data source |
| [alicloud_db_instances.this](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/data-sources/db_instances) | data source |
| [alicloud_images.this](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/data-sources/images) | data source |
| [alicloud_instance_types.this](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/data-sources/instance_types) | data source |
| [alicloud_regions.this](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/data-sources/regions) | data source |
| [alicloud_security_groups.this](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/data-sources/security_groups) | data source |
| [alicloud_slbs.this](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/data-sources/slbs) | data source |
| [alicloud_vswitches.this](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/data-sources/vswitches) | data source |
| [alicloud_zones.this](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/data-sources/zones) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_active"></a> [active](#input\_active) | Whether active current scaling configuration in the specified scaling group | `bool` | `true` | no |
| <a name="input_associate_public_ip_address"></a> [associate\_public\_ip\_address](#input\_associate\_public\_ip\_address) | Whether to associate a public ip address with an instance in a VPC. | `bool` | `false` | no |
| <a name="input_cpu_core_count"></a> [cpu\_core\_count](#input\_cpu\_core\_count) | CPU core count used to fetch instance types. | `number` | `2` | no |
| <a name="input_create_lifecycle_hook"></a> [create\_lifecycle\_hook](#input\_create\_lifecycle\_hook) | Whether to create lifecycle hook for this scaling group | `bool` | `false` | no |
| <a name="input_create_scaling_configuration"></a> [create\_scaling\_configuration](#input\_create\_scaling\_configuration) | Whether to create a new scaling configuraion. | `bool` | `true` | no |
| <a name="input_create_scaling_group"></a> [create\_scaling\_group](#input\_create\_scaling\_group) | Whether to create a new scaling group. | `bool` | `true` | no |
| <a name="input_data_disks"></a> [data\_disks](#input\_data\_disks) | Additional data disks to attach to the scaled ECS instance | `list(map(string))` | `[]` | no |
| <a name="input_db_instance_ids"></a> [db\_instance\_ids](#input\_db\_instance\_ids) | A list of rds instance ids to add to the autoscaling group. If not set, it can be retrieved automatically by specifying filter `rds_name_regex` or `rds_tags`. | `list(string)` | `[]` | no |
| <a name="input_default_cooldown"></a> [default\_cooldown](#input\_default\_cooldown) | The amount of time (in seconds),after a scaling activity completes before another scaling activity can start | `number` | `300` | no |
| <a name="input_enable"></a> [enable](#input\_enable) | Whether enable the specified scaling group(make it active) to which the current scaling configuration belongs. | `bool` | `true` | no |
| <a name="input_filter_with_name_regex"></a> [filter\_with\_name\_regex](#input\_filter\_with\_name\_regex) | A default filter applied to retrieve existing vswitches, security groups, load balancers, and rds instances by name regex. | `string` | `""` | no |
| <a name="input_filter_with_tags"></a> [filter\_with\_tags](#input\_filter\_with\_tags) | A default filter applied to retrieve existing vswitches, security groups, load balancers, and rds instances by tags. | `map(string)` | `{}` | no |
| <a name="input_force_delete"></a> [force\_delete](#input\_force\_delete) | The last scaling configuration will be deleted forcibly with deleting its scaling group | `bool` | `false` | no |
| <a name="input_heartbeat_timeout"></a> [heartbeat\_timeout](#input\_heartbeat\_timeout) | Defines the amount of time, in seconds, that can elapse before the lifecycle hook times out. When the lifecycle hook times out, Auto Scaling performs the action defined in the default\_result parameter. | `number` | `600` | no |
| <a name="input_hook_action_policy"></a> [hook\_action\_policy](#input\_hook\_action\_policy) | Defines the action which scaling group should take when the lifecycle hook timeout elapses. Valid value: CONTINUE, ABANDON. | `string` | `"CONTINUE"` | no |
| <a name="input_image_id"></a> [image\_id](#input\_image\_id) | The image id used to launch ecs instances. If not set, a system image with `image_name_regex` will be returned. | `string` | `""` | no |
| <a name="input_image_name_regex"></a> [image\_name\_regex](#input\_image\_name\_regex) | The name regex used to retrieve ECS images. | `string` | `"^ubuntu_18.*64"` | no |
| <a name="input_image_owners"></a> [image\_owners](#input\_image\_owners) | The image owner used to retrieve ECS images. | `string` | `"system"` | no |
| <a name="input_instance_name"></a> [instance\_name](#input\_instance\_name) | Name of an ECS instance. Default to a random string prefixed with `terraform-ess-instance-`. | `string` | `""` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | (Deprecated) It has been deprecated from 1.4.0 and use `instance_types` instead. | `string` | `""` | no |
| <a name="input_instance_types"></a> [instance\_types](#input\_instance\_types) | A list of ECS instance types. If not set, one will be returned automatically by specifying `cpu_core_count` and `memory_size`. If it is set, `instance_type` will be ignored. | `list(string)` | `[]` | no |
| <a name="input_internet_charge_type"></a> [internet\_charge\_type](#input\_internet\_charge\_type) | The ECS instance network billing type: PayByTraffic or PayByBandwidth. | `string` | `"PayByTraffic"` | no |
| <a name="input_internet_max_bandwidth_in"></a> [internet\_max\_bandwidth\_in](#input\_internet\_max\_bandwidth\_in) | Maximum incoming bandwidth from the public network | `number` | `200` | no |
| <a name="input_internet_max_bandwidth_out"></a> [internet\_max\_bandwidth\_out](#input\_internet\_max\_bandwidth\_out) | Maximum outgoing bandwidth from the public network. It will be ignored when `associate_public_ip_address` is false. | `number` | `0` | no |
| <a name="input_key_name"></a> [key\_name](#input\_key\_name) | The name of key pair that login ECS | `string` | `""` | no |
| <a name="input_kms_encrypted_password"></a> [kms\_encrypted\_password](#input\_kms\_encrypted\_password) | An KMS encrypts password used to a db account. If `password_inherit` and `password` is set, this field will be ignored. | `string` | `""` | no |
| <a name="input_kms_encryption_context"></a> [kms\_encryption\_context](#input\_kms\_encryption\_context) | An KMS encryption context used to decrypt `kms_encrypted_password` before creating ECS instance. See Encryption Context: https://www.alibabacloud.com/help/doc-detail/42975.htm. It is valid when kms\_encrypted\_password is set. | `map(string)` | `{}` | no |
| <a name="input_lifecycle_hook_name"></a> [lifecycle\_hook\_name](#input\_lifecycle\_hook\_name) | The name for lifecyle hook. Default to a random string prefixed with `terraform-ess-hook-`. | `string` | `""` | no |
| <a name="input_lifecycle_transition"></a> [lifecycle\_transition](#input\_lifecycle\_transition) | Type of Scaling activity attached to lifecycle hook. Supported value: SCALE\_OUT, SCALE\_IN. | `string` | `"SCALE_IN"` | no |
| <a name="input_loadbalancer_ids"></a> [loadbalancer\_ids](#input\_loadbalancer\_ids) | A list of loadbalancer ids to add to the autoscaling group. If not set, it can be retrieved automatically by specifying filter `slb_name_regex` or `slb_tags`. | `list(string)` | `[]` | no |
| <a name="input_max_size"></a> [max\_size](#input\_max\_size) | Maximum number of ECS instance in the scaling group | `number` | `3` | no |
| <a name="input_memory_size"></a> [memory\_size](#input\_memory\_size) | Memory size used to fetch instance types. | `number` | `4` | no |
| <a name="input_min_size"></a> [min\_size](#input\_min\_size) | Minimum number of ECS instances in the scaling group | `number` | `1` | no |
| <a name="input_mns_queue_name"></a> [mns\_queue\_name](#input\_mns\_queue\_name) | Specify a MNS queue to send notification. It will be ignored when `mns_topic_name` is set. | `string` | `""` | no |
| <a name="input_mns_topic_name"></a> [mns\_topic\_name](#input\_mns\_topic\_name) | Specify a MNS topic to send notification | `string` | `""` | no |
| <a name="input_multi_az_policy"></a> [multi\_az\_policy](#input\_multi\_az\_policy) | Multi-AZ scaling group ECS instance expansion and contraction strategy. PRIORITY, BALANCE or COST\_OPTIMIZED | `string` | `"COST_OPTIMIZED"` | no |
| <a name="input_notification_metadata"></a> [notification\_metadata](#input\_notification\_metadata) | Additional information that you want to include when Auto Scaling sends a message to the notification target. | `string` | `""` | no |
| <a name="input_on_demand_base_capacity"></a> [on\_demand\_base\_capacity](#input\_on\_demand\_base\_capacity) | The minimum amount of the Auto Scaling group's capacity that must be fulfilled by On-Demand Instances. This base portion is provisioned first as your group scales. | `number` | `8` | no |
| <a name="input_on_demand_percentage_above_base_capacity"></a> [on\_demand\_percentage\_above\_base\_capacity](#input\_on\_demand\_percentage\_above\_base\_capacity) | Controls the percentages of On-Demand Instances and Spot Instances for your additional capacity beyond OnDemandBaseCapacity. | `number` | `8` | no |
| <a name="input_password"></a> [password](#input\_password) | The password of the ECS instance. It is valid when `password_inherit` is false | `string` | `""` | no |
| <a name="input_password_inherit"></a> [password\_inherit](#input\_password\_inherit) | Specifies whether to use the password that is predefined in the image. If true, the `password` and `kms_encrypted_password` will be ignored. You must ensure that the selected image has a password configured. | `bool` | `false` | no |
| <a name="input_rds_name_regex"></a> [rds\_name\_regex](#input\_rds\_name\_regex) | A default filter applied to retrieve existing rds instances by name regex. If not set, `filter_with_name_regex` will be used. | `string` | `""` | no |
| <a name="input_rds_tags"></a> [rds\_tags](#input\_rds\_tags) | A default filter applied to retrieve existing rds instances by tags. If not set, `filter_with_tags` will be used. | `map(string)` | `{}` | no |
| <a name="input_removal_policies"></a> [removal\_policies](#input\_removal\_policies) | RemovalPolicy is used to select the ECS instances you want to remove from the scaling group when multiple candidates for removal exist | `list(string)` | <pre>[<br>  "OldestScalingConfiguration",<br>  "OldestInstance"<br>]</pre> | no |
| <a name="input_role_name"></a> [role\_name](#input\_role\_name) | Instance RAM role name | `string` | `""` | no |
| <a name="input_scaling_configuration_name"></a> [scaling\_configuration\_name](#input\_scaling\_configuration\_name) | Name for the autoscaling configuration. Default to a random string prefixed with `terraform-ess-configuration-`. | `string` | `""` | no |
| <a name="input_scaling_group_id"></a> [scaling\_group\_id](#input\_scaling\_group\_id) | Specifying existing autoscaling group ID. If not set, a new one will be created named with `scaling_group_name`. | `string` | `""` | no |
| <a name="input_scaling_group_name"></a> [scaling\_group\_name](#input\_scaling\_group\_name) | The name for autoscaling group. Default to a random string prefixed with `terraform-ess-group-`. | `string` | `""` | no |
| <a name="input_security_group_id"></a> [security\_group\_id](#input\_security\_group\_id) | (Deprecated) It is deprecated from 1.3.0 and used new parameter security\_group\_ids instead. | `string` | `""` | no |
| <a name="input_security_group_ids"></a> [security\_group\_ids](#input\_security\_group\_ids) | List IDs of the security group to which a newly created instance belongs. If not set, it can be retrieved automatically by specifying filter `sg_name_regex` or `sg_tags`. | `list(string)` | `[]` | no |
| <a name="input_sg_name_regex"></a> [sg\_name\_regex](#input\_sg\_name\_regex) | A default filter applied to retrieve existing security groups by name regex. If not set, `filter_with_name_regex` will be used. | `string` | `""` | no |
| <a name="input_sg_tags"></a> [sg\_tags](#input\_sg\_tags) | A default filter applied to retrieve existing security groups by tags. If not set, `filter_with_tags` will be used. | `map(string)` | `{}` | no |
| <a name="input_slb_name_regex"></a> [slb\_name\_regex](#input\_slb\_name\_regex) | A default filter applied to retrieve existing load balancers by name regex. If not set, `filter_with_name_regex` will be used. | `string` | `""` | no |
| <a name="input_slb_tags"></a> [slb\_tags](#input\_slb\_tags) | A default filter applied to retrieve existing load balancers by tags. If not set, `filter_with_tags` will be used. | `map(string)` | `{}` | no |
| <a name="input_spot_instance_pools"></a> [spot\_instance\_pools](#input\_spot\_instance\_pools) | The number of Spot pools to use to allocate your Spot capacity. The Spot pools is composed of instance types of lowest price. | `number` | `10` | no |
| <a name="input_spot_instance_remedy"></a> [spot\_instance\_remedy](#input\_spot\_instance\_remedy) | Whether to replace spot instances with newly created spot/onDemand instance when receive a spot recycling message. | `bool` | `true` | no |
| <a name="input_system_disk_category"></a> [system\_disk\_category](#input\_system\_disk\_category) | Category of the system disk | `string` | `"cloud_efficiency"` | no |
| <a name="input_system_disk_size"></a> [system\_disk\_size](#input\_system\_disk\_size) | Size of the system disk | `number` | `40` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A mapping of tags used to create a new scaling configuration. | `map(string)` | `{}` | no |
| <a name="input_user_data"></a> [user\_data](#input\_user\_data) | User-defined data to customize the startup behaviors of the ECS instance and to pass data into the ECS instance | `string` | `""` | no |
| <a name="input_vswitch_ids"></a> [vswitch\_ids](#input\_vswitch\_ids) | List of virtual switch IDs in which the ecs instances to be launched. If not set, it can be retrieved automatically by specifying filter `vswitch_name_regex` or `vswitch_tags`. | `list(string)` | `[]` | no |
| <a name="input_vswitch_name_regex"></a> [vswitch\_name\_regex](#input\_vswitch\_name\_regex) | A default filter applied to retrieve existing vswitches by name regex. If not set, `filter_with_name_regex` will be used. | `string` | `""` | no |
| <a name="input_vswitch_tags"></a> [vswitch\_tags](#input\_vswitch\_tags) | A default filter applied to retrieve existing vswitches by tags. If not set, `filter_with_tags` will be used. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_this_autoscaling_configuration_id"></a> [this\_autoscaling\_configuration\_id](#output\_this\_autoscaling\_configuration\_id) | The id of the autoscaling configuration |
| <a name="output_this_autoscaling_configuration_name"></a> [this\_autoscaling\_configuration\_name](#output\_this\_autoscaling\_configuration\_name) | The name of the autoscaling configuration |
| <a name="output_this_autoscaling_group_default_cooldown"></a> [this\_autoscaling\_group\_default\_cooldown](#output\_this\_autoscaling\_group\_default\_cooldown) | The default cooldown of the autoscaling group |
| <a name="output_this_autoscaling_group_id"></a> [this\_autoscaling\_group\_id](#output\_this\_autoscaling\_group\_id) | The id of the autoscaling group |
| <a name="output_this_autoscaling_group_load_balancers"></a> [this\_autoscaling\_group\_load\_balancers](#output\_this\_autoscaling\_group\_load\_balancers) | The load balancer ids associated with the autoscaling group |
| <a name="output_this_autoscaling_group_max_size"></a> [this\_autoscaling\_group\_max\_size](#output\_this\_autoscaling\_group\_max\_size) | The maximum size of the autoscaling group |
| <a name="output_this_autoscaling_group_min_size"></a> [this\_autoscaling\_group\_min\_size](#output\_this\_autoscaling\_group\_min\_size) | The minimum size of the autoscaling group |
| <a name="output_this_autoscaling_group_multi_az_policy"></a> [this\_autoscaling\_group\_multi\_az\_policy](#output\_this\_autoscaling\_group\_multi\_az\_policy) | Multi-AZ scaling group ECS instance expansion and contraction strategy |
| <a name="output_this_autoscaling_group_name"></a> [this\_autoscaling\_group\_name](#output\_this\_autoscaling\_group\_name) | The name of the autoscaling group |
| <a name="output_this_autoscaling_group_on_demand_base_capacity"></a> [this\_autoscaling\_group\_on\_demand\_base\_capacity](#output\_this\_autoscaling\_group\_on\_demand\_base\_capacity) | The minimum amount of the Auto Scaling group's capacity that must be fulfilled by On-Demand Instances |
| <a name="output_this_autoscaling_group_on_demand_percentage_above_base_capacity"></a> [this\_autoscaling\_group\_on\_demand\_percentage\_above\_base\_capacity](#output\_this\_autoscaling\_group\_on\_demand\_percentage\_above\_base\_capacity) | Controls the percentages of On-Demand Instances and Spot Instances for your additional capacity beyond OnDemandBaseCapacity |
| <a name="output_this_autoscaling_group_rds_instance_ids"></a> [this\_autoscaling\_group\_rds\_instance\_ids](#output\_this\_autoscaling\_group\_rds\_instance\_ids) | The rds instance ids associated with the autoscaling group |
| <a name="output_this_autoscaling_group_sg_ids"></a> [this\_autoscaling\_group\_sg\_ids](#output\_this\_autoscaling\_group\_sg\_ids) | The security group ids associated with the autoscaling group |
| <a name="output_this_autoscaling_group_slb_ids"></a> [this\_autoscaling\_group\_slb\_ids](#output\_this\_autoscaling\_group\_slb\_ids) | Same with `this_autoscaling_group_load_balancers` |
| <a name="output_this_autoscaling_group_spot_instance_pools"></a> [this\_autoscaling\_group\_spot\_instance\_pools](#output\_this\_autoscaling\_group\_spot\_instance\_pools) | The number of Spot pools to use to allocate your Spot capacity. |
| <a name="output_this_autoscaling_group_spot_instance_remedy"></a> [this\_autoscaling\_group\_spot\_instance\_remedy](#output\_this\_autoscaling\_group\_spot\_instance\_remedy) | Whether to replace spot instances with newly created spot/onDemand instance when receive a spot recycling message. |
| <a name="output_this_autoscaling_group_vswitch_ids"></a> [this\_autoscaling\_group\_vswitch\_ids](#output\_this\_autoscaling\_group\_vswitch\_ids) | The vswitch ids associated with the autoscaling group |
| <a name="output_this_autoscaling_lifecycle_hook_id"></a> [this\_autoscaling\_lifecycle\_hook\_id](#output\_this\_autoscaling\_lifecycle\_hook\_id) | The id of the lifecycle hook |
| <a name="output_this_autoscaling_lifecycle_hook_name"></a> [this\_autoscaling\_lifecycle\_hook\_name](#output\_this\_autoscaling\_lifecycle\_hook\_name) | The name of the lifecycle hook |
| <a name="output_this_autoscaling_lifecycle_hook_notification_arn"></a> [this\_autoscaling\_lifecycle\_hook\_notification\_arn](#output\_this\_autoscaling\_lifecycle\_hook\_notification\_arn) | The notification arn of the lifecycle hook |
<!-- END_TF_DOCS -->

提交问题
-------
如果在使用该 Terraform Module 的过程中有任何问题，可以直接创建一个 [Provider Issue](https://github.com/terraform-providers/terraform-provider-alicloud/issues/new)，我们将根据问题描述提供解决方案。

**注意:** 不建议在该 Module 仓库中直接提交 Issue。

作者
----
Created and maintained by Alibaba Cloud Terraform Team(terraform@alibabacloud.com)

许可
----
Apache 2 Licensed. See LICENSE for full details.

参考
---------
* [Terraform-Provider-Alicloud Github](https://github.com/terraform-providers/terraform-provider-alicloud)
* [Terraform-Provider-Alicloud Release](https://releases.hashicorp.com/terraform-provider-alicloud/)
* [Terraform-Provider-Alicloud Docs](https://www.terraform.io/docs/providers/alicloud/index.html)