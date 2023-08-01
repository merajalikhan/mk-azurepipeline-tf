#main.tf
terraform {
  required_providers {
    azuredevops = {
      source = "microsoft/azuredevops"
      version = ">=0.1.0"
    }
    
  }
}

provider "azuredevops" {
  org_service_url = var.org_service_url
  personal_access_token = var.personal_access_token
}

resource "azuredevops_project" "project-comm" {
  name       = "MK Team Project"
  description        = "Repository used by the Commercial IT Team"
  visibility         = "private"
  version_control    = "Git"
  work_item_template = "Agile"

  features = {
      "boards" = "enabled"
      "repositories" = "enabled"
      "pipelines" = "enabled"
      "artifacts" = "enabled"
  }
}
