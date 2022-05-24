# Test github repo module
provider "tfe" {
  token = var.tfc_token
}

module "Test" {
  source = "../"

  name = "DeleteMe-Test1"
}
