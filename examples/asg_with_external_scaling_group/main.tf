provider "alicloud" {
  region = "cn-beijing"
}

data "alicloud_zones" "default" {
  available_disk_category = "cloud_ssd"
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

// Autoscaling group and Autoscaling configuration
module "example" {
  source = "../../"

  // Autoscaling Group
  scaling_group_id = "asg-2zebb8p123456"
  min_size         = 0
  max_size         = 1

  // Autoscaling Configuration
  image_id                   = data.alicloud_images.ecs_image.images[0].id
  instance_type              = data.alicloud_instance_types.default.instance_types[0].id
  security_group_id          = "sg-2ze6wjtl1123456"
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

