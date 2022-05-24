variable "name" {
  type        = string
  description = "Name of workspace"
}
variable "description" {
  type        = string
  default     = null
  description = "Description of workspace"
}
variable "organization" {
  type        = string
  default     = "Stromweld"
  description = "Owning Org for workspace"
}
variable "terraform_version" {
  type        = string
  default     = null
  description = "The version of Terraform to use for this workspace. Defaults to the latest available version. "
}
variable "vcs_repo" {
  type = map(string)
  default = {
    enabled = false
  }
  description = "Used to add VCS repo to workspace"
}
variable "repo_identifier" {
  type        = string
  default     = null
  description = "VCS identifier to link repo to"
}
variable "oauth_token_id" {
  type        = string
  default     = null
  description = "Oauth Token for VCS provider configured in TFC"
}
variable "speculative_enabled" {
  type        = bool
  default     = true
  description = "Enable speculative plans"
}
variable "tfe_variables" {
  type        = map(any)
  default     = {}
  description = "Set workspace variables"
}
