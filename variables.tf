variable "location" {
  description = "The Azure Region in which the resources will be deployed."
  type        = string
}

variable "environment" {
  description = "The Environment in which the resources will be deployed."
  type        = string
}

variable "virtual_machine_size" {
  description = "The Size of the Virtual Machine."
  type        = string
}
