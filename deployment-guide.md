**Deployment Guide**

This guide describes how to run the E-CommerceStore project locally with Docker Compose, and how to prepare and provision basic AWS infrastructure (ECR and ECS cluster) using Terraform so you can deploy containers to AWS.

Prerequisites
- Docker and Docker Compose installed
- Terraform v1.4+ installed
- AWS CLI configured with credentials (for pushing images and Terraform)

Local development (Docker Compose)
1. Build and run all services locally:

```bash
docker-compose build
docker-compose up --remove-orphans
```

2. Services and ports (mapped locally):
- Frontend: http://localhost:3000
- Cart service: http://localhost:3001
- Order service: http://localhost:3002
- Product service: http://localhost:3003
- User service: http://localhost:3004

3. To stop and remove containers:

```bash
docker-compose down
```

Preparing to deploy to AWS (ECR + ECS)
1. Build images and tag for ECR (example uses AWS_ACCOUNT_ID and AWS_REGION env vars):

```bash
export AWS_ACCOUNT_ID=130961287799
export AWS_REGION=ap-south-1
# build images locally
docker-compose build

# tag images (example for cart-service)
docker tag ecom_cart-service:latest $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/ecom-cart-service:latest

docker tag ecom_order-service:latest $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/ecom-cart-service:latest

docker tag ecom_product-service:latest $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/ecom-cart-service:latest

docker tag ecom_user-service:latest $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/ecom-cart-service:latest

docker tag ecom_frontend-service:latest $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/ecom-cart-service:latest
# repeat for other images (order, product, user, frontend)
```

2. Create ECR repos with Terraform and push images
- Initialize Terraform in `infra/` folder:

```bash
cd infra
terraform init
terraform apply -var="aws_region=$AWS_REGION" -var="aws_account_id=$AWS_ACCOUNT_ID"
```

- Authenticate Docker to ECR and push images:

```bash
aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com

docker tag ecom_cart-service:latest $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/ecom-cart-service:latest
docker push $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/ecom-cart-service:latest
# repeat tag & push for other images
```

3. Deploy containers to ECS
- Terraform in `infra/` currently provisions ECR repos and an ECS cluster. You can extend it with task definitions and services, or use a pipeline (CodeDeploy, GitHub Actions) to register task definitions and update services.

Security and environment variables
- Do not store secrets in Terraform or in source code. Use AWS Secrets Manager or SSM Parameter Store and reference them from ECS task definitions.

Notes and next steps
- The `infra/` Terraform is a minimal starting point that creates ECR repos and an ECS cluster. For production, add VPC, ALB, RDS (for persistent DB), IAM roles, and autoscaling configuration.
- If you prefer Kubernetes, replace ECS resources with EKS modules and provide Kubernetes manifests or Helm charts.

Contact
If you want, I can extend Terraform to create task definitions, services, load balancers, or add CI/CD pipeline examples (GitHub Actions). Which would you like next?
