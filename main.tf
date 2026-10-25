terraform {
  required_version = ">= 1.5.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.100.0"
    }
  }
}

provider "azurerm" {
  features {}
}

data "azurerm_subscription" "current" {}

# Policy: Enforce Allowed Locations
resource "azurerm_subscription_policy_assignment" "allowed_locations" {
  name                 = "enforce-allowed-locations"
  subscription_id      = data.azurerm_subscription.current.id
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/e56962a6-4747-49cd-b67b-bf7b01975c4c"
  description          = "Restricts resource provisioning strictly to Central India, South India, and East US."
  display_name         = "Audit & Enforce Allowed Azure Locations"

  parameters = jsonencode({
    listOfAllowedLocations = {
      value = ["centralindia", "southindia", "eastus"]
    }
  })
}

# Policy: Require Environment Tag
resource "azurerm_subscription_policy_assignment" "require_env_tag" {
  name                 = "require-environment-tag"
  subscription_id      = data.azurerm_subscription.current.id
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/87488d3d-429d-435b-9d61-e63b9603f887"
  description          = "Enforces mandatory Environment tag across all resource groups."
  display_name         = "Enforce Mandatory Environment Tag"

  parameters = jsonencode({
    tagName = {
      value = "Environment"
    }
  })
}
