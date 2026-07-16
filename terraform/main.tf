terraform {
  required_version = ">= 1.5.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }

  # Recommended for production: store state remotely with locking, e.g.
  # backend "azurerm" {
  #   resource_group_name  = "tfstate-rg"
  #   storage_account_name = "mytfstateaccount"
  #   container_name        = "tfstate"
  #   key                   = "diagram-agent.tfstate"
  # }
}

provider "azurerm" {
  features {}
  skip_provider_registration = true
}

resource "random_string" "archly_suffix" {
  length  = 6
  upper   = false
  special = false
}

data "azurerm_resource_group" "archly" {
  name = var.resource_group_name
}

locals {
  resource_group_name = data.azurerm_resource_group.archly.name
  location            = data.azurerm_resource_group.archly.location
  name_suffix         = random_string.archly_suffix.result
}

# >>> archly:group:vnet1 >>>
# Workload VNet (network boundary)

resource "azurerm_virtual_network" "vnet1" {
  name                = "vnet1"
  resource_group_name = local.resource_group_name
  location            = local.location
  address_space       = [var.vnet1_address_space]
}
# <<< archly:group:vnet1 <<<

# >>> archly:group:data_services >>>
# Managed Data Services (network boundary)

resource "azurerm_virtual_network" "data_services" {
  name                = "data_services"
  resource_group_name = local.resource_group_name
  location            = local.location
  address_space       = [var.data_services_address_space]
}
# <<< archly:group:data_services <<<

# >>> archly:group:security_ops >>>
# Security & Operations (network boundary)

resource "azurerm_virtual_network" "security_ops" {
  name                = "security_ops"
  resource_group_name = local.resource_group_name
  location            = local.location
  address_space       = [var.security_ops_address_space]
}
# <<< archly:group:security_ops <<<

# >>> archly:group:platform_controls >>>
# Platform Controls (network boundary)

resource "azurerm_virtual_network" "platform_controls" {
  name                = "platform_controls"
  resource_group_name = local.resource_group_name
  location            = local.location
  address_space       = [var.platform_controls_address_space]
}
# <<< archly:group:platform_controls <<<

# >>> archly:group:appgw_subnet >>>
# App Gateway Subnet (subnet within 'Workload VNet')

resource "azurerm_subnet" "appgw_subnet" {
  name                 = "appgw_subnet"
  resource_group_name  = local.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet1.name
  address_prefixes     = [var.appgw_subnet_address_prefix]
}
# <<< archly:group:appgw_subnet <<<

# >>> archly:group:apps_subnet >>>
# Container Apps Subnet (subnet within 'Workload VNet')

resource "azurerm_subnet" "apps_subnet" {
  name                 = "apps_subnet"
  resource_group_name  = local.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet1.name
  address_prefixes     = [var.apps_subnet_address_prefix]
}
# <<< archly:group:apps_subnet <<<

# >>> archly:group:pe_subnet >>>
# Private Endpoint Subnet (subnet within 'Workload VNet')

resource "azurerm_subnet" "pe_subnet" {
  name                 = "pe_subnet"
  resource_group_name  = local.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet1.name
  address_prefixes     = [var.pe_subnet_address_prefix]
}
# <<< archly:group:pe_subnet <<<

# >>> archly:node:afd1 >>>
# Azure Front Door (cdn)
resource "azurerm_cdn_frontdoor_profile" "afd1_profile" {
  name                = "afd1-profile-${local.name_suffix}"
  resource_group_name = local.resource_group_name
  sku_name            = "Standard_AzureFrontDoor"
}

resource "azurerm_cdn_frontdoor_endpoint" "afd1" {
  name                     = "afd1-${local.name_suffix}"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.afd1_profile.id
}
# <<< archly:node:afd1 <<<

