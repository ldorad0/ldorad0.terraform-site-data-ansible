variable "ANSIBLE_GATHERING" {
  default = "explicit"
  type = string
  description = <<EOF
    Controls fact gathering
    Default value is 'explicit', which
    means the underlying ansible command will not gather facts 
  EOF  

  validation {
    condition     = contains(["explicit", "smart"], var.ANSIBLE_GATHERING)
    error_message = "Valid values for var: ANSIBLE_GATHERING are (explicit, smart)."
  }   
}

variable "inventory_hostname" {
  default = "localhost"
  type = string
}

variable "inventory_file_path" {
  type = string
}