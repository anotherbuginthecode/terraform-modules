################################################################################
# Lambda deployment
################################################################################

# ----- lambda -----

data "archive_file" "lambda_zip"{
    type = "zip"
    source_dir = "${var.source_dir}"
    output_path = "${var.output_path}"
}

resource "aws_s3_object" "lambda" {
  
  bucket = "${var.bucket}"
  key = "${var.bucket_key}"
  source = data.archive_file.lambda_zip.output_path

  etag = filemd5(data.archive_file.lambda_zip.output_path)

  depends_on = [
    data.archive_file.lambda_zip
  ]
}

resource "aws_lambda_function" "lambda" {

  function_name = "${var.function_name}"

  s3_bucket = "${var.bucket}"
  s3_key = aws_s3_object.lambda.key

  runtime = "${var.runtime}"
  handler = "${var.handler}"
  timeout = "${var.timeout}"
  memory_size = "${var.memory_size}"

  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  role = "${var.role_arn}"

  layers = "${var.layers}"

  environment {
    variables = "${var.environment_variables}"
  }
}

# define lambda policy
resource "aws_iam_policy" "policy" {
  count = var.create_policy ? 1 : 0

  name  = "${var.policy_name}"
  description = "${var.policy_description}"

  policy = "${var.policy}"
}

resource "aws_iam_role_policy_attachment" "lambda_policy_basic" {
  role = "${var.role_name}"
  policy_arn  = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "lambda_policy_custom" {
  count = var.create_policy ? 1 : 0

  role = "${var.role_name}"
  policy_arn  = aws_iam_policy.policy[count.index].arn
}