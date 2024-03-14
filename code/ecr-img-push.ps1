#!/bin/bash

# # AWS ECR details
# AWS_REGION=$1
# AWS_ACCOUNT_ID=$2
# ECR_REPO_NAME=$3

# # Docker image details
# DOCKER_IMAGE_NAME=$3
# DOCKER_IMAGE_TAG=$4

# # Build Docker image
# echo "Building Docker image..."
# docker build -t $DOCKER_IMAGE_NAME:$DOCKER_IMAGE_TAG .
# echo "Docker image built successfully."


# # docker build -t $DOCKER_IMAGE_NAME:$DOCKER_IMAGE_TAG .

# # Login to ECR
# aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com

# # Tag Docker image with ECR repository URI
# DOCKER_ECR_REPO_URI=$AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_REPO_NAME
# docker tag $DOCKER_IMAGE_NAME:$DOCKER_IMAGE_TAG $DOCKER_ECR_REPO_URI:$DOCKER_IMAGE_TAG



# # Push Docker image to ECR
# docker push $DOCKER_ECR_REPO_URI:$DOCKER_IMAGE_TAG

    
# param (
#     [string]$AWS_REGION=$args[0],
#     [string]$AWS_ACCOUNT_ID=$args[1],
#     [string]$ECR_REPO_NAME=$args[2],
#     # [string]$DOCKER_IMAGE_NAME=$args[2]
#     [string]$DOCKER_IMAGE_TAG=$args[3]
# )

# # Docker image details
# $DOCKER_IMAGE_NAME = $ECR_REPO_NAME

# # Build Docker image
# # docker build -t $DOCKER_IMAGE_NAME:$DOCKER_IMAGE_TAG .
# docker build -t ($DOCKER_IMAGE_NAME + ":" + $DOCKER_IMAGE_TAG) .

# # Login to ECR
# aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com

# # Tag Docker image with ECR repository URI
# # $DOCKER_ECR_REPO_URI = "$AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_REPO_NAME"
# # docker tag "${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG}" "${DOCKER_ECR_REPO_URI}:${DOCKER_IMAGE_TAG}"

# DOCKER_ECR_REPO_URI = "$AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_REPO_NAME"
# docker tag ($DOCKER_IMAGE_NAME + ":" + $DOCKER_IMAGE_TAG) ($DOCKER_ECR_REPO_URI + ":" + $DOCKER_IMAGE_TAG)

# # Push Docker image to ECR
# docker push "${DOCKER_ECR_REPO_URI}:${DOCKER_IMAGE_TAG}"


# set -e

param ( 
    [string]$AWS_REGION=$args[0],
    [string]$AWS_ACCOUNT_ID=$args[1],
    [string]$ECR_REPO_NAME=$args[2],
    [string]$gitHash
)

echo $gitHash
# Docker image details
$DOCKER_IMAGE_NAME = $ECR_REPO_NAME

# Build Docker image
docker build -t ($DOCKER_IMAGE_NAME + ":" + $gitHash) .

# # Login to ECR
aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com
# aws ecr get-login-password --region %AWS_REGION% | docker login --username AWS --password-stdin %AWS_ACCOUNT_ID%.dkr.ecr.%AWS_REGION%.amazonaws.com
# (Get-ECRLoginCommand).Password | docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.$AWS_PROFILE.amazonaws.com

# Obtain authentication token for Amazon ECR
# $token = aws ecr get-login-password --region $AWS_REGION

# Log in to Docker with the authentication token
# docker login -u AWS -p $token $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com

# Tag Docker image with ECR repository URI
$DOCKER_ECR_REPO_URI = "$AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_REPO_NAME"
docker tag ($DOCKER_IMAGE_NAME + ":" + $gitHash) ($DOCKER_ECR_REPO_URI + ":" + $gitHash)

# Push Docker image to ECR
docker push ($DOCKER_ECR_REPO_URI + ":" + $gitHash)
