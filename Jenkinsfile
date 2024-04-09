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
        // stage('terraform init'){
        //     steps{
        //         dir('Backend'){
        //             bat "dir"
        //             bat "terraform init -upgrade"
        //         }
        //         // bat "cd Backend"
        //     }
        // }
        
        // stage('pushing image to ecr')
        // {
        //     steps{
        //         script{
        //             dir('Backend'){

        //                 bat """
        //                     terraform apply -target=module.ecr --auto-approve
        //                 """
                    
        //                 def HashValue = "initial value"
        //                 bat "git rev-parse  --short=6 HEAD~0 > gitHashValue.txt"
        //                 HashValue = readFile(file:'gitHashValue.txt').trim()
                    
        //                 bat """
        //                     cd code
        //                     aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 593242862402.dkr.ecr.us-east-1.amazonaws.com
        //                     powershell.exe -File .\\ecr-img-push.ps1 %AWS_REGION% %AWS_ACCOUNT_ID% %ECR_REPO_NAME% ${HashValue}
        //                     cd ..
        //                 """
        //             }
        //         }    
        //     }
                        
        // }       
        // stage('terraform plan'){
        //     steps{
        //         dir('Backend'){
        //             bat 'terraform plan'
        //         }
        //     }
        // }
        
        stage('terraform apply'){
            steps{
                script{
                    dir('Backend'){
                        bat "dir"
                        // bat 'terraform apply --auto-approve'
                        def api_url = bat(returnStdout: true, script: "terraform output api-gw-invoke_url")
                        bat "echo ${api_url}"
                        env.API_BASE_URL = "${api_url}"
                        bat "echo %API_BASE_URL%"
                    }
                }
            }
        }
    }
}
