#!/bin/bash

# AWS ECR details
AWS_REGION=$1
AWS_ACCOUNT_ID=$2
ECR_REPO_NAME=$3

# Docker image details
DOCKER_IMAGE_NAME=$3
DOCKER_IMAGE_TAG=$4

# Build Docker image
docker build -t $DOCKER_IMAGE_NAME$:$DOCKER_IMAGE_TAG .

# Login to ECR
aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com

# Tag Docker image with ECR repository URI
DOCKER_ECR_REPO_URI=$AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_REPO_NAME
docker tag $DOCKER_IMAGE_NAME:$DOCKER_IMAGE_TAG $DOCKER_ECR_REPO_URI:$DOCKER_IMAGE_TAG

# Push Docker image to ECR
docker push $DOCKER_ECR_REPO_URI:$DOCKER_IMAGE_TAG
