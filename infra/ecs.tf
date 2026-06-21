resource "aws_ecs_cluster" "cluster" {
  name = "ecom-cluster"
}

output "ecs_cluster_name" {
  value = aws_ecs_cluster.cluster.name
}
resource "aws_ecs_cluster" "this" {
  name = "ecom-cluster"
}

output "ecs_cluster_name" {
  value = aws_ecs_cluster.this.name
}
