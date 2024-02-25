variable "bucket_name" {
  type        = string
  description = "Name of the S3 bucket"
}

variable "catalog_database_name" {
  type        = string
  description = "Name of the Glue catalog database"
}

variable "catalog_table_name" {
  type        = string
  description = "Name of the Glue catalog table"
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to resources"
}


