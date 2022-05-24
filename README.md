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
| `oauth_token_id` | string | null | no | Oauth Token for VCS provider configured in TFC |
| `speculative_enabled` | bool | true | no | Enable speculative plans |
| `tfe_variables` | map(any) | {} | no | Set workspace variables |

## Outputs

| Name            | Description              |
|-----------------|--------------------------|
