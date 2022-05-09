# TERRAFORM + GITHUB = create a new repository

### How to use
~~~
module "github_repository"{
  source = "git::https://github.com/anotherbuginthecode/terraform.git//modules/github"
  
  github_token = "<YOUR GITHUB TOKEN>"
  repository_name = "example"
  description = "my first repository created with terraform module"
  visibility = "private" // or "public"
  branches = ["dev"] // main branch is automatically created
}
~~~
