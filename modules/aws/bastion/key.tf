resource "aws_key_pair" "mykeypair" {
  count = var.path_to_public_key ? 1 : null
  key_name   = var.keypair_name
  public_key = file(var.path_to_public_key)
}