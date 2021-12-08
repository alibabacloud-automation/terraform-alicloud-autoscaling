provider "alicloud" {
  region = "cn-beijing"
}

data "alicloud_zones" "default" {
  available_disk_category = "cloud_ssd"
}
data "alicloud_vpcs" "default" {
  is_default = true
}
data "alicloud_vswitches" "default" {
  is_default = true
  vpc_id = "${data.alicloud_vpcs.default.ids.0}"
}

data "alicloud_security_groups" "default" {
  vpc_id = "${data.alicloud_vpcs.default.ids.0}"
}

data "alicloud_images" "ecs_image" {
  most_recent = true
  name_regex  = "^centos_6\\w{1,5}[64].*"
}

data "alicloud_instance_types" "default" {
  availability_zone = data.alicloud_zones.default.zones[0].id
  cpu_core_count    = 1
  memory_size       = 2
}

data "alicloud_db_instances" "default" {
  status     = "Running"
}

// Autoscaling group and Autoscaling configuration
module "example" {
  source = "../../"

  // Autoscaling Group
  scaling_group_name = "testAccEssScalingGroup"
  min_size           = 0
  max_size           = 1

  db_instance_ids = data.alicloud_db_instances.default.ids
  vswitch_ids = data.alicloud_vswitches.default.ids
  loadbalancer_ids = [
    "lb-2zeur05gfsge6123456",
  ]

  // Autoscaling Configuration
  image_id                   = data.alicloud_images.ecs_image.images[0].id
  instance_type              = data.alicloud_instance_types.default.instance_types[0].id
  security_group_id          = data.alicloud_security_groups.default.ids.0
  scaling_configuration_name = "testAccEssScalingConfiguration"
  internet_max_bandwidth_out = "1"
  instance_name              = "testAccEss"

  tags = {
    tag1 = "tag_value1"
    tag2 = "tag_value2"
  }

  force_delete = "true"

  data_disk_size     = 20
  data_disk_category = "cloud_efficiency"
}

