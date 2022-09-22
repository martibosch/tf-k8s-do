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
}

resource "tfe_variable" "gh_token" {
  key          = "gh_token"
  value        = var.gh_token
  category     = "terraform"
  workspace_id = tfe_workspace.base.id
}
