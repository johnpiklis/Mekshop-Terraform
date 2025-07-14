output "instance_ips" {
  value = [
    aws_instance.docker.public_ip,
    aws_instance.prometheus.public_ip,
    aws_instance.grafana.public_ip
  ]
}
output "instance_ids" {
  value = [
    aws_instance.docker.id,
    aws_instance.prometheus.id,
    aws_instance.grafana.id
  ]
}
output "security_group_id" {
  value = aws_security_group.common_sg.id
}
output "ami_id" {
  value = data.aws_ami.amazon_linux.id
}
