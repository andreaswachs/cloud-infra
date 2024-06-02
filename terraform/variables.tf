###
#
## Variables pertaining to infrastructure or foundational services/tooling
#
##

####
#### Kubernetes
####

variable "kubernetes_host" {
  description = "Kubernetes host"
  type        = string
}

####
#### Vault
####

variable "vault_root_token" {
  description = "Vault root token"
  type        = string
}

variable "vault_addr" {
  type        = string
  description = "Vault address in the form of https://domain:8200"
  default     = "https://vault.wachs.work"
}

###
#
## Application variables
#
##

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

variable "chatgpt_oauth_oidc_issuer_url" {
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
