#------------------------------------------------
# General
#------------------------------------------------

variable "subscription_id" {
  type    = string
  default = "799d940d-ace2-4562-b3cb-0cb3e565709b"
}

variable "location" {
  type    = string
  default = "West Europe"
}
variable "vm_size" {
  type    = string
  default = "Standard_NV12s_v3"
}

variable "admin_username" {
  type    = string
  default = "CloudGamer"
}