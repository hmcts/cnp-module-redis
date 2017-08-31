# encoding: utf-8
# copyright: 2017, The Authors
# license: All rights reserved

title 'Check Redis Cache Virtual Network Configuration'

control 'azure-virtual-network' do

  impact 1.0
  title ' Check that the virtual network exists'
  json_obj = json('.kitchen/kitchen-terraform/default-azure/terraform.tfstate')
  random_name = json_obj['modules'][0]['outputs']['random_name']['value'] + '-vnet-int'

  describe azure_virtual_network(name: random_name) do
    its('cdir') { should eq '10.0.1.0/24' }
    its('sub_network_count') { should eq 1 }
    its('location') { should eq 'uksouth'}
  end
end