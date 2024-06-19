variable "api_token" {
  description = "Vercel API Token"
}

terraform {
  required_providers {
    vercel = {
      source  = "vercel/vercel"
      version = "~> 1.11.1"
    }
  }
}

provider "vercel" {
  api_token = var.api_token
}

resource "vercel_project" "vercel-terraform" {
  name      = "vercel-terraform"
  framework = "nextjs"
  git_repository = {
    type = "github"
    repo = "tomekz/vercel-terraform"
  }
}

data "vercel_project_directory" "vercel-terraform" {
  path = "."
}

resource "vercel_deployment" "vercel-terraform" {
  project_id  = vercel_project.vercel-terraform.id
  files       = data.vercel_project_directory.vercel-terraform.files
  path_prefix = "."
  production  = true
  project_settings = {
    build_command = "if [ '$git rev-parse --abbrev-ref HEAD' == 'master' ]; then exit 1; else exit 0; fi" # only build on master branch
  }
}
