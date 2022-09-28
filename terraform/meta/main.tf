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
