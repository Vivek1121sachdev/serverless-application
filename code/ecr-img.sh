#!/bin/bash

# AWS ECR details
AWS_REGION="us-east-1"
AWS_ACCOUNT_ID="593242862402"
ECR_REPO_NAME="python-deployment"

# Docker image details
DOCKER_IMAGE_NAME="python-deployment"
DOCKER_IMAGE_TAG="latest"

# Build Docker image
docker build -t $DOCKER_IMAGE_NAME:$DOCKER_IMAGE_TAG .

# Login to ECR
aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com

# Tag Docker image with ECR repository URI
DOCKER_ECR_REPO_URI=$AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_REPO_NAME
docker tag $DOCKER_IMAGE_NAME:$DOCKER_IMAGE_TAG $DOCKER_ECR_REPO_URI:$DOCKER_IMAGE_TAG

# Push Docker image to ECR
docker push $DOCKER_ECR_REPO_URI:$DOCKER_IMAGE_TAG

# Optionally, you can clean up local Docker images if needed
# docker rmi $DOCKER_IMAGE_NAME:$DOCKER_IMAGE_TAG
# docker rmi $DOCKER_ECR_REPO_URI:$DOCKER_IMAGE_TAG
