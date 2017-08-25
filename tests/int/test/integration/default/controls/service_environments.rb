title 'Check Service Environments'

control 'azure-service-environment' do

  impact 1.0
  title 'Check that the service has the correct properties'

  # TODO: Because of the limitations for ASEv1 we use an existing ASE
  # to validate our lib
  # Ensure that the expected resources have been deployed
  describe azure_service_environment(rg_name: 'sandbox-core-infra', name: 'sandbox-core-infra') do
    its('location') { should eq 'UK South' }
    its('name') { should eq 'sandbox-core-infra' }
    its('vnet_name') { should eq 'sandbox-core-infra-vnet' }
    its('vnet_resource_group_name') { should eq 'sandbox-core-infra' }
    its('vnet_subnet_name') { should eq 'sandbox-core-infra-subnet-0' }
    its('internal_load_balancing_mode') { should eq 'None' }
    its('maximum_number_of_machines') { should eq 55 }
  end
end

