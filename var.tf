variable "ami_id" {
  description = "AMI ID to use for instances"
  type        = string
  default     = "ami-0ae7e1e8fb8251940"
}

variable "subnets" {
  description = "List of subnet IDs"
  type        = list(string)
  default     = [
    "subnet-01e6348062924d048",
    "subnet-0a1cbd99dd27a5307",
    "subnet-0d0b0b1b77639731b",
    "subnet-088b7d937a4cd5d85",
  ]
}

variable "region" {
  description = "Region to use"
  type        = string
  default     = "il-central-1"
}
