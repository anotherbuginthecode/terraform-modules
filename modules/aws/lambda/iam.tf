# define lambda role
resource "aws_iam_role" "lambda_exec" {
  name = replace("${var.function_name}_role","-","_")

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Sid    = ""
      Principal = {
        Service = "lambda.amazonaws.com"
      }
      }
    ]
  })
}

# define lambda policy
resource "aws_iam_policy" "policy" {
  count = var.create_policy ? 1 : 0
  name  = var.policy_name
  description = var.policy_description
  policy = var.policy
}

resource "aws_iam_role_policy_attachment" "lambda_policy_basic" {
  role = aws_iam_role.lambda_exec.arn
  policy_arn  = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "lambda_policy_custom" {
  count = var.create_policy ? 1 : 0
  role = aws_iam_role.lambda_exec.arn
  policy_arn  = aws_iam_policy.policy[count.index].arn
}