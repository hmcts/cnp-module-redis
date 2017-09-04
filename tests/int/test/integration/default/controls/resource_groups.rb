# encoding: utf-8
# copyright: 2017, The Authors
# license: All rights reserved

title 'Check Azure Resource Group Configuration'

control 'azure-resource-groups' do

  impact 1.0
  title ' Check that the resource group exist'
  json_obj = json('.kitchen/kitchen-terraform/default-azure/terraform.tfstate')
  random_prefix = json_obj['modules'][0]['outputs']['random_name']['value']
  rgName = random_prefix+ '-cache-int'
  redisName = random_prefix+ '-int'

  describe azure_resource_group(name: rgName) do
    its('location') { should eq 'uksouth' }
  end

  describe azure_resource_group(name: rgName).contains(parameter: 'name', value: redisName) do
    it { should be true }
  end

  describe azure_resource_group(name: rgName).contains(parameter: 'type', value: 'Microsoft.Cache/Redis') do
    it { should be true }
  end

  desc "Checking for existence of 'Microsoft.Cache/Redis' module"
  describe azure_resource_group(name: rgName).return_resource(parameter: 'type', value: 'Microsoft.Cache/Redis') do
    it { should_not be nil }
    its('name') { should eq redisName }
    its('properties') {  }
  end

end
