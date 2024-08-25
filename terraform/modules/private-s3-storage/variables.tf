variable "bucket_name" {
  description = "The name of the S3 bucket"
  type        = string
}

variable "use_cold_storage" {
  description = "Whether to use cold storage for the bucket"
  type        = bool
}
