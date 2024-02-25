provider "aws" {
  region = "eu-west-1"
}

module "lambda_function" {
  source                      = "./modules/lambda_function"
  lambda_source_dir           = var.lambda_source_dir
  youtube_api_key_secret_name = var.youtube_api_key_secret_name
  bucket_name                 = local.bucket_name
  lambda_function_name        = local.lambda_function_name
  dependency_layer_name       = local.lambda_dependency_layer_name
  runtime                     = var.lambda_runtime
  iam_policy_attach_name      = local.lambda_iam_policy_attach_name
  iam_policy_name             = local.lambda_iam_policy_name
  iam_role_name               = local.lambda_iam_role_name
  tags                        = var.tags
}

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
  lambda_function_arn    = module.lambda_function.lambda_function_arn
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
