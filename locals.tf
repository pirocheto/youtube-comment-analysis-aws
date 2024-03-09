locals {
  ###########################################
  ##### Lambda function to get comments #####
  ###########################################
  lambda_data_function_name          = "${var.prefix}-lambda-data"
  lambda_data_dependency_layer_name  = "${var.prefix}-lambda-data-dependency-layer"
  lambda_data_iam_role_name          = "${var.prefix}-lambda-data-role"
  lambda_data_iam_policy_name        = "${var.prefix}-lambda-data-policy"
  lambda_data_iam_policy_attach_name = "${var.prefix}-lambda-data-attachment"
  lambda_data_compatible_runtime     = "python3.9"

  ###########################################
  ##### Lambda function to create pdf #######
  ###########################################
  lambda_report_function_name          = "${var.prefix}-lambda-report"
  lambda_report_dependency_layer_name  = "${var.prefix}-lambda-report-dependency-layer"
  lambda_report_iam_role_name          = "${var.prefix}-lambda-report-role"
  lambda_report_iam_policy_name        = "${var.prefix}-lambda-report-policy"
  lambda_report_iam_policy_attach_name = "${var.prefix}-lambda-report-attachment"
  lambda_report_compatible_runtime     = "python3.9"

  ########################################
  ##### Glue catalog to request data #####
  ########################################
  catalog_database_name = "${replace(var.prefix, "-", "_")}_database"
  catalog_table_name    = "${replace(var.prefix, "-", "_")}_table"

  #######################################
  ##### S3 bucket to store comments #####
  #######################################
  bucket_name = "${var.prefix}-bucket-v4"

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
