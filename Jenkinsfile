pipeline{
    
    agent any
    environment {
        AWS_REGION = "us-east-1"
        AWS_ACCOUNT_ID = "593242862402"
        ECR_REPO_NAME = "serverless-app"
    }
    options {
        ansiColor('xterm')
    }
    stages{
        stage('terraform init'){
            steps{
                dir('Backend'){
                    bat 'make --version'
                    bat "make init"
                }
            }
        }
        
        stage('pushing image to ecr')
        {
            steps{
                script{
                    dir('Backend'){
                        bat "make push_img AWS_REGION=us-east-1 AWS_ACCOUNT_ID=593242862402 ECR_REPO_NAME=serverless-app"
                    }
                }    
            }
                        
        }       
        stage('terraform plan'){
            steps{
                dir('Backend'){
                    bat "make plan"
                }
            }
        }
        
        stage('terraform apply'){
            steps{
                script{
                    dir('Backend'){
                        bat "make apply"
                    }
                }
            }
        }
    }
}