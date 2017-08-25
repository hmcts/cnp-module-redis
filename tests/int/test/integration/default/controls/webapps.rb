title 'Check Webapps'

control 'azure-webapp' do

  impact 1.0
  title 'Check that the service has the correct properties'
  json_obj = json('.kitchen/kitchen-terraform/default-azure/terraform.tfstate')
  random_name = json_obj['modules'][0]['outputs']['random_name']['value'] + '-redis-paas-int'

  # Ensure that the expected resources have been deployed
  describe azure_webapp(rg_name: random_name, name: random_name) do
    its('location') { should eq 'UK South' }
    its('default_host_name') { should eq "#{random_name.downcase}.sandbox-core-infra.p.azurewebsites.net" }
    its('enabled_host_names') { should include "#{random_name.downcase}.scm.sandbox-core-infra.p.azurewebsites.net" }
  end
end
