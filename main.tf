// Profile configure
provider "alicloud" {
  version                 = ">=1.56.0"
  profile                 = var.profile != "" ? var.profile : null
  shared_credentials_file = var.shared_credentials_file != "" ? var.shared_credentials_file : null
  region                  = var.region != "" ? var.region : null
  skip_region_validation  = var.skip_region_validation
  configuration_source    = "terraform-alicloud-modules/autoscaling"
}

resource "alicloud_ess_scaling_group" "this" {
  count              = var.scaling_group_id == "" ? 1 : 0
  scaling_group_name = var.scaling_group_name
  max_size           = var.max_size
  min_size           = var.min_size
  default_cooldown   = var.default_cooldown
  vswitch_ids        = var.vswitch_ids
  removal_policies   = var.removal_policies
  db_instance_ids    = var.db_instance_ids
  loadbalancer_ids   = var.loadbalancer_ids
}

// Autoscaling configuration
resource "alicloud_ess_scaling_configuration" "this" {
  scaling_group_id           = var.scaling_group_id == "" ? join("", alicloud_ess_scaling_group.this.*.id) : var.scaling_group_id
  image_id                   = var.image_id
  instance_type              = var.instance_type
  security_group_id          = var.security_group_id
  instance_name              = var.instance_name
  scaling_configuration_name = var.scaling_configuration_name
  internet_charge_type       = var.internet_charge_type
  internet_max_bandwidth_in  = var.internet_max_bandwidth_in
  internet_max_bandwidth_out = var.internet_max_bandwidth_out
  system_disk_category       = var.system_disk_category
  enable                     = var.enable
  active                     = var.active
  user_data                  = var.user_data
  key_name                   = var.key_name
  role_name                  = var.role_name
  force_delete               = var.force_delete
  data_disk {
    size     = var.data_disk_size
    category = var.data_disk_category
  }
  tags = var.tags
}

