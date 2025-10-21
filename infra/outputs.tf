output "aws_region" {
  value = var.aws_region
}

# outputs.tf
# output "alb_dns_name" {
#   description = "DNS name of the ALB"
#   value       = aws_lb.main.dns_name
# }

output "ecr_repository_url" {
  description = "URL of the ECR repository"
  value       = data.aws_ecr_repository.repo.repository_url
}
