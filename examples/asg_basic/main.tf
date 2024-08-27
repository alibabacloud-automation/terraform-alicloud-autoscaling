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

resource "alicloud_db_instance" "default" {
  engine               = "MySQL"
  engine_version       = "5.6"
  vswitch_id           = module.vpc.this_vswitch_ids[0]
  instance_type        = data.alicloud_db_instance_classes.default.instance_classes.1.instance_class
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

module "vpc" {
  source             = "alibaba/vpc/alicloud"
  create             = true
  vpc_cidr           = "172.16.0.0/16"
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

resource "random_integer" "default" {
  min = 10000
  max = 99999
}

module "example" {
  source = "../../"

  #alicloud_ess_scaling_group
  scaling_group_name = "${var.scaling_group_name}-${random_integer.default.result}"
  min_size           = var.min_size
  max_size           = var.max_size
  vswitch_ids        = module.vpc.this_vswitch_ids
  db_instance_ids    = [alicloud_db_instance.default.id]
  loadbalancer_ids   = [alicloud_slb_load_balancer.default.id]

  // Autoscaling Configuration
  image_id                   = data.alicloud_images.default.images.0.id
  instance_type              = data.alicloud_instance_types.default.ids.0
  security_group_id          = module.security_group.this_security_group_id
  scaling_configuration_name = var.scaling_configuration_name
  internet_max_bandwidth_out = var.internet_max_bandwidth_out
  instance_name              = module.ecs_instance.this_instance_name[0]
  force_delete               = "true"
  tags                       = var.tags
}