# Настройка провайдера GitHub
provider "github" {
  token = "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"
}

# Ресурс для добавления соавтора
resource "github_repository_collaborator" "softservedata_collaborator" {
  repository = "github-terraform-task-OleksandrSawa"
  username   = "softservedata"
  permission = "push" # или "admin", в зависимости от требуемых прав доступа
}

# Ресурс для настройки защиты ветки main
resource "github_branch_protection" "main_protection" {
  repository = "github-terraform-task-OleksandrSawa"
  branch     = "main"

  enforce_admins = true
}

# Ресурс для настройки защиты ветки develop
resource "github_branch_protection" "develop_protection" {
  repository = "github-terraform-task-OleksandrSawa"
  branch     = "develop"

  required_pull_request_reviews {
    dismissal_restrictions {
      users = ["OleksandrSawa"]
    }
    dismiss_stale_reviews = false
    require_code_owner_reviews = true
    required_approving_review_count = 2
  }

  enforce_admins = true
}

# Ресурс для назначения владельца кода для файлов в ветке main
resource "github_branch_default_branch" "main_default_branch" {
  repository = "github-terraform-task-OleksandrSawa"
  branch     = "main"
}

# Ресурс для добавления шаблона запроса на слияние
resource "github_repository_file" "pull_request_template" {
  repository = "github-terraform-task-OleksandrSawa"
  file_path  = ".github/pull_request_template.md"
  content    = file("pull_request_template.md")
}

# Ресурс для добавления deploy key
resource "github_repository_deploy_key" "deploy_key" {
  repository = "github-terraform-task-OleksandrSawa"
  title      = "DEPLOY_KEY"
  key        = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBTcJlWp/yumhp1VVzaB4KV1RcEDv0vrgPLMSalEdVXy sawok@DESKTOP-TAGIO1T"
}

# Ресурс для создания Discord webhook
resource "github_repository_webhook" "discord_webhook" {
  repository = "github-terraform-task-OleksandrSawa"
  name       = "Discord"
  events     = ["pull_request"]
  configuration {
    url = "https://discord.com/api/webhooks/1136733262912438312/XWgFaVF7QRqfcVxcXisRepJkhZnI4_CGCrr5rNc0_jffICkuyjP2PbvONp9Vhdi64n4a/github"
    content_type = "json"
  }
}
