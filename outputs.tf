output "bastion_public_ip" {
  description = "Use this public address as the SSH ProxyJump host."
  value       = aws_instance.bastion.public_ip
}

output "resource_ids" {
  description = "Copy these IDs into the coursework report."
  value = {
    vpc_a       = aws_vpc.a.id
    vpc_b       = aws_vpc.b.id
    peering     = aws_vpc_peering_connection.a_to_b.id
    bastion     = aws_instance.bastion.id
    app_a       = aws_instance.app_a.id
    app_b       = aws_instance.app_b.id
    a_public_rt = aws_route_table.a_public.id
    a_private_rt = aws_route_table.a_private.id
    b_private_rt = aws_route_table.b_private.id
  }
}

output "ssh_config" {
  description = "Add this to ~/.ssh/config after downloading your ewb-lab private key."
  value = <<-EOT
    Host ewb-bastion
      HostName ${aws_instance.bastion.public_ip}
      User ec2-user
      IdentityFile ~/.ssh/ewb-lab.pem
      IdentitiesOnly yes

    Host ewb-app-a
      HostName 10.10.2.10
      User ec2-user
      IdentityFile ~/.ssh/ewb-lab.pem
      IdentitiesOnly yes
      ProxyJump ewb-bastion

    Host ewb-app-b
      HostName 10.20.1.10
      User ec2-user
      IdentityFile ~/.ssh/ewb-lab.pem
      IdentitiesOnly yes
      ProxyJump ewb-bastion
  EOT
}
