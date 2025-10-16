# terraform-tfe-workspaces

Terraform module for Terraform Cloud Workspaces

## References

<https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/workspace>

## Usage

```hcl
provider "tfe" {
  token = var.tfc_token
}

module "tfc-workspace" {
  source  = "app.terraform.io/Stromweld/workspaces/tfe"
  version = ">= 1.0.0"

  name = "example"
}
```

## Inputs

| Name | Type        | Default | Required | Description |
|------|-------------|---------|----------|-------------|
| `name` | string      | | yes | Name of workspace |
| `description` | string      | null | no | Description of workspace |
| `organization` | string      | "Stromweld" | no | Owning Org for workspace |
| `terraform_version` | string      | null | no | The version of Terraform to use for this workspace. Defaults to the latest available version. |
| `vcs_repo` | map(string) | {enabled = false} | no | Used to add VCS repo to workspace |
| `repo_identifier` | string | null | no | VCS identifier to link repo to |
| `speculative_enabled` | bool | true | no | Enable speculative plans |
| `tfe_variables` | map(any) | {} | no | Set workspace variables |
| `global_remote_state` | bool | false | no | Whether the workspace allows all workspaces in the organization to access its state data during runs |
| `remote_state_consumer_ids` | list(string) | null | no | The set of workspace IDs set as explicit remote state consumers for the given workspace |
| `auto_apply` | bool | false | no | Whether to automatically apply changes when a Terraform plan is successful |
| `assessments_enabled` | bool | false | no | Whether to regularly run health assessments such as drift detection on the workspace |
| `tags` | map(any) | null | no | A map of key value tags for this workspace |

## Outputs

| Name            | Description              |
|-----------------|--------------------------|
