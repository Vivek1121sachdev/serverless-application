HashValue := $(shell git rev-parse --short=6 HEAD~0)
AWS_REGION ?= NOT_DEFINED
AWS_ACCOUNT_ID ?= NOT_DEFINED
ECR_REPO_NAME ?= NOT_DEFINED

init:
	terraform init -upgrade

push_img:
	terraform apply -target=module.ecr --auto-approve
	cd code && \
	aws ecr get-login-password --region $(AWS_REGION) | docker login --username AWS --password-stdin 593242862402.dkr.ecr.us-east-1.amazonaws.com && \
	powershell.exe -ExecutionPolicy Bypass -File .\ecr-img-push.ps1 $(AWS_REGION) $(AWS_ACCOUNT_ID) $(ECR_REPO_NAME) "$(HashValue)" && \
	cd ..

plan:
	terraform plan

apply:
	terraform apply --auto-approve

Dependencies: init plan apply