# define lambda policy
resource "aws_iam_policy" "policy" {
  count = var.create_policy ? 1 : 0

  name  = var.policy_name
  description = var.policy_description

  policy = var.policy
}

resource "aws_iam_role_policy_attachment" "lambda_policy_basic" {
  role = var.role_name
  policy_arn  = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "lambda_policy_custom" {
  count = var.create_policy ? 1 : 0

  role = var.role_name
  policy_arn  = aws_iam_policy.policy[count.index].arn
}