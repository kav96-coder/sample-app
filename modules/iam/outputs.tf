
output "jenkins_role_name" {
  value = aws_iam_role.this.name
}

output "jenkins_role_arn" {
  value = aws_iam_role.this.arn
}

output "jenkins_instance_profile" {
  value = aws_iam_instance_profile.this.name
}

