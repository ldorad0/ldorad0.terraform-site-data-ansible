module "site_data" {
  # source = "git::https://github.com/ldorad0/ldorad0.terraform-site-data-ansible.git"
  source              = "../"
  inventory_file_path = var.inventory_file_path
}