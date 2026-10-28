# AWS VPC Peering Project

Completed AWS networking lab demonstrating private connectivity between two non-overlapping VPCs. The implementation uses a public bastion in VPC A, private application servers in both VPCs, VPC peering, explicit route tables, and scoped security-group rules.

The complete evidence report is available at [SatyamKushwaha_EWB_VPC_Peering.pdf](output/pdf/SatyamKushwaha_EWB_VPC_Peering.pdf).

## What is created

| Resource | Address / purpose |
| --- | --- |
| `ewb-vpc-a` | `10.10.0.0/16` |
| `ewb-a-public` | `10.10.1.0/24`; bastion `10.10.1.10` |
| `ewb-a-private` | `10.10.2.0/24`; App-A `10.10.2.10` |
| `ewb-vpc-b` | `10.20.0.0/16` |
| `ewb-b-private` | `10.20.1.0/24`; App-B `10.20.1.10` |

App-A and App-B receive no public IPv4 address. VPC B has no internet gateway. The bastion is the only internet-reachable instance.

## Infrastructure as code

The Terraform files in this repository reproduce the architecture. They are included as implementation documentation and should be applied only in a clean AWS account or after the existing manual lab resources have been removed.

### Prerequisites

- Terraform 1.5 or later
- AWS CLI credentials with permissions for EC2 and VPC resources
- An existing EC2 key pair in the selected Region (create `ewb-lab` in the EC2 console and retain the `.pem` file locally)
- Your current public IPv4 address in CIDR form, for example `203.0.113.25/32`

### Deploy

1. Copy the example variables file and enter your own values:

   ```powershell
   Copy-Item terraform.tfvars.example terraform.tfvars
   ```

2. Edit `terraform.tfvars`, then run:

   ```powershell
   terraform init
   terraform fmt -check
   terraform validate
   terraform plan
   terraform apply
   ```

3. Read the SSH commands displayed in the Terraform outputs. Add the bastion public IP to your local SSH configuration, then use ProxyJump to access App-A and App-B.

## Verification sequence

Terraform creates the peering routes immediately, so capture the workbook's *pre-peering* ping failure manually before applying the peering and route resources (or use a targeted initial deployment). After full deployment:

```bash
# From App-A
ping -c 4 10.20.1.10

# From App-B
ping -c 4 10.10.2.10
```

Both should report four replies. To demonstrate the controlled failure, temporarily remove the App-B ICMP ingress rule with the AWS console, rerun the App-A ping, restore that exact rule, and rerun the test.

## Cleanup

The current lab was created manually through the AWS Console. Clean it up from the Console after submission: terminate the instances, delete the peering routes and connection, delete the security groups and route tables, delete subnets, detach and delete the internet gateway, then delete both VPCs.

If the Terraform implementation was used for a separate deployment, use:

When screenshots and report evidence are saved:

```powershell
terraform destroy
```

Terraform removes the lab instances before their VPC dependencies. It does not remove the EC2 key pair because that is supplied by you.

## Security choices

- Bastion SSH is limited to `admin_cidr`, not open to the Internet.
- App SSH is limited to the bastion private IP (`10.10.1.10/32`).
- ICMP echo requests are limited to the peer application host only.
- No private subnet has a default internet route or public IPv4 allocation.

