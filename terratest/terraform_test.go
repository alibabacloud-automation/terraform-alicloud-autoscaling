package test

import (
	"fmt"
	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/stretchr/testify/assert"
	"os"
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
)

// An example of how to test the simple Terraform module in examples/terraform-basic-example using Terratest.
func TestTerraformBasicExample(t *testing.T) {
	t.Parallel()
	uniqueId := random.UniqueId()
	uniqueName := fmt.Sprintf("tf-testAcc%s", uniqueId)
	scalingGroupName := uniqueName
	minSize := "0"
	maxSize := "1"
	defaultCooldown := "300"
	vswitchIds := []string{""}
	removalPolicies := []string{"OldestInstance", "OldestScalingConfiguration"}
	dbInstanceIds := []string{os.Getenv("DB_INSTANCE_ID")}
	imageId := "centos_6_10_64_20G_alibase_20190709.vhd"
	instanceType := "ecs.n4.small"
	securityGroupId := os.Getenv("SECURITY_GROUP_ID")
	instanceName := uniqueName
	scalingConfigurationName := uniqueName
	internetChargeType := "PayByTraffic"
	internetMaxBandwidthIn := "200"
	internetMaxBandwidthOut := "0"
	systemDiskCategory := "cloud_efficiency"
	enable := "true"
	active := "true"
	userData := ""
	keyName := ""
	roleName := ""
	forceDelete := "true"
	dataDiskSize := "20"
	dataDiskCategory := "cloud_efficiency"
	tags := map[string]string{
		"Tag1": "Tag_Value1",
		"tag2": "tag_value2",
	}
	if os.Getenv("DB_INSTANCE_ID") == "" || os.Getenv("SECURITY_GROUP_ID") == "" {
		t.Skip(fmt.Sprintf(
			"Acceptance tests skipped unless env '%s' and '%s' set",
			"DB_INSTANCE_ID", "SECURITY_GROUP_ID"))
		return
	}
	terraformOptions := &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: "../",

		// Variables to pass to our Terraform code using -var options
		Vars: map[string]interface{}{
			"scaling_group_name":         scalingGroupName,
			"min_size":                   minSize,
			"max_size":                   maxSize,
			"default_cooldown":           defaultCooldown,
			"vswitch_ids":                vswitchIds,
			"removal_policies":           removalPolicies,
			"db_instance_ids":            dbInstanceIds,
			"image_id":                   imageId,
			"instance_type":              instanceType,
			"security_group_id":          securityGroupId,
			"instance_name":              instanceName,
			"scaling_configuration_name": scalingConfigurationName,
			"internet_charge_type":       internetChargeType,
			"internet_max_bandwidth_in":  internetMaxBandwidthIn,
			"internet_max_bandwidth_out": internetMaxBandwidthOut,
			"system_disk_category":       systemDiskCategory,
			"enable":                     enable,
			"active":                     active,
			"user_data":                  userData,
			"key_name":                   keyName,
			"role_name":                  roleName,
			"force_delete":               forceDelete,
			"data_disk_size":             dataDiskSize,
			"data_disk_category":         dataDiskCategory,
			"tags":                       tags,
			// We also can see how lists and maps translate between terratest and terraform.
		},

		// Disable colors in Terraform commands so its easier to parse stdout/stderr
		NoColor: true,
	}
	// At the end of the test, run `terraform destroy` to clean up any resources that were created

	defer terraform.Destroy(t, terraformOptions)

	// This will run `terraform init` and `terraform apply` and fail the test if there are any errors
	terraform.InitAndApply(t, terraformOptions)

	// Run `terraform output` to get the values of output variables
	actualScalingGroupName := terraform.Output(t, terraformOptions, "this_autoscaling_group_name")
	actualMinSize := terraform.Output(t, terraformOptions, "this_autoscaling_group_min_size")
	actualMaxSize := terraform.Output(t, terraformOptions, "this_autoscaling_group_max_size")
	actualDefaultCooldown := terraform.Output(t, terraformOptions, "this_autoscaling_group_default_cooldown")
	actualVswitchIds := terraform.OutputList(t, terraformOptions, "this_vswitch_ids")
	actualRemovalPolicies := terraform.OutputList(t, terraformOptions, "this_removal_policies")
	actualDbInstanceIds := terraform.OutputList(t, terraformOptions, "this_db_instance_ids")
	actualImageId := terraform.Output(t, terraformOptions, "this_image_id")
	actualInstanceType := terraform.Output(t, terraformOptions, "this_instance_type")
	actualSecurityGroupId := terraform.Output(t, terraformOptions, "this_security_group_id")
	actualInstanceName := terraform.Output(t, terraformOptions, "this_instance_name")
	actualScalingConfigurationName := terraform.Output(t, terraformOptions, "this_scaling_configuration_name")
	actualInternetChargeType := terraform.Output(t, terraformOptions, "this_internet_charge_type")
	actualInternetMaxBandwidthIn := terraform.Output(t, terraformOptions, "this_internet_max_bandwidth_in")
	actualInternetMaxBandwidthOut := terraform.Output(t, terraformOptions, "this_internet_max_bandwidth_out")
	actualSystemDiskCategory := terraform.Output(t, terraformOptions, "this_system_disk_category")
	actualEnable := terraform.Output(t, terraformOptions, "this_enable")
	actualActive := terraform.Output(t, terraformOptions, "this_active")
	actualUserData := terraform.Output(t, terraformOptions, "this_user_data")
	actualKeyName := terraform.Output(t, terraformOptions, "this_key_name")
	actualRoleName := terraform.Output(t, terraformOptions, "this_role_name")
	actualForceDelete := terraform.Output(t, terraformOptions, "this_force_delete")
	actualDataDiskSize := terraform.Output(t, terraformOptions, "this_data_disk_size")
	actualDataDiskCategory := terraform.Output(t, terraformOptions, "this_data_disk_category")
	actualTags := terraform.OutputMap(t, terraformOptions, "this_tags")

	// Verify we're getting back the outputs we expect
	assert.Equal(t, scalingGroupName, actualScalingGroupName)
	assert.Equal(t, minSize, actualMinSize)
	assert.Equal(t, maxSize, actualMaxSize)
	assert.Equal(t, defaultCooldown, actualDefaultCooldown)
	assert.Equal(t, vswitchIds, actualVswitchIds)
	assert.Equal(t, removalPolicies, actualRemovalPolicies)
	assert.Equal(t, dbInstanceIds, actualDbInstanceIds)
	assert.Equal(t, imageId, actualImageId)
	assert.Equal(t, instanceType, actualInstanceType)
	assert.Equal(t, securityGroupId, actualSecurityGroupId)
	assert.Equal(t, instanceName, actualInstanceName)
	assert.Equal(t, scalingConfigurationName, actualScalingConfigurationName)
	assert.Equal(t, internetChargeType, actualInternetChargeType)
	assert.Equal(t, internetMaxBandwidthIn, actualInternetMaxBandwidthIn)
	assert.Equal(t, internetMaxBandwidthOut, actualInternetMaxBandwidthOut)
	assert.Equal(t, systemDiskCategory, actualSystemDiskCategory)
	assert.Equal(t, enable, actualEnable)
	assert.Equal(t, active, actualActive)
	assert.Equal(t, userData, actualUserData)
	assert.Equal(t, keyName, actualKeyName)
	assert.Equal(t, roleName, actualRoleName)
	assert.Equal(t, forceDelete, actualForceDelete)
	assert.Equal(t, dataDiskSize, actualDataDiskSize)
	assert.Equal(t, dataDiskCategory, actualDataDiskCategory)
	assert.Equal(t, tags, actualTags)
}
