data "alicloud_db_zones" "default" {
  engine         = "MySQL"
  engine_version = "5.6"
}

data "alicloud_db_instance_classes" "default" {
  engine         = "MySQL"
  engine_version = "5.6"
}

data "alicloud_images" "default" {
  most_recent = true
  owners      = "system"
  name_regex  = "^ubuntu_18.*64"
}

data "alicloud_instance_types" "default" {
  cpu_core_count    = 2
  memory_size       = 4
  availability_zone = data.alicloud_db_zones.default.zones.0.id
}

resource "alicloud_ecs_key_pair" "default" {
  key_pair_name = "key_pair_name_20220216"
}

resource "alicloud_ram_role" "default" {
  name     = "tf-ram-name-20220216"
  document = var.document
}

resource "alicloud_kms_key" "kms" {
  key_usage              = "ENCRYPT/DECRYPT"
  pending_window_in_days = var.pending_window_in_days
  status                 = "Enabled"
}

resource "alicloud_kms_ciphertext" "kms" {
  plaintext = "test"
  key_id    = alicloud_kms_key.kms.id
  encryption_context = {
    test = "test"
  }
}

resource "alicloud_ecs_disk" "default" {
  zone_id = data.alicloud_db_zones.default.zones.0.id
  size    = var.system_disk_size
}

resource "alicloud_ecs_snapshot" "default" {
  disk_id  = alicloud_ecs_disk_attachment.default.disk_id
  category = "standard"
  force    = var.force_delete
}

resource "alicloud_ecs_disk_attachment" "default" {
  disk_id     = alicloud_ecs_disk.default.id
  instance_id = module.ecs_instance.this_instance_id[0]
}

resource "alicloud_db_instance" "default" {
  engine               = "MySQL"
  engine_version       = "5.6"
  vswitch_id           = module.vpc.this_vswitch_ids[0]
  instance_type        = data.alicloud_db_instance_classes.default.instance_classes.0.instance_class
  instance_storage     = var.instance_storage
  instance_charge_type = var.instance_charge_type
  monitoring_period    = var.monitoring_period
}

resource "alicloud_slb_load_balancer" "default" {
  load_balancer_name = var.scaling_group_name
  address_type       = "intranet"
  load_balancer_spec = var.load_balancer_spec
  vswitch_id         = module.vpc.this_vswitch_ids[0]
}

resource "alicloud_slb_listener" "default" {
  load_balancer_id = alicloud_slb_load_balancer.default.id
  backend_port     = 22
  frontend_port    = 22
  protocol         = "http"
  bandwidth        = var.bandwidth
}

resource "alicloud_slb_server_group" "default" {
  load_balancer_id = alicloud_slb_load_balancer.default.id
}

resource "alicloud_slb_rule" "default" {
  load_balancer_id = alicloud_slb_load_balancer.default.id
  frontend_port    = alicloud_slb_listener.default.frontend_port
  domain           = "*.aliyun.com"
  url              = "/image"
  server_group_id  = alicloud_slb_server_group.default.id
  health_check     = "on"
}

resource "alicloud_mns_topic" "default" {
  name = "tf-topic-name-20220216"
}

resource "alicloud_mns_queue" "default" {
  name = "tf-queue-name-20220216"
}

module "vpc" {
  source             = "alibaba/vpc/alicloud"
  create             = true
  vpc_name           = var.scaling_group_name
  vpc_cidr           = "172.16.0.0/16"
  vswitch_name       = var.scaling_group_name
  vswitch_cidrs      = ["172.16.0.0/21"]
  availability_zones = [data.alicloud_db_zones.default.zones.0.id]
}

module "security_group" {
  source = "alibaba/security-group/alicloud"
  vpc_id = module.vpc.this_vpc_id
}

module "ecs_instance" {
  source = "alibaba/ecs-instance/alicloud"

  number_of_instances = 1

  instance_type      = data.alicloud_instance_types.default.instance_types.0.id
  image_id           = data.alicloud_images.default.images.0.id
  vswitch_ids        = module.vpc.this_vswitch_ids
  security_group_ids = [module.security_group.this_security_group_id]
}

