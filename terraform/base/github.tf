data "github_repository" "repo" {
  name = var.gh_repo_name
}

## Secrets
resource "github_actions_secret" "tf_api_token" {
  repository      = data.github_repository.repo.name
  secret_name     = "tf_api_token"
  plaintext_value = var.tf_api_token
}
