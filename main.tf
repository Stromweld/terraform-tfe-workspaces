resource "tfe_workspace" "workspace" {
  name                          = var.name                           # (Required) Name of the workspace.
  organization                  = var.organization                   # (Required) Name of the organization.
  description                   = try(var.description, null)         # (Optional) A description for the workspace.
  allow_destroy_plan            = null                               # (Optional) Whether destroy plans can be queued on the workspace.
  auto_apply                    = false                              # (Optional) Whether to automatically apply changes when a Terraform plan is successful. Defaults to false.
  file_triggers_enabled         = null                               # (Optional) Whether to filter runs based on the changed files in a VCS push. If enabled, the working directory and trigger prefixes describe a set of paths which must contain changes for a VCS push to trigger a run. If disabled, any push will trigger a run. Defaults to true.
  queue_all_runs                = true                               # (Optional) Whether all runs should be queued. When set to false, runs triggered by a VCS change will not be queued until at least one run is manually queued. Defaults to true.
  speculative_enabled           = try(var.speculative_enabled, null) # (Optional) Whether this workspace allows speculative plans. Setting this to false prevents Terraform Cloud or the Terraform Enterprise instance from running plans on pull requests, which can improve security if the VCS repository is public or includes untrusted contributors. Defaults to true.
  structured_run_output_enabled = null                               # (Optional) Whether this workspace should show output from Terraform runs using the enhanced UI when available. Defaults to true. Setting this to false ensures that all runs in this workspace will display their output as text logs.
  ssh_key_id                    = null                               # (Optional) The ID of an SSH key to assign to the workspace.
  terraform_version             = try(var.terraform_version, null)   # (Optional) The version of Terraform to use for this workspace. Defaults to the latest available version.
  trigger_prefixes              = null                               # (Optional) List of repository-root-relative paths which describe all locations to be tracked for changes.
  tag_names                     = null                               # (Optional) A list of tag names for this workspace.
  working_directory             = null                               # (Optional) A relative path that Terraform will execute within. Defaults to the root of your repository.
  dynamic "vcs_repo" {                                               # (Optional) Settings for the workspace's VCS repository, enabling the UI/VCS-driven run workflow. Omit this argument to utilize the CLI-driven and API-driven workflows, where runs are not driven by webhooks on your VCS provider.
    for_each = var.vcs_repo["enabled"] ? { vcs_settings = var.vcs_repo } : {}
    content {
      identifier                 = var.repo_identifier                                     # (Required) A reference to your VCS repository in the format :org/:repo where :org and :repo refer to the organization and repository in your VCS provider.
      branch                     = try(vcs_repo.value["branch"], "main")                   # (Optional) The repository branch that Terraform will execute from. Default to main.
      github_app_installation_id = try(vcs_repo.value["github_app_installation_id"], null) # (Optional) The installation id of the Github App. This conflicts with oauth_token_id and can only be used if oauth_token_id is not used.
      ingress_submodules         = try(vcs_repo.value["ingress_submodules"], false)        # (Optional) Whether submodules should be fetched when cloning the VCS repository. Defaults to false.
      oauth_token_id             = try(vcs_repo.value["oauth_token_id"], null)             # (Optional) The VCS Connection (OAuth Connection + Token) to use. This ID can be obtained from a tfe_oauth_client resource. This conflicts with github_app_installation_id and can only be used if github_app_installation_id is not used.
      tags_regex                 = try(vcs_repo.value["tags_regex"], null)                 # (Optional) A regular expression used to trigger a Workspace run for matching Git tags. This option conflicts with trigger_patterns and trigger_prefixes. Should only set this value if the former is not being used.
    }
  }
}

resource "tfe_workspace_settings" "this" {
  workspace_id              = tfe_workspace.workspace.id               # (Required) ID of the workspace.
  agent_pool_id             = null                                     # (Optional) The ID of an agent pool to assign to the workspace. Requires execution_mode to be set to agent. This value must not be provided if execution_mode is set to any other value.
  execution_mode            = "remote"                                 # (Optional) Which execution mode to use. Using HCP Terraform, valid values are remote, local or agent. When set to local, the workspace will be used for state storage only. Important: If you omit this attribute, the resource configures the workspace to use your organization's default execution mode (which in turn defaults to remote), removing any explicit value that might have previously been set for the workspace.
  global_remote_state       = try(var.global_remote_state, null)       # (Optional) Whether the workspace allows all workspaces in the organization to access its state data during runs. If false, then only specifically approved workspaces can access its state (remote_state_consumer_ids). By default, HashiCorp recommends you do not allow other workspaces to access their state. We recommend that you follow the principle of least privilege and only enable state access between workspaces that specifically need information from each other.
  remote_state_consumer_ids = try(var.remote_state_consumer_ids, null) # (Optional) The set of workspace IDs set as explicit remote state consumers for the given workspace. To set this attribute, global_remote_state must be false.
  auto_apply                = try(var.auto_apply, false)               # (Optional) Whether to automatically apply changes when a Terraform plan is successful. Defaults to false.
  assessments_enabled       = try(var.assessments_enabled, false)      # - (Optional) Whether to regularly run health assessments such as drift detection on the workspace. Defaults to false.
  description               = try(var.description, null)               # (Optional) A description for the workspace.
  tags                      = try(var.tags, null)                      # (Optional) A map of key value tags for this workspace.
}

resource "tfe_variable" "this" {
  for_each = var.tfe_variables

  key             = each.key                              # (Required) Name of the variable.
  value           = each.value.value                      # (Required) Value of the variable.
  value_wo        = each.value.value_wo                   # (Optional, Write-Only) Value of the variable. Write-only attributes function similarly to their non-write-only counterparts, but are never stored to state and do not display in the Terraform plan output. Either value or value_wo can be provided, but not both.
  category        = each.value.category                   # (Required) Whether this is a Terraform or environment variable. Valid values are terraform or env.
  description     = try(each.value.description, null)     # (Optional) Description of the variable.
  hcl             = try(each.value.hcl, null)             # (Optional) Whether to evaluate the value of the variable as a string of HCL code. Has no effect for environment variables. Defaults to false.
  sensitive       = try(each.value.sensitive, null)       # (Optional) Whether the value is sensitive. If true then the variable is written once and not visible thereafter. Defaults to false.
  workspace_id    = try(each.value.workspace_id, null)    # (Required or variable_set_id not both) ID of the workspace that owns the variable.
  variable_set_id = try(each.value.variable_set_id, null) # (Required or workspace_id not both) ID of the variable set that owns the variable.
}