module "scaling_group" {
  source = "../.."

  #alicloud_ess_scaling_group
  create_scaling_group = true

  scaling_group_name = var.scaling_group_name
  min_size           = var.min_size
  max_size           = var.max_size
  default_cooldown   = var.default_cooldown
  vswitch_ids        = module.vpc.this_vswitch_ids
  vswitch_name_regex = module.vpc.this_vswitch_names[0]
  vswitch_tags       = module.vpc.this_vswitch_tags[0]
  removal_policies   = var.removal_policies
  db_instance_ids    = [alicloud_db_instance.default.id]
  rds_name_regex     = "tf"
  rds_tags = {
    Created = "tf"
  }
  loadbalancer_ids = [alicloud_slb_load_balancer.default.id]
  slb_name_regex   = "tf"
  slb_tags = {
    Created = "tf"
  }
  multi_az_policy                          = "COST_OPTIMIZED"
  on_demand_base_capacity                  = var.on_demand_base_capacity
  on_demand_percentage_above_base_capacity = var.on_demand_percentage_above_base_capacity
  spot_instance_pools                      = var.spot_instance_pools
  spot_instance_remedy                     = var.spot_instance_remedy
  filter_with_name_regex                   = "tf"
  filter_with_tags = {
    Created = "tf"
  }

  #alicloud_ess_scaling_configuration
  create_scaling_configuration = false

  #alicloud_ess_lifecycle_hook
  create_lifecycle_hook = false

}

module "scaling_configuration" {
  source = "../.."

  #alicloud_ess_scaling_group
  create_scaling_group = false

  #alicloud_ess_scaling_configuration
  create_scaling_configuration = true
  scaling_group_id             = module.scaling_group.this_autoscaling_group_id

  image_id           = data.alicloud_images.default.images.0.id
  image_owners       = "system"
  image_name_regex   = "^ubuntu_18.*64"
  instance_types     = [data.alicloud_instance_types.default.ids.0]
  cpu_core_count     = 2
  memory_size        = 4
  security_group_ids = [module.security_group.this_security_group_id]
  sg_name_regex      = "tf"
  sg_tags = {
    Created = "tf"
  }
  instance_name               = module.ecs_instance.this_instance_name[0]
  scaling_configuration_name  = var.scaling_configuration_name
  internet_charge_type        = var.internet_charge_type
  internet_max_bandwidth_in   = var.internet_max_bandwidth_in
  associate_public_ip_address = true
  internet_max_bandwidth_out  = var.internet_max_bandwidth_out
  system_disk_category        = var.system_disk_category
  system_disk_size            = var.system_disk_size
  enable                      = var.enable
  active                      = var.active
  user_data                   = var.user_data
  key_name                    = alicloud_ecs_key_pair.default.id
  role_name                   = alicloud_ram_role.default.id
  force_delete                = var.force_delete
  password_inherit            = var.password_inherit
  password                    = "YourPassword123!"
  kms_encrypted_password      = "YourPassword123!"
  kms_encryption_context      = alicloud_kms_ciphertext.kms.encryption_context
  tags                        = var.tags
  data_disks = [{
    delete_with_instance = true
    snapshot_id          = alicloud_ecs_snapshot.default.id
    size                 = 30
    category             = "cloud_efficiency"
  }]

  #alicloud_ess_lifecycle_hook
  create_lifecycle_hook = false

}

module "lifecycle_hook" {
  source = "../.."

  #alicloud_ess_scaling_group
  create_scaling_group = false

  #alicloud_ess_scaling_configuration
  create_scaling_configuration = false

  #alicloud_ess_lifecycle_hook
  create_lifecycle_hook = true

  scaling_group_id      = module.scaling_group.this_autoscaling_group_id
  lifecycle_hook_name   = "tf-lifecycle-hook-name"
  lifecycle_transition  = var.lifecycle_transition
  heartbeat_timeout     = var.heartbeat_timeout
  hook_action_policy    = var.hook_action_policy
  mns_topic_name        = alicloud_mns_topic.default.name
  mns_queue_name        = alicloud_mns_queue.default.name
  notification_metadata = var.notification_metadata

}