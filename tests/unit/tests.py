import terraform_validate
import unittest
import os
import sys


class TestWebAppResources(unittest.TestCase):

    def setUp(self):
        """Tell the module where to find your terraform
        configuration folder
        """
        self.path = os.path.join(os.path.dirname(os.path.realpath(__file__)),
                                 "../../")
        self.v = terraform_validate.Validator(self.path)

    def test_resource_group_properties(self):
        """Assert that resource group has the right properties.
        """
        self.v.resources('azurerm_resource_group').should_have_properties(['name', 'location'])

    def test_resource_group_properties_values(self):
        """Assert that resource group has the right values.
        """
        self.v.error_if_property_missing()
        self.v.enable_variable_expansion()
        self.v.resources('azurerm_resource_group').property('location').should_equal('UK South')

    def test_template_deployment_properties(self):
        """Assert that the template deployment resource has the
        right properties.
        """
        self.v.resources('azurerm_template_deployment').should_have_properties(['name', 'template_body', 'resource_group_name', 'deployment_mode', 'parameters'])

    def test_template_deployment_properties_values(self):
        """Assert that template deployment has the right values.
        """
        self.v.resources('azurerm_template_deployment').property('deployment_mode').should_equal('Incremental')
        self.v.resources('azurerm_template_deployment').property('template_body').should_equal('${data.template_file.sitetemplate.rendered}')
        self.v.resources('azurerm_template_deployment').property('name').should_equal('${var.product}-${var.env}')
        self.v.resources('azurerm_template_deployment').property('resource_group_name').should_equal('${azurerm_resource_group.rg.name}')

if __name__ == '__main__':
    suite = unittest.TestLoader().loadTestsFromTestCase(TestWebAppResources)
    result = unittest.TextTestRunner(verbosity=1).run(suite)
    sys.exit(not result.wasSuccessful())
