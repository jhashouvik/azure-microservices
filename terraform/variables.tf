variable "location" {
  description = "Azure region to deploy into"
  type        = string
  default     = "eastus"
}

variable "resource_group_name" {
  description = "Resource group name to create for this deployment"
  type        = string
}

variable "tenant_id" {
  description = "Azure AD tenant id"
  type        = string
}

# >>> archly:group:vnet1 >>>
variable "vnet1_address_space" {
  description = "Address space for VNet 'Workload VNet'"
  type        = string
  default     = "10.0.0.0/16"
}
# <<< archly:group:vnet1 <<<

# >>> archly:group:appgw_subnet >>>
variable "appgw_subnet_address_prefix" {
  description = "Address prefix for subnet 'App Gateway Subnet' (must fall within the VNet's address space)"
  type        = string
  default     = "10.0.1.0/24"
}
# <<< archly:group:appgw_subnet <<<

# >>> archly:group:apps_subnet >>>
variable "apps_subnet_address_prefix" {
  description = "Address prefix for subnet 'Container Apps Subnet' (must fall within the VNet's address space)"
  type        = string
  default     = "10.0.2.0/24"
}
# <<< archly:group:apps_subnet <<<

# >>> archly:group:pe_subnet >>>
variable "pe_subnet_address_prefix" {
  description = "Address prefix for subnet 'Private Endpoint Subnet' (must fall within the VNet's address space)"
  type        = string
  default     = "10.0.3.0/24"
}
# <<< archly:group:pe_subnet <<<

# >>> archly:group:data_services >>>
variable "data_services_address_space" {
  description = "Address space for VNet 'Managed Data Services'"
  type        = string
  default     = "10.0.0.0/16"
}
# <<< archly:group:data_services <<<

# >>> archly:group:security_ops >>>
variable "security_ops_address_space" {
  description = "Address space for VNet 'Security & Operations'"
  type        = string
  default     = "10.0.0.0/16"
}
# <<< archly:group:security_ops <<<

# >>> archly:group:platform_controls >>>
variable "platform_controls_address_space" {
  description = "Address space for VNet 'Platform Controls'"
  type        = string
  default     = "10.0.0.0/16"
}
# <<< archly:group:platform_controls <<<

# >>> archly:node:appgw1 >>>
variable "appgw1_name" {
  description = "Name for azurerm_application_gateway"
  type        = string
}
# <<< archly:node:appgw1 <<<

# >>> archly:node:apps1 >>>
variable "apps1_container_image" {
  description = "Container image to deploy, e.g. myrepo/app:latest"
  type        = string
}
# <<< archly:node:apps1 <<<

# >>> archly:node:mi1 >>>
variable "mi1_name" {
  description = "Name for azurerm_managed"
  type        = string
}
# <<< archly:node:mi1 <<<

# >>> archly:node:sqlpe1 >>>
variable "sqlpe1_name" {
  description = "Name for azurerm_private_endpoint"
  type        = string
}
# <<< archly:node:sqlpe1 <<<

# >>> archly:node:redispe1 >>>
variable "redispe1_name" {
  description = "Name for azurerm_private_endpoint"
  type        = string
}
# <<< archly:node:redispe1 <<<

# >>> archly:node:sbpe1 >>>
variable "sbpe1_name" {
  description = "Name for azurerm_private_endpoint"
  type        = string
}
# <<< archly:node:sbpe1 <<<

# >>> archly:node:blobpe1 >>>
variable "blobpe1_name" {
  description = "Name for azurerm_private_endpoint"
  type        = string
}
# <<< archly:node:blobpe1 <<<

# >>> archly:node:kvpe1 >>>
variable "kvpe1_name" {
  description = "Name for azurerm_private_endpoint"
  type        = string
}
# <<< archly:node:kvpe1 <<<

# >>> archly:node:sql1 >>>
variable "sql1_administrator_login" {
  description = "Administrator login"
  type        = string
  default     = "sqladminuser"
}

variable "sql1_administrator_password" {
  description = "Administrator password -- supply via TF_VAR_sql1_administrator_password, never commit"
  type        = string
  sensitive   = true
}
# <<< archly:node:sql1 <<<

# >>> archly:node:sql2 >>>
variable "sql2_administrator_login" {
  description = "Administrator login"
  type        = string
  default     = "sqladminuser"
}

variable "sql2_administrator_password" {
  description = "Administrator password -- supply via TF_VAR_sql2_administrator_password, never commit"
  type        = string
  sensitive   = true
}
# <<< archly:node:sql2 <<<

# >>> archly:node:dns1 >>>
variable "dns1_name" {
  description = "Name for azurerm_private"
  type        = string
}
# <<< archly:node:dns1 <<<

# >>> archly:node:logs1 >>>
variable "logs1_name" {
  description = "Name for azurerm_logging"
  type        = string
}
# <<< archly:node:logs1 <<<

# >>> archly:node:azure_policy >>>
variable "azure_policy_name" {
  description = "Name for azurerm_policy"
  type        = string
}
# <<< archly:node:azure_policy <<<

# >>> archly:node:microsoft_entra_id >>>
variable "microsoft_entra_id_name" {
  description = "Name for azurerm_identity_center"
  type        = string
}
# <<< archly:node:microsoft_entra_id <<<

# >>> archly:node:defender_for_cloud >>>
variable "defender_for_cloud_name" {
  description = "Name for azurerm_guardduty"
  type        = string
}
# <<< archly:node:defender_for_cloud <<<

# >>> archly:node:sql2_pe >>>
variable "sql2_pe_name" {
  description = "Name for azurerm_private_endpoint"
  type        = string
}
# <<< archly:node:sql2_pe <<<