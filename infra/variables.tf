variable "aws_region" {
  description = "AWS region to create resources in"
  type        = string
  default     = "ap-south-1"
}

variable "aws_account_id" {
  description = "AWS account id used for naming"
  type        = string
  default     = ""
}