# >>> archly:node:appgw1 >>>
# App Gateway WAF (network.application_gateway) -- belongs to subnet 'App Gateway Subnet' (see resource id 'appgw_subnet' above; wire this resource's subnet/network args to it manually)
# Fallback scaffold: provider-specific mapping is not curated yet. Review and complete required arguments before applying.
resource "azurerm_application_gateway" "appgw1" {
  name = var.appgw1_name
  resource_group_name = local.resource_group_name
  location            = local.location

  # TODO: Review the Terraform provider docs for azurerm_application_gateway
  # and add every required argument before applying.
}
# <<< archly:node:appgw1 <<<

# >>> archly:node:apps1 >>>
# Container Apps (compute.container) -- belongs to subnet 'Container Apps Subnet' (see resource id 'apps_subnet' above; wire this resource's subnet/network args to it manually)
resource "azurerm_log_analytics_workspace" "apps1_logs" {
  name                = "apps1-logs"
  location            = local.location
  resource_group_name = local.resource_group_name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_container_app_environment" "apps1_env" {
  name                       = "apps1-env"
  location                   = local.location
  resource_group_name        = local.resource_group_name
  log_analytics_workspace_id = azurerm_log_analytics_workspace.apps1_logs.id
}

resource "azurerm_container_app" "apps1" {
  name                         = "apps1"
  resource_group_name          = local.resource_group_name
  container_app_environment_id = azurerm_container_app_environment.apps1_env.id
  revision_mode                = "Single"
  template {
    container {
      name   = "apps1"
      image  = var.apps1_container_image
      cpu    = 0.5
      memory = "1Gi"
    }
  }
}
# <<< archly:node:apps1 <<<

# >>> archly:node:mi1 >>>
# Managed Identity (identity.managed) -- belongs to network 'Security & Operations' (see resource id 'security_ops' above; wire this resource's subnet/network args to it manually)
# Fallback scaffold: provider-specific mapping is not curated yet. Review and complete required arguments before applying.
resource "azurerm_managed" "mi1" {
  name = var.mi1_name
  resource_group_name = local.resource_group_name
  location            = local.location

  # TODO: Review the Terraform provider docs for azurerm_managed
  # and add every required argument before applying.
}
# <<< archly:node:mi1 <<<

# >>> archly:node:sqlpe1 >>>
# SQL Private Endpoint (network.private_endpoint) -- belongs to subnet 'Private Endpoint Subnet' (see resource id 'pe_subnet' above; wire this resource's subnet/network args to it manually)
# Fallback scaffold: provider-specific mapping is not curated yet. Review and complete required arguments before applying.
resource "azurerm_private_endpoint" "sqlpe1" {
  name = var.sqlpe1_name
  resource_group_name = local.resource_group_name
  location            = local.location

  # TODO: Review the Terraform provider docs for azurerm_private_endpoint
  # and add every required argument before applying.
}
# <<< archly:node:sqlpe1 <<<

# >>> archly:node:redispe1 >>>
# Redis Private Endpoint (network.private_endpoint) -- belongs to subnet 'Private Endpoint Subnet' (see resource id 'pe_subnet' above; wire this resource's subnet/network args to it manually)
# Fallback scaffold: provider-specific mapping is not curated yet. Review and complete required arguments before applying.
resource "azurerm_private_endpoint" "redispe1" {
  name = var.redispe1_name
  resource_group_name = local.resource_group_name
  location            = local.location

  # TODO: Review the Terraform provider docs for azurerm_private_endpoint
  # and add every required argument before applying.
}
# <<< archly:node:redispe1 <<<

# >>> archly:node:sbpe1 >>>
# Service Bus Endpoint (network.private_endpoint) -- belongs to subnet 'Private Endpoint Subnet' (see resource id 'pe_subnet' above; wire this resource's subnet/network args to it manually)
# Fallback scaffold: provider-specific mapping is not curated yet. Review and complete required arguments before applying.
resource "azurerm_private_endpoint" "sbpe1" {
  name = var.sbpe1_name
  resource_group_name = local.resource_group_name
  location            = local.location

  # TODO: Review the Terraform provider docs for azurerm_private_endpoint
  # and add every required argument before applying.
}
# <<< archly:node:sbpe1 <<<

