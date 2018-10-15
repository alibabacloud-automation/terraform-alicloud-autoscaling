# Autoscaling with external scalinggroup example

Configuration in this directory uses exists Autoscaling group and creates Autoscaling configuration for it.

## Usage
To run this example you need first replace the configuration like image_id, security_group_id , etc, with your own resource and execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example may create resources which cost money. Run `terraform destroy` when you don't need these resources.

## Outputs

| Name | Description |
|------|-------------|
| this_scaling_group_id | The autoscaling group id |
| this_scaling_configuration_id | The ID of the launch configuration |
