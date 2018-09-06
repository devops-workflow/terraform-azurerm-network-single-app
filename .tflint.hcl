config {
terraform_version = "0.11.8"
deep_check = true
ignore_module = {
"devops-workflow/label/local" = true
"devops-workflow/network-security-group/azurerm" = true
"devops-workflow/network/azurerm" = true
"github.com/devops-workflow/terraform-azurerm-network" = true
"github.com/devops-workflow/terraform-azurerm-network-security-group" = true
}
}