# >>> archly:node:blobpe1 >>>
# Blob Private Endpoint (network.private_endpoint) -- belongs to subnet 'Private Endpoint Subnet' (see resource id 'pe_subnet' above; wire this resource's subnet/network args to it manually)
# Fallback scaffold: provider-specific mapping is not curated yet. Review and complete required arguments before applying.
resource "azurerm_private_endpoint" "blobpe1" {
  name = var.blobpe1_name
  resource_group_name = local.resource_group_name
  location            = local.location

  # TODO: Review the Terraform provider docs for azurerm_private_endpoint
  # and add every required argument before applying.
}
# <<< archly:node:blobpe1 <<<

# >>> archly:node:kvpe1 >>>
# Key Vault Endpoint (network.private_endpoint)
# Fallback scaffold: provider-specific mapping is not curated yet. Review and complete required arguments before applying.
resource "azurerm_private_endpoint" "kvpe1" {
  name = var.kvpe1_name
  resource_group_name = local.resource_group_name
  location            = local.location

  # TODO: Review the Terraform provider docs for azurerm_private_endpoint
  # and add every required argument before applying.
}
# <<< archly:node:kvpe1 <<<

# >>> archly:node:sql1 >>>
# Azure SQL Primary (database.relational) -- belongs to network 'Managed Data Services' (see resource id 'data_services' above; wire this resource's subnet/network args to it manually)
resource "azurerm_postgresql_flexible_server" "sql1" {
  name                   = "sql1-${local.name_suffix}"
  resource_group_name    = local.resource_group_name
  location               = local.location
  administrator_login    = var.sql1_administrator_login
  administrator_password = var.sql1_administrator_password
  sku_name               = "B_Standard_B1ms"
  storage_mb             = 32768
  version                = "15"
}
# <<< archly:node:sql1 <<<

# >>> archly:node:sql2 >>>
# Azure SQL Failover (database.relational) -- belongs to network 'Managed Data Services' (see resource id 'data_services' above; wire this resource's subnet/network args to it manually)
resource "azurerm_postgresql_flexible_server" "sql2" {
  name                   = "sql2-${local.name_suffix}"
  resource_group_name    = local.resource_group_name
  location               = local.location
  administrator_login    = var.sql2_administrator_login
  administrator_password = var.sql2_administrator_password
  sku_name               = "B_Standard_B1ms"
  storage_mb             = 32768
  version                = "15"
}
# <<< archly:node:sql2 <<<

# >>> archly:node:redis1 >>>
# Azure Cache Redis (database.cache) -- belongs to network 'Managed Data Services' (see resource id 'data_services' above; wire this resource's subnet/network args to it manually)
resource "azurerm_redis_cache" "redis1" {
  name                = "redis1-${local.name_suffix}"
  resource_group_name = local.resource_group_name
  location            = local.location
  capacity            = 1
  family              = "C"
  sku_name            = "Standard"
  # Access keys are generated by Azure and available as sensitive outputs
  # (azurerm_redis_cache.redis1.primary_access_key) -- never set them as input.
}
# <<< archly:node:redis1 <<<

# >>> archly:node:sb1 >>>
# Service Bus (queue) -- belongs to network 'Managed Data Services' (see resource id 'data_services' above; wire this resource's subnet/network args to it manually)
resource "azurerm_servicebus_namespace" "sb1_ns" {
  name                = "sb1-ns-${local.name_suffix}"
  location            = local.location
  resource_group_name = local.resource_group_name
  sku                 = "Standard"
}

resource "azurerm_servicebus_queue" "sb1" {
  name         = "sb1"
  namespace_id = azurerm_servicebus_namespace.sb1_ns.id
}
# <<< archly:node:sb1 <<<

# >>> archly:node:blob1 >>>
# Blob Storage (storage.object) -- belongs to network 'Managed Data Services' (see resource id 'data_services' above; wire this resource's subnet/network args to it manually)
resource "azurerm_storage_account" "blob1" {
  name                     = substr("stblob1${local.name_suffix}", 0, 24)
  resource_group_name      = local.resource_group_name
  location                 = local.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  min_tls_version          = "TLS1_2"
}
# <<< archly:node:blob1 <<<

