resource "aws_kms_key" "eks_kms_key" {
  enable_key_rotation = true
  tags = {
    Name = "${var.project}-eks-kms-key-${var.environment}"
  }
}

resource "aws_kms_alias" "kms_alias_eks" {
  name          = "alias/${var.project}-eks-kms-key-${var.environment}"
  target_key_id = aws_kms_key.eks_kms_key.id
}
