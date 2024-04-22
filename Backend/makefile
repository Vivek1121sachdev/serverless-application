HashValue := $(shell git rev-parse --short=6 HEAD~0)
AWS_REGION ?= us-east-1
AWS_ACCOUNT_ID ?= 593242862402
ECR_REPO_NAME ?= serverless-app
init:
	terraform init -upgrade
ecr_repo:
	terraform apply -target=module.ecr --auto-approve
push_img:
	cd code && \
	aws ecr get-login-password --region $(AWS_REGION) | docker login --username AWS --password-stdin $(AWS_ACCOUNT_ID).dkr.ecr.$(AWS_REGION).amazonaws.com && \
	powershell.exe -ExecutionPolicy Bypass -File .\ecr-img-push.ps1 $(AWS_REGION) $(AWS_ACCOUNT_ID) $(ECR_REPO_NAME) "$(HashValue)" && \
	cd ..
plan:
	terraform plan

apply:
	terraform apply --auto-approve

#test