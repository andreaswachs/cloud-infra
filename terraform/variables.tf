variable "chatgpt_oauth_client_secret" {
  description = "OAuth client secret"
  type        = string
}

variable "chatgpt_oauth_client_id" {
  description = "OAuth client ID"
  type        = string
}

variable "chatgpt_oauth_cookie_secret" {
  description = "OAuth cookie secret"
  type        = string
}

variable "chatgpt_oauth_oidc_issue_url" {
  description = "OAuth OIDC issue URL"
  type        = string
}

variable "chatgpt_openai_api_key" {
  description = "OpenAI API key"
  type        = string
}

variable "gh_webhook_secret" {
  description = "GitHub webhook secret"
  type        = string
}

variable "vault_root_token" {
  description = "Vault root token"
  type        = string
}


variable "vault_addr" {
  type        = string
  description = "Vault address in the form of https://domain:8200"
  default     = "https://vault.wachs.work"
}

variable "vault_namespace" {
  type        = string
  description = "namespace in which to mount the auth method"
  default     = ""
}

variable "auth0_base_url" {
  type        = string
  description = "The Okta SaaS endpoint, usually auth0.com or auth0preview.com"
  default     = "wachs.eu.auth0.com"
}

variable "auth0_base_url_full" {
  type        = string
  description = "Full URL of Okta login, usually instanceID.auth0.com, ie https://dev-208447.auth0.com"
  default     = "https://wachs.eu.auth0.com"
}

variable "auth0_client_id" {
  type        = string
  description = "Okta Vault app client ID"
}

variable "auth0_client_secret" {
  type        = string
  description = "Okta Vault app client secret"
}

variable "auth0_allowed_groups" {
  type        = list(any)
  description = "Okta group for Vault admins"
  default     = ["vault_admins"]
}

variable "auth0_mount_path" {
  type        = string
  description = "Mount path for Okta auth"
  default     = "auth0_oidc"
}

variable "auth0_user_email" {
  type        = string
  description = "e-mail of a user to dynamically add to the groups created by this config"
}

variable "auth0_tile_app_label" {
  type        = string
  description = "HCP Vault"
}

# variable "auth0_client_id" {
#   type        = string
#   description = "Okta Vault app client ID"
# }

# variable "auth0_client_secret" {
#   type        = string
#   description = "Okta Vault app client secret"
# }

# variable "auth0_bound_audiences" {
#   type        = list(any)
#   description = "A list of allowed token audiences"
# }

variable "auth0_auth_audience" {
  type        = string
  description = ""
  default     = "api://vault"
}

variable "cli_port" {
  type        = number
  description = "Port to open locally to login with the CLI"
  default     = 8250
}

variable "auth0_default_lease_ttl" {
  type        = string
  description = "Default lease TTL for Vault tokens"
  default     = "12h"
}

variable "auth0_max_lease_ttl" {
  type        = string
  description = "Maximum lease TTL for Vault tokens"
  default     = "768h"
}

variable "auth0_token_type" {
  type        = string
  description = "Token type for Vault tokens"
  default     = "default-service"
}

variable "roles" {
  type    = map(any)
  default = {}

  description = <<EOF
Map of Vault role names to their bound groups and token policies. Structure looks like this:
```
roles = {
  auth0_admin = {
    token_policies = ["admin-policy"]
    bound_groups = ["vault-admins"]
  },
  auth0_devs  = {
    token_policies = ["devs-policy"]
    bound_groups = ["vault-devs"]
  }
}
```
EOF
}
