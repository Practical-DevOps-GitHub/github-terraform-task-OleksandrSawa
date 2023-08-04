# Настройка провайдера GitHub
provider "github" {
  token = "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"
}
resource "github_repository" "repo" {
  name   = "github-terraform-task-OleksandrSawa"
}
# Ресурс для установки ветки по умолчанию
resource "github_branch_default" "default_branch" {
  repository = github_repository.repo.name
  branch     = "main"
}
# Ресурс для добавления соавтора
resource "github_repository_collaborator" "softservedata_collaborator" {
  repository = github_repository.repo.name
  username   = "softservedata"
  permission = "push" # или "admin", в зависимости от требуемых прав доступа
}

# Ресурс для настройки защиты ветки main
resource "github_branch_protection" "main_protection" {
  repository_id = github_repository.repo.id
  pattern    = "main"
  enforce_admins = true
}

# Ресурс для настройки защиты ветки develop
resource "github_branch_protection" "develop_protection" {
  repository_id = github_repository.repo.id
  pattern       = "develop"

  required_pull_request_reviews {
    dismiss_stale_reviews           = false
    require_code_owner_reviews      = true
    required_approving_review_count = 2
  }

  enforce_admins = true
}


# Ресурс для добавления шаблона запроса на слияние
resource "github_repository_file" "pull_request_template" {
  repository = github_repository.repo.id
  file       = ".github/pull_request_template.md"
  content    = <<-EOT
## Describe your changes

## Issue ticket number and link

## Checklist before requesting a review
- [ ] I have performed a self-review of my code
- [ ] If it is a core feature, I have added thorough tests
- [ ] Do we need to implement analytics?
- [ ] Will this be part of a product update? If yes, please write one phrase about this update
  EOT
}

#rесурс для добавления deploy key
resource "github_repository_deploy_key" "deploy_key" {
  repository = github_repository.repo.name
  title      = "DEPLOY_KEY"
  key        = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBTcJlWp/yumhp1VVzaB4KV1RcEDv0vrgPLMSalEdVXy sawok@DESKTOP-TAGIO1T"
}
# Ресурс для создания Discord webhook
resource "github_repository_webhook" "discord_webhook" {
  repository = github_repository.repo.id
  events     = ["pull_request"]
  configuration {
    url = "https://discord.com/api/webhooks/1136733262912438312/XWgFaVF7QRqfcVxcXisRepJkhZnI4_CGCrr5rNc0_jffICkuyjP2PbvONp9Vhdi64n4a/github"
    content_type = "json"
  }
}
