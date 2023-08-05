provider "github" {
  token = var.pat
  owner = "Practical-DevOps-GitHub"
}

data "github_repository" "repo" {
  full_name = "Practical-DevOps-GitHub/github-terraform-task-OleksandrSawa"
}

# Объявляем переменную для токена
variable "pat" {
  type        = string
  description = "GitHub Personal Access Token"
  default     = "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"
}

# Ресурс для установки ветки по умолчанию
resource "github_branch_default" "default_branch" {
  repository = data.github_repository.repo.name
  branch     = "develop"
}

# Ресурс для добавления соавтора
resource "github_repository_collaborator" "softservedata_collaborator" {
  repository = data.github_repository.repo.name
  username   = "softservedata"
  permission = "push"
}

# Ресурс для настройки защиты ветки main
resource "github_branch_protection" "main_protection" {
  repository_id  = data.github_repository.repo.id
  pattern        = "main"
  enforce_admins = true
}

# Ресурс для настройки защиты ветки develop
resource "github_branch_protection" "develop_protection" {
  repository_id = data.github_repository.repo.id
  pattern       = "develop"

  required_pull_request_reviews {
    dismiss_stale_reviews           = false
    require_code_owner_reviews      = true
    required_approving_review_count = 2
  }

  enforce_admins = true
}

# Ресурс для добавления шаблона запроса на слияние
## resource "github_repository_file" "pull_request_template" {
 ##  repository = data.github_repository.repo.id
##   file       = ".github/pull_request_template.md"
##   content    = <<-EOT
## Describe your changes

## Issue ticket number and link

## Checklist before requesting a review
## - [ ] I have performed a self-review of my code
## - [ ] If it is a core feature, I have added thorough tests
## - [ ] Do we need to implement analytics?
## - [ ] Will this be part of a product update? If yes, please write one phrase about this update
 ##  EOT
 ##  overwrite_on_create  = true
## }
resource "github_repository_file" "pull_request_template" {
  content             = <<EOT
  ## Describe your changes
  ## Issue ticket number and link
  ## Checklist before requesting a review

[ ] I have performed a self-review of my code
[ ] If it is a core feature, I have added thorough tests
[ ] Do we need to implement analytics?
[ ] Will this be part of a product update? If yes, please write one phrase about this update
EOT
file                = ".github/pull_request_template.md"
repository          = data.github_repository.repo.id
overwrite_on_create = true
branch              = "main"
}

# Ресурс для добавления deploy key
resource "github_repository_deploy_key" "deploy_key" {
  repository = data.github_repository.repo.name
  title      = "DEPLOY_KEY"
  key        = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDtlG5dZ9LlTdPSNeP3Z4HWS+B0qpDEuS4YD2/GAl9r2ZHFL8MnBQ6NTPI5qRvcoWW+c23Nf0Vg0/7iPzunG5t/4a3g9wHg6Ng//DpUxyJ6B677QFmVcKzC0kGZx+2yHt5HTKfXIshm0RYPvq4ELBlW2QBczZDNBgJ0nvptMWoSDVPncJ7G5R92yrQ7H6NZXzzBQ6VdS48AgwiLatayOCCKF9zV0h6FcgkpYyuUYWWMGtqGFKRhmQDIACICIigjbdOt2TXs4Myi+P9UKEzL1zbImdNW80N8y9W5ROU+exHpLdNEDU1QgVEQ6Si4+9aKGhCcPyb4Q/OdUmkYJ8d6J7l1"
}

# Ресурс для создания Discord webhook
resource "github_repository_webhook" "discord_webhook" {
  repository = data.github_repository.repo.id
  events     = ["pull_request"]
  configuration {
    url          = "https://discord.com/api/webhooks/1136733262912438312/XWgFaVF7QRqfcVxcXisRepJkhZnI4_CGCrr5rNc0_jffICkuyjP2PbvONp9Vhdi64n4a/github"
    content_type = "json"
  }
}
