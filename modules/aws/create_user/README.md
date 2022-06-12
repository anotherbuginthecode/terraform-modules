# TERRAFORM + AWS = create a new programmatic user

**Keybase**: https://keybase.io/

### How to use
~~~
provider "aws" {}

module "create_user" {
  source = "git::https://github.com/anotherbuginthecode/terraform//modules/aws/create_user"

  user = "testuser"
  force_destroy = false
  keybase_user = "<YOUR-KEYBASE-NAME>"
  policies = [
        {
            "name": "test_policy",
            "policy":{
            "Version": "2012-10-17",
            "Statement": [
                {
                "Action": [
                    "ec2:Describe*"
                ],
                "Effect": "Allow",
                "Resource": "*"
                }
            ]
            }
        }
    ]
}

output "access_key_id" {
  value = module.create_user.access_key_id
}

output "secret" {
  value = module.create_user.secret
}
~~~