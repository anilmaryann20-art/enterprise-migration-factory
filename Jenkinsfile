pipeline {

    agent any


    environment {

        ACR_NAME         = "acremfdev001"
        ACR_LOGIN_SERVER = "acremfdev001.azurecr.io"
        IMAGE_NAME       = "migration-dashboard"

        //TF_VAR_FILE = "C:\\ProgramData\\Jenkins\\.jenkins\\terraform-secrets\\dev.tfvars"

    }



    stages {

        stage('Detect Changes') {

            steps {

                script {

                    def previousCommit = bat(
                        script: '@echo %GIT_PREVIOUS_COMMIT%',
                        returnStdout: true
                    ).trim()

                    def currentCommit = bat(
                        script: '@echo %GIT_COMMIT%',
                        returnStdout: true
                    ).trim()

                    echo "Previous commit: ${previousCommit}"
                    echo "Current commit: ${currentCommit}"

                    if (!previousCommit ||
                        previousCommit == '%GIT_PREVIOUS_COMMIT%') {

                        env.TERRAFORM_CHANGED = 'true'
                        env.APP_CHANGED = 'true'

                        echo "No previous Jenkins commit found."
                        echo "Running Terraform and Application stages."

                    } else {

                        def changedFiles = bat(
                            script: """
                            @git diff --name-only ${previousCommit} ${currentCommit}
                            """,
                            returnStdout: true
                        ).trim()

                        echo "Changed files:"
                        echo changedFiles

                        env.TERRAFORM_CHANGED = 'false'
                        env.APP_CHANGED = 'false'

                        changedFiles.split('\\r?\\n').each { file ->

                            if (file.startsWith('terraform/') ||
                                file == 'Jenkinsfile') {

                                env.TERRAFORM_CHANGED = 'true'
                            }

                            if (file.startsWith('app/')) {
                                env.APP_CHANGED = 'true'
                            }
                            }
                        }

                        echo "Terraform changed: ${env.TERRAFORM_CHANGED}"
                        echo "Application changed: ${env.APP_CHANGED}"
                    }
                }
            }
        }

        stage('Azure Authentication') {
            when {
                expression {
                    env.TERRAFORM_CHANGED == 'true' ||
                        env.APP_CHANGED == 'true'
                    }
                }

            steps {


                echo "Authenticating Jenkins with Azure"


                withCredentials([

                    azureServicePrincipal(

                        credentialsId: 'azure-service-principal',

                        subscriptionIdVariable: 'AZURE_SUBSCRIPTION_ID',

                        clientIdVariable: 'AZURE_CLIENT_ID',

                        clientSecretVariable: 'AZURE_CLIENT_SECRET',

                        tenantIdVariable: 'AZURE_TENANT_ID'

                    )

                ]) {


                    bat """

                    echo Logging into Azure


                    az login --service-principal ^
                    -u %AZURE_CLIENT_ID% ^
                    -p %AZURE_CLIENT_SECRET% ^
                    --tenant %AZURE_TENANT_ID%



                    az account set ^
                    --subscription %AZURE_SUBSCRIPTION_ID%



                    az account show



                    """


                }


            }


        }

        stage('Fetch Secrets from Key Vault') {
    when {
        expression {
            env.TERRAFORM_CHANGED == 'true' ||
            env.APP_CHANGED == 'true'
        }
    }
            steps {
                script {
                    echo "Fetching secrets from Azure Key Vault"

                    // Fetch ACR credentials
                    env.ACR_USERNAME = bat(
                        script: '@az keyvault secret show --vault-name kv-emf-dev-001 --name acr-username --query value -o tsv',
                        returnStdout: true
                    ).trim()

                    env.ACR_PASSWORD = bat(
                        script: '@az keyvault secret show --vault-name kv-emf-dev-001 --name acr-password --query value -o tsv',
                        returnStdout: true
                    ).trim()

                    env.VM_USERNAME = bat(
                        script: '@az keyvault secret show --vault-name kv-emf-dev-001 --name vm-username --query value -o tsv',
                        returnStdout: true
                    ).trim()

                    env.VM_PASSWORD = bat(
                        script: '@az keyvault secret show --vault-name kv-emf-dev-001 --name vm-password --query value -o tsv',
                        returnStdout: true
                    ).trim()

                    echo "Secrets fetched successfully from Key Vault"
                    echo "ACR Username: ${env.ACR_USERNAME}"
                }
            }
        }

        stage('Terraform Validate') {
            
            when {
                expression {
                    env.TERRAFORM_CHANGED == 'true'
                }
            }

            steps {


                echo "Terraform validation"



                dir('terraform') {


                    bat """

                    terraform init

                    terraform validate

                    """


                }


            }


        }


       stage('Terraform Plan') {

        when {
            expression {
                env.TERRAFORM_CHANGED == 'true'
            }
        }
        
        steps {

            echo "Terraform Plan"

            withCredentials([
                file(
                    credentialsId: 'terraform-dev-tfvars',
                    variable: 'TFVARS_FILE'
                )
            ]) {

            dir('terraform') {

                bat """
                terraform plan ^
                -input=false ^
                -var-file="%TFVARS_FILE%"
                """

            }

        }

    }

}



        stage('Terraform Apply') {

            when {
                expression {
                    env.TERRAFORM_CHANGED == 'true'
                }
            }

            steps {

                echo "Terraform Apply"

                withCredentials([
                    file(
                        credentialsId: 'terraform-dev-tfvars',
                        variable: 'TFVARS_FILE'
                    )
                ]) {

                    dir('terraform') {

                        bat """
                        terraform apply ^
                        -auto-approve ^
                        -input=false ^
                        -var-file="%TFVARS_FILE%"
                        """

                    }

                }

            }

        }


        stage('Docker Build') {
           

            when {
                expression {
                    env.APP_CHANGED == 'true'
                }
            }

            steps {


                echo "Building Docker Image"



                dir('app') {


                    bat """

                    docker build ^
                    -t %IMAGE_NAME%:latest .

                    """


                }


            }


        }


        stage('Login and Push to ACR') {
            when {
                expression {
                    env.APP_CHANGED == 'true'
                }
            }
            steps {
                echo "Push Docker image to Azure Container Registry"
                bat """
                docker login %ACR_LOGIN_SERVER% ^
                -u %ACR_USERNAME% ^
                -p %ACR_PASSWORD%

                docker tag ^
                %IMAGE_NAME%:latest ^
                %ACR_LOGIN_SERVER%/%IMAGE_NAME%:latest

                docker push ^
                %ACR_LOGIN_SERVER%/%IMAGE_NAME%:latest
                """
            }
        }

        stage('Deploy to Azure VM') {
            when {
                expression {
                    env.APP_CHANGED == 'true'
                }
            }
            steps {
                echo "Deploying application on Azure VM"
                script {
                    def remote = [
                        name: 'azure-vm',
                        host: '20.198.84.41',
                        user: env.VM_USERNAME,
                        password: env.VM_PASSWORD,
                        allowAnyHosts: true
                    ]

                    sshCommand remote: remote, command: """
                    echo ${env.ACR_PASSWORD} | docker login ${ACR_LOGIN_SERVER} \
                    -u ${env.ACR_USERNAME} \
                    --password-stdin

                    docker pull ${ACR_LOGIN_SERVER}/${IMAGE_NAME}:latest

                    docker stop migration-dashboard || true
                    docker rm -f migration-dashboard || true

                    docker run -d \
                    --restart unless-stopped \
                    -p 80:3000 \
                    --name migration-dashboard \
                    ${ACR_LOGIN_SERVER}/${IMAGE_NAME}:latest
                    """
                }
            }
        }

        stage('Health Check') {

            when {
                expression {
                    env.APP_CHANGED == 'true'
                }
            }
            steps {


                echo "Checking application health"



                bat """

                curl http://20.198.84.41


                """


            }


        }

    }

    post {



        success {


            echo "Pipeline completed successfully"

        }



        failure {


            echo "Pipeline failed. Check console output."

        }


    }


}