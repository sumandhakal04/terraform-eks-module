locals {
  maps_roles_default = [
    {
      rolearn  = aws_iam_role.cluster_admin.arn
      username = aws_iam_role.cluster_admin.name
      groups   = ["system:masters"]
    }
  ]
  map_roles = concat(local.maps_roles_default, var.map_roles)
}

