provider "aws" {
  region = var.region
}

module "lambda_data" {
  source                      = "./modules/lambda_data"
  lambda_source_dir           = var.lambda_data_source_dir
  youtube_api_key_secret_name = var.youtube_api_key_secret_name
  bucket_name                 = local.bucket_name
  lambda_function_name        = local.lambda_data_function_name
  dependency_layer_name       = local.lambda_data_dependency_layer_name
  runtime                     = var.lambda_runtime
  iam_policy_attach_name      = local.lambda_data_iam_policy_attach_name
  iam_policy_name             = local.lambda_data_iam_policy_name
  iam_role_name               = local.lambda_data_iam_role_name
  tags                        = var.tags
}

# module "lambda_report" {
#   source                 = "./modules/lambda_report"
#   lambda_source_dir      = var.lambda_report_source_dir
#   bucket_name            = local.bucket_name
#   lambda_function_name   = local.lambda_report_function_name
#   dependency_layer_name  = local.lambda_report_dependency_layer_name
#   runtime                = var.lambda_runtime
#   iam_policy_attach_name = local.lambda_report_iam_policy_attach_name
#   iam_policy_name        = local.lambda_report_iam_policy_name
#   iam_role_name          = local.lambda_report_iam_role_name
#   tags                   = var.tags
#   bucket_arn             = module.s3_bucket.bucket_arn
#   region                 = var.region
# }

module "s3_bucket" {
  source      = "./modules/s3_bucket"
  bucket_name = local.bucket_name
  tags        = var.tags
}

module "glue_catalog" {
  source                = "./modules/glue_catalog"
  bucket_name           = local.bucket_name
  catalog_database_name = local.catalog_database_name
  catalog_table_name    = local.catalog_table_name
  tags                  = var.tags
}

module "state_machine" {
  source                 = "./modules/state_machine"
  lambda_function_arn    = module.lambda_data.lambda_function_arn
  bucket_arn             = module.s3_bucket.bucket_arn
  bucket_name            = local.bucket_name
  catalog_database_name  = local.catalog_database_name
  catalog_table_name     = local.catalog_table_name
  state_machine_name     = local.state_machine_name
  iam_role_name          = local.state_machine_iam_role_name
  iam_policy_name        = local.state_machine_iam_policy_name
  iam_policy_attach_name = local.state_machine_iam_policy_attach_name
  tags                   = var.tags
}

module "api_gateway" {
  source            = "./modules/api_gateway"
  api_name          = local.api_name
  state_machine_arn = module.state_machine.state_machine_arn
  region            = var.region
}
