resource "vault_kv_secret_v2" "oauth_client_secret" {
  mount = vault_mount.apps.path
  name  = "/chatgpt-web-client"

  delete_all_versions = true

  data_json = jsonencode({
    oauth_client_secret   = var.chatgpt_oauth_client_secret,
    oauth_client_id       = var.chatgpt_oauth_client_id,
    oauth_cookie_secret   = var.chatgpt_oauth_cookie_secret,
    oauth_oidc_issuer_url = var.chatgpt_oauth_oidc_issuer_url,
    openai_api_key        = var.chatgpt_openai_api_key
  })

  custom_metadata {
    max_versions = 10
  }
}

resource "vault_kv_secret_v2" "gh_webhook_secret" {
  mount = vault_mount.apps.path
  name  = "/webhooks/github"

  delete_all_versions = true

  data_json = jsonencode({
    gh_webhooks = var.gh_webhook_secret
  })

  custom_metadata {
    max_versions = 10
  }
}
