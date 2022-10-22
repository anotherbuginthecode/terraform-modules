resource "aws_ecr_repository" "ecr_repository" {
  name                 = "${var.name}"
  image_tag_mutability = "${var.image_tag_mutability}"

  image_scanning_configuration {
    scan_on_push = "${var.scan_on_push}"
  }

  tags = merge( 
    var.tags
  )
}

resource "aws_ecr_lifecycle_policy" "ecr_policy" {
  repository = aws_ecr_repository.ecr_repository.name
  policy = "${var.policy}"
}


