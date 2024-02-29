#!/bin/bash

# Set variables
AWS_REGION="us-east-1"
AWS_ACCOUNT_ID="593242862402"
REPOSITORY_NAME="python-deployment"
IMAGE_TAG="latest"

# Delete the image without confirmation
aws ecr batch-delete-image \
    --region $AWS_REGION \
    --repository-name $REPOSITORY_NAME \
    --image-ids imageTag=$IMAGE_TAG

echo "Image $REPOSITORY_NAME:$IMAGE_TAG deleted successfully."
