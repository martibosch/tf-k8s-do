# organization
data "tfe_organization" "org" {
  name = var.tfc_org_name
}

# workspaces
resource "tfe_workspace" "base" {
  name         = "${var.project_slug}-base"
  organization = data.tfe_organization.org.name
  tag_names    = [var.project_slug]
  # execution_mode = "local"
}

resource "tfe_variable" "do_token" {
  key          = "do_token"
  value        = var.do_token
  category     = "terraform"
  workspace_id = tfe_workspace.base.id
  sensitive    = true
}

resource "tfe_variable" "gh_token" {
  key          = "gh_token"
  value        = var.gh_token
  category     = "terraform"
  workspace_id = tfe_workspace.base.id
  sensitive    = true
}

resource "tfe_variable" "project_slug" {
  key          = "project_slug"
  value        = var.project_slug
  category     = "terraform"
  workspace_id = tfe_workspace.base.id
}

resource "tfe_variable" "project_description" {
  key          = "project_description"
  value        = var.project_description
  category     = "terraform"
  workspace_id = tfe_workspace.base.id
}

resource "tfe_variable" "gh_repo_name" {
  key          = "gh_repo_name"
  value        = var.gh_repo_name
  category     = "terraform"
  workspace_id = tfe_workspace.base.id
}

resource "tfe_variable" "tf_api_token" {
  key          = "tf_api_token"
  value        = var.tf_api_token
  category     = "terraform"
  workspace_id = tfe_workspace.base.id
  sensitive    = true
}

resource "tfe_variable" "top_level_domains" {
  key          = "top_level_domains"
  value        = jsonencode(var.top_level_domains)
  category     = "terraform"
  workspace_id = tfe_workspace.base.id
}

resource "tfe_variable" "letsencrypt_email" {
  key          = "letsencrypt_email"
  value        = var.letsencrypt_email
  category     = "terraform"
  workspace_id = tfe_workspace.base.id
}
