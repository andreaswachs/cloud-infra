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
