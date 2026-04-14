# Terraform AWS 3-Tier VPC Architecture (High Availability, Production-Style)

## Overview

This repository demonstrates a production-style, highly available 3-tier architecture on AWS using Terraform. The design emphasizes modularity, security, cost-awareness, and alignment with real-world infrastructure patterns.

The goal of this project is not just to deploy infrastructure, but to demonstrate the reasoning behind architectural decisions and the tradeoffs involved.

---

## Architecture

High-level request flow:

Internet → Application Load Balancer → EC2 Auto Scaling Group → Amazon RDS

Core characteristics:

- Region: us-east-1
- 3 Availability Zones for high availability
- 9 subnets:
  - 3 Public (ALB)
  - 3 Private Application
  - 3 Private Database

---

## Architecture Diagram

[!Architecture](./assets/three-tier-vpc-architecture.png)
---

## Key Design Decisions (The “Why”)

### 1. Three Availability Zones
Chosen to demonstrate true high availability and fault tolerance beyond basic two-AZ designs.

### 2. NAT-less Architecture (Default)
NAT Gateway is disabled by default to reduce cost. Instead, VPC Interface Endpoints are used to allow SSM-based management without internet access.

Tradeoff:
- Lower cost
- More controlled egress
- Requires alternative strategies for package installation

### 3. Private Application Tier
EC2 instances are not publicly accessible and are managed exclusively via AWS Systems Manager Session Manager.

Why:
- Eliminates SSH exposure
- Aligns with modern security best practices

### 4. Layered Security Groups
Traffic is strictly controlled:

- ALB accepts traffic from the internet
- EC2 accepts traffic only from ALB
- RDS accepts traffic only from EC2

This enforces least privilege between tiers.

### 5. Modular Terraform Design
Each component is separated into reusable modules:

- vpc
- subnets
- alb
- asg
- rds
- security-groups
- endpoints
- secrets

Why:
- Improves maintainability
- Mirrors real-world infrastructure repositories
- Enables reuse across environments

### 6. Secrets Management
Database credentials are stored in AWS Secrets Manager instead of being hardcoded.

Why:
- Prevents credential leakage in source control
- Aligns with production security practices

---

## Project Structure

```bash
modules/
  vpc/
  subnets/
  alb/
  asg/
  rds/
  security-groups/
  endpoints/
  secrets/

environments/
  dev/
  prod/

global/
  backend-bootstrap/
```
---

## Deployment Steps

```bash
1. Clone the repository:

   git clone <repo-url>
   cd terraform-aws-3tier-vpc-ha

2. Initialize backend (if not already created):

   cd global/backend-bootstrap
   terraform init
   terraform apply

3. Deploy environment:

   cd ../../environments/dev
   terraform init
   terraform plan
   terraform apply

4. Access the application:

   Use the ALB DNS name output by Terraform.
```

---

## Teardown Steps

```bash
To destroy infrastructure:

cd environments/dev
terraform destroy

Note:
Ensure RDS is fully deleted before re-running deployments to avoid naming conflicts.

```

---

## Cost Considerations

- NAT Gateway is disabled by default to avoid ~$30/month cost
- EC2 instances use t2.micro (free tier eligible where applicable)
- RDS uses db.t3.micro with minimal storage
- VPC Endpoints incur minimal cost compared to NAT

Key tradeoff:
- NAT-less design reduces cost but limits outbound internet access

---

## Security Considerations

- No public EC2 instances
- No SSH access (SSM only)
- Database is not publicly accessible
- Security groups enforce strict tier boundaries
- Secrets are stored in AWS Secrets Manager
- IAM roles are used instead of static credentials
- Remote Terraform state stored securely in S3 with DynamoDB locking

---

## CI/CD

GitHub Actions pipeline performs:

- terraform fmt (format validation)
- terraform validate
- terraform plan

Authentication to AWS is handled via OIDC, eliminating the need for long-lived credentials.

---

## Future Improvements

- Add HTTPS with ACM and CloudFront
- Implement blue/green deployments
- Introduce observability (CloudWatch dashboards and alarms)
- Add secret rotation for database credentials
- Expand CI/CD to include controlled apply workflows

---

## Author

Heath Smith
AWS Certified Solutions Architect – Associate