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
  description = "The version of Terraform to use for this workspace. Defaults to the latest available version"
}
variable "vcs_repo" {
  type = map(string)
  default = {
    enabled = false
  }
  description = "Used to add VCS repo to workspace"
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
variable "global_remote_state" {
  type        = bool
  default     = false
  description = "Whether the workspace allows all workspaces in the organization to access its state data during runs"
}
variable "remote_state_consumer_ids" {
  type        = list(string)
  default     = null
  description = "The set of workspace IDs set as explicit remote state consumers for the given workspace"
}
variable "auto_apply" {
  type        = bool
  default     = false
  description = "Whether to automatically apply changes when a Terraform plan is successful"
}
variable "assessments_enabled" {
  type        = bool
  default     = false
  description = "Whether to regularly run health assessments such as drift detection on the workspace"
}
variable "tags" {
  type        = map(any)
  default     = null
  description = "A map of key value tags for this workspace"
}
