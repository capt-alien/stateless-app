resource "aws_eks_cluster" "stateless_app" {
  name     = "${var.project_name}-eks"
  role_arn = aws_iam_role.eks_cluster.arn

  vpc_config {
    subnet_ids = data.aws_subnets.default.ids
  }

  tags = {
    Project = var.project_name
    Lab     = "true"
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_policy
  ]
}