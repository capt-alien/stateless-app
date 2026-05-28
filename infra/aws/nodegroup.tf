resource "aws_eks_node_group" "stateless_app" {
  cluster_name    = aws_eks_cluster.stateless_app.name
  node_group_name = "${var.project_name}-nodes"
  node_role_arn   = aws_iam_role.eks_node_group.arn
  subnet_ids      = data.aws_subnets.default.ids

  ami_type       = "AL2023_ARM_64_STANDARD"
  instance_types = ["t4g.small"]

  scaling_config {
    desired_size = 1
    min_size     = 1
    max_size     = 1
  }

  tags = {
    Project = var.project_name
    Lab     = "true"
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_worker_node_policy,
    aws_iam_role_policy_attachment.eks_cni_policy,
    aws_iam_role_policy_attachment.eks_registry_policy
  ]
}