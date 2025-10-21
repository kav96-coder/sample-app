output "cluster_name" {
  value = aws_eks_cluster.this.name
}

output "cluster_endpoint" {
  value = aws_eks_cluster.this.endpoint
}

output "cluster_certificate_authority" {
  value = aws_eks_cluster.this.certificate_authority[0].data
}

output "cluster_arn" {
  value = aws_eks_cluster.this.arn
}

output "oidc_provider_arn" {
  value = var.create_oidc && length(aws_iam_openid_connect_provider.this) > 0 ? aws_iam_openid_connect_provider.this[0].arn : ""
}

output "node_group_name" {
  value = aws_eks_node_group.this.node_group_name
}

output "node_role_arn" {
  value = aws_iam_role.node_role.arn
}

output "alb_irsa_role_arn" {
  value = var.create_alb_irsa && length(aws_iam_role.alb_irsa_role) > 0 ? aws_iam_role.alb_irsa_role[0].arn : ""
}

output "jenkins_irsa_role_arn" {
  value = var.create_jenkins_irsa && length(aws_iam_role.jenkins_irsa_role) > 0 ? aws_iam_role.jenkins_irsa_role[0].arn : ""
}
