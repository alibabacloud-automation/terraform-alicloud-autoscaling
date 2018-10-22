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
  // Autoscaling Group
  scaling_group_name = "testAccEssScalingGroup"
  min_size           = 0
  max_size           = 1
  vswitch_ids = [
    "vsw-2ze0rxn9houkr2j00sfu0",
  ]
  db_instance_ids = [
    "rm-2zessj0rl8pjfe9hf",
  ]
  loadbalancer_ids = [
    "lb-2zeur05gfsge6nl3qukkn",
  ]
  // Autoscaling Configuration
  image_id                   = "centos_7_03_64_20G_alibase_20170818.vhd"
  instance_type              = "ecs.n1.small"
  security_group_id          = "sg-2ze0zgaj3hne6aiddmxx"
  scaling_configuration_name = "testAccEssScalingConfiguration"
  internet_max_bandwidth_out = "1"
  instance_name              = "testAccEss"
  tags = {
    tag1 = "tag_value1"
    tag2 = "tag_value2"
  }
  force_delete = "true"
  data_disk = [
    {
      size     = 20
      category = "cloud_efficiency"
    },
  ]
}
```

## Conditional creation

This moudle can create both Auto Scaling group(ASG) and Auto Scaling configuration(ASC), it 
is possible to use external scaling group only if you specify `scaling_group_id` parameter.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| scaling_group_id  | Specifying existing autoscaling group ID  | string  | ''  | no  |
| scaling_group_name  | The name for autoscaling group  | string  | ''  | no  |
| min_size  | Minimum number of ECS instances in the scaling group  | string  | -  | yes  |
| max_size  | Maximum number of ECS instance in the scaling group  | string  | -  | yes  |
| default_cooldown  | The amount of time (in seconds),after a scaling activity completes before another scaling activity can start  | string  | 300  | no  |
| vswitch_ids  | List of virtual switch IDs in which the ecs instances to be launched  | list  | `<list>`  | no  |
| removal_policies  | RemovalPolicy is used to select the ECS instances you want to remove from the scaling group when multiple candidates for removal exist  | list  | ["OldestScalingConfiguration", "OldestInstance"]  | no  |
| db_instance_ids  | A list of rds instance ids to add to the autoscaling group  | list  | `<list>`  |  no |
| loadbalancer_ids  | A list of loadbalancer ids to add to the autoscaling group  | list  | `<list>`  | no  |
| image_id  | The Ecs image ID to launch  | string  | -  | yes  |
| instance_type  | Resource type of an ECS instance  | string  | -  | yes  |
| security_group_id  | ID of the security group to which a newly created instance belongs  | string  | -  | yes  |
| instance_name  | Name of an ECS instance  | string  |  - | yes  |
| scaling_configuration_name  | Name for the autoscaling configuration  | string  | ''  | no |
| internet_charge_type  | Network billing type  | string  | ''  | no  |
| internet_max_bandwidth_in  | Maximum incoming bandwidth from the public network  | string  | 200  | no  |
| internet_max_bandwidth_out  | Maximum outgoing bandwidth from the public network  | string  | 0  | no  |
| system_disk_category  | Category of the system disk  | string  | cloud_efficiency  | no  |
| enable  | Whether enable the specified scaling group(make it active) to which the current scaling configuration belongs  | string  | true  | no  |
| active  | Whether active current scaling configuration in the specified scaling group  | string  | true  | no  |
| user_data  | User-defined data to customize the startup behaviors of the ECS instance and to pass data into the ECS instance  | string  | ''  | no  |
| key_name  | The name of key pair that login ECS  | string  | ''  | no  |
| role_name  | Instance RAM role name  | string  | ''  | no  |
| force_delete  | The last scaling configuration will be deleted forcibly with deleting its scaling group  | string  | false  | no  |
| data_disk  | DataDisk mappings to attach to ecs instance  | list  | `<list>`  |  no |
| tags  | A mapping of tags to assign to the resource  | map  | `<map>`  | no  |


## Outputs

| Name | Description |
|------|-------------|
| this_autoscaling_configuration_id  | The ID of Autoscaling Configuration  |
| this_autoscaling_configuration_name  | The Name of Autoscaling Configuration  |
| this_autoscaling_group_id  | The ID of Autoscaling Group  |
| this_autoscaling_group_name  | The Name of Autoscaling Group  |
| this_autoscaling_group_min_size  | The maximum size of the autoscaling group  |
| this_autoscaling_group_max_size  | The minimum size of the autoscaling group  |
| this_autoscaling_group_default_cooldown  | The amount of time (in seconds),after a scaling activity completes before another scaling activity can start  |

Authors
----
Created and maintained by Tong Kangning(@TalentNing, xiaoxiaoerke@163.com)

License
----
Apache 2 Licensed. See LICENSE for full details.

Reference
---------
* [Terraform-Provider-Alicloud Github](https://github.com/terraform-providers/terraform-provider-alicloud)
* [Terraform-Provider-Alicloud Release](https://releases.hashicorp.com/terraform-provider-alicloud/)
* [Terraform-Provider-Alicloud Docs](https://www.terraform.io/docs/providers/alicloud/index.html)
