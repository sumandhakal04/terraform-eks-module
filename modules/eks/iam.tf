data "aws_iam_policy_document" "assume_role_policy_for_root_account" {
  statement {
    sid = "EKSClusterAssumeRole"

    actions = ["sts:AssumeRole"]

    principals {
      type = "Service"

      identifiers = [
        "eks.amazonaws.com",
      ]
    }

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${var.account_id}:root"]
    }
  }
}

resource "aws_iam_role" "cluster_admin" {
  name                  = "${var.project}-eks-cluster-admin-${var.environment}"
  assume_role_policy    = data.aws_iam_policy_document.assume_role_policy_for_root_account.json
  force_detach_policies = true
}

resource "aws_iam_role_policy_attachment" "cluster_admin_AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.cluster_admin.name
}

resource "aws_iam_role_policy_attachment" "cluster_admin_AmazonEKSServicePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.cluster_admin.name
}
