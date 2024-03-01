locals {
  ###########################################
  ##### Lambda function to get comments #####
  ###########################################
  lambda_function_name          = "${var.prefix}-lambda"
  lambda_dependency_layer_name  = "${var.prefix}-lambda-dependency-layer"
  lambda_iam_role_name          = "${var.prefix}-lambda-role"
  lambda_iam_policy_name        = "${var.prefix}-lambda-policy"
  lambda_iam_policy_attach_name = "${var.prefix}-lambda-attachment"
  lambda_compatible_runtime     = "python3.9"

  ########################################
  ##### Glue catalog to request data #####
  ########################################
  catalog_database_name = "${replace(var.prefix, "-", "_")}_database"
  catalog_table_name    = "${replace(var.prefix, "-", "_")}_table"

  #######################################
  ##### S3 bucket to store comments #####
  #######################################
  bucket_name = "${var.prefix}-bucket"

  #################################################
  ##### State machine to orchestrate services #####
  #################################################
  state_machine_name                   = "${var.prefix}-state-machine"
  state_machine_iam_role_name          = "${var.prefix}-state-machine-role"
  state_machine_iam_policy_name        = "${var.prefix}-state-machine-policy"
  state_machine_iam_policy_attach_name = "${var.prefix}-state-machine-attachment"

  ######################################
  ##### API to start State Machine #####
  ######################################
  api_name = "${var.prefix}-api"
}
