locals {
  ###########################################
  ##### Lambda function to get comments #####
  ###########################################
  lambda_data_function_name          = "${var.prefix}-lambda-data"
  lambda_data_dependency_layer_name  = "${var.prefix}-lambda-data-dependency-layer"
  lambda_data_iam_role_name          = "${var.prefix}-lambda-data-role"
  lambda_data_iam_policy_name        = "${var.prefix}-lambda-data-policy"
  lambda_data_iam_policy_attach_name = "${var.prefix}-lambda-data-attachment"
  lambda_data_compatible_runtime     = "python3.10"

  #################################################
  ##### Lambda function to transform comments #####
  #################################################
  lambda_transform_function_name          = "${var.prefix}-lambda-transform"
  lambda_transform_iam_role_name          = "${var.prefix}-lambda-transform-role"
  lambda_transform_iam_policy_name        = "${var.prefix}-lambda-transform-policy"
  lambda_transform_iam_policy_attach_name = "${var.prefix}-lambda-transform-attachment"
  lambda_transform_ecr_repososity_name    = "${var.prefix}-lambda-transform-ecr"
  lambda_transform_compatible_runtime     = "python3.10"

  ##############################################
  ##### Lambda function to format comments #####
  ##############################################
  lambda_format_function_name          = "${var.prefix}-lambda-format"
  lambda_format_iam_role_name          = "${var.prefix}-lambda-format-role"
  lambda_format_iam_policy_name        = "${var.prefix}-lambda-format-policy"
  lambda_format_iam_policy_attach_name = "${var.prefix}-lambda-format-attachment"
  lambda_format_compatible_runtime     = "python3.10"

  ###############################################################
  ##### Lambda function to compute statistics from comments #####
  ###############################################################
  lambda_analyze_function_name          = "${var.prefix}-lambda-analyze"
  lambda_analyze_iam_role_name          = "${var.prefix}-lambda-analyze-role"
  lambda_analyze_iam_policy_name        = "${var.prefix}-lambda-analyze-policy"
  lambda_analyze_iam_policy_attach_name = "${var.prefix}-lambda-analyze-attachment"
  lambda_analyze_compatible_runtime     = "python3.10"

  ###########################################
  ##### Lambda function to create pdf #######
  ###########################################
  lambda_report_function_name          = "${var.prefix}-lambda-report"
  lambda_report_dependency_layer_name  = "${var.prefix}-lambda-report-dependency-layer"
  lambda_report_iam_role_name          = "${var.prefix}-lambda-report-role"
  lambda_report_iam_policy_name        = "${var.prefix}-lambda-report-policy"
  lambda_report_iam_policy_attach_name = "${var.prefix}-lambda-report-attachment"
  lambda_report_compatible_runtime     = "python3.10"

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
