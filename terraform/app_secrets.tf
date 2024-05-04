resource "aws_ssm_parameter" "oauth_client_secret" {
  name        = "/k8s/chatgpt/oauth/clientSecret"
  description = "OAuth client secret parameter for ChatGPT"
  type        = "SecureString"
  value       = var.chatgpt_oauth_client_secret
}

resource "aws_ssm_parameter" "oauth_client_id" {
  name        = "/k8s/chatgpt/oauth/clientId"
  description = "OAuth client ID parameter for ChatGPT"
  type        = "SecureString"
  value       = var.chatgpt_oauth_client_id
}

resource "aws_ssm_parameter" "oauth_cookie_secret" {
  name        = "/k8s/chatgpt/oauth/cookieSecret"
  description = "OAuth cookie secret parameter for ChatGPT"
  type        = "SecureString"
  value       = var.chatgpt_oauth_cookie_secret
}

resource "aws_ssm_parameter" "oauth_oidc_issue_url" {
  name        = "/k8s/chatgpt/oauth/oidcIssueUrl"
  description = "OAuth OIDC issue URL parameter for ChatGPT"
  type        = "SecureString"
  value       = var.chatgpt_oauth_oidc_issue_url
}

resource "aws_ssm_parameter" "openai_api_key" {
  name        = "/k8s/openAI/apiKey"
  description = "OpenAI API key parameter for ChatGPT"
  type        = "SecureString"
  value       = var.chatgpt_openai_api_key
}

resource "aws_ssm_parameter" "gh_webhook_secret" {
  name        = "/k8s/webhook/webhookSecret"
  description = "GitHub webhook secret parameter for ChatGPT"
  type        = "SecureString"
  value       = var.gh_webhook_secret
}