# >>> archly:node:kv1 >>>
# Key Vault (secrets)
resource "azurerm_key_vault" "kv1" {
  name                       = "kv1-${local.name_suffix}"
  resource_group_name        = local.resource_group_name
  location                   = local.location
  tenant_id                  = var.tenant_id
  sku_name                   = "standard"
  purge_protection_enabled   = true
  soft_delete_retention_days = 90
}
# <<< archly:node:kv1 <<<

# >>> archly:node:dns1 >>>
# Private DNS Zones (dns.private) -- belongs to network 'Security & Operations' (see resource id 'security_ops' above; wire this resource's subnet/network args to it manually)
# Fallback scaffold: provider-specific mapping is not curated yet. Review and complete required arguments before applying.
resource "azurerm_private" "dns1" {
  name = var.dns1_name
  resource_group_name = local.resource_group_name
  location            = local.location

  # TODO: Review the Terraform provider docs for azurerm_private
  # and add every required argument before applying.
}
# <<< archly:node:dns1 <<<

# >>> archly:node:mon1 >>>
# Azure Monitor (monitoring)
resource "azurerm_log_analytics_workspace" "mon1" {
  name                = "mon1"
  resource_group_name = local.resource_group_name
  location            = local.location
  sku                 = "PerGB2018"
  retention_in_days   = 30
}
# <<< archly:node:mon1 <<<

# >>> archly:node:logs1 >>>
# Log Analytics (logging)
# Fallback scaffold: provider-specific mapping is not curated yet. Review and complete required arguments before applying.
resource "azurerm_logging" "logs1" {
  name = var.logs1_name
  resource_group_name = local.resource_group_name
  location            = local.location

  # TODO: Review the Terraform provider docs for azurerm_logging
  # and add every required argument before applying.
}
# <<< archly:node:logs1 <<<

# >>> archly:node:azure_policy >>>
# Azure Policy (governance.policy)
# Fallback scaffold: provider-specific mapping is not curated yet. Review and complete required arguments before applying.
resource "azurerm_policy" "azure_policy" {
  name = var.azure_policy_name
  resource_group_name = local.resource_group_name
  location            = local.location

  # TODO: Review the Terraform provider docs for azurerm_policy
  # and add every required argument before applying.
}
# <<< archly:node:azure_policy <<<

# >>> archly:node:microsoft_entra_id >>>
# Microsoft Entra ID (auth.identity_center)
# Fallback scaffold: provider-specific mapping is not curated yet. Review and complete required arguments before applying.
resource "azurerm_identity_center" "microsoft_entra_id" {
  name = var.microsoft_entra_id_name
  resource_group_name = local.resource_group_name
  location            = local.location

  # TODO: Review the Terraform provider docs for azurerm_identity_center
  # and add every required argument before applying.
}
# <<< archly:node:microsoft_entra_id <<<

# >>> archly:node:defender_for_cloud >>>
# Defender for Cloud (security.guardduty)
# Fallback scaffold: provider-specific mapping is not curated yet. Review and complete required arguments before applying.
resource "azurerm_guardduty" "defender_for_cloud" {
  name = var.defender_for_cloud_name
  resource_group_name = local.resource_group_name
  location            = local.location

  # TODO: Review the Terraform provider docs for azurerm_guardduty
  # and add every required argument before applying.
}
# <<< archly:node:defender_for_cloud <<<

# >>> archly:node:sql2_pe >>>
# Azure SQL Failover PE (network.private_endpoint) -- belongs to subnet 'Private Endpoint Subnet' (see resource id 'pe_subnet' above; wire this resource's subnet/network args to it manually)
# Fallback scaffold: provider-specific mapping is not curated yet. Review and complete required arguments before applying.
resource "azurerm_private_endpoint" "sql2_pe" {
  name = var.sql2_pe_name
  resource_group_name = local.resource_group_name
  location            = local.location

  # TODO: Review the Terraform provider docs for azurerm_private_endpoint
  # and add every required argument before applying.
}
# <<< archly:node:sql2_pe <<<