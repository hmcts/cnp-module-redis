# encoding: utf-8
# copyright: 2017, The Authors
# license: All rights reserved

title 'Check Azure Resource Group Configuration'

control 'azure-resource-groups' do

  impact 1.0
  title ' Check that the resource group exist'
  json_obj = json('.kitchen/kitchen-terraform/default-azure/terraform.tfstate')
  random_name = json_obj['modules'][0]['outputs']['random_name']['value'] + '-cache-int'

  #require 'pry'; binding.pry;
  describe azure_resource_group(name: random_name) do
    its('location') { should eq 'uksouth' }
  end
end
