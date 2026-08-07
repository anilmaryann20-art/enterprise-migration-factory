pipeline {

    agent any

    environment {
        ACR_NAME         = "acremfdev001"
        ACR_LOGIN_SERVER = "acremfdev001.azurecr.io"
        IMAGE_NAME       = "migration-dashboard"
        AZURE_SUBSCRIPTION_ID = "d56165bf-3a47-49f2-9975-a463b374513d"
        AZURE_TENANT_ID       = "5b2318b1-a509-42f3-85b9-15b33b0d1ab7"
    }


    stages {


        stage('Checkout Code') {

            steps {

                echo "Checking out latest code from GitHub"

                checkout scm

            }
        }



        stage('Azure Authentication') {

            steps {

                echo "Authenticating Jenkins with Azure"


                withCredentials([

                    usernamePassword(
                        credentialsId: 'azure-service-principal',
                        usernameVariable: 'AZURE_CLIENT_ID',
                        passwordVariable: 'AZURE_CLIENT_SECRET'
                    )

                ]) {


                    bat """

                    az login --service-principal ^
                    -u %AZURE_CLIENT_ID% ^
                    -p %AZURE_CLIENT_SECRET% ^
                    --tenant ${AZURE_TENANT_ID}


                    az account set --subscription ${AZURE_SUBSCRIPTION_ID}

                    az account show

                    """

                }

            }

        }




        stage('Terraform Validate') {

            steps {

                echo "Initializing and validating Terraform"


                dir('terraform') {

                    bat 'terraform init'

                    bat 'terraform validate'

                }

            }

        }




        stage('Terraform Plan') {

            steps {

                echo "Planning Terraform infrastructure"


                dir('terraform') {

                    bat 'terraform plan'

                }

            }

        }




        stage('Terraform Apply') {

            steps {

                echo "Applying Terraform infrastructure"


                dir('terraform') {

                    bat 'terraform apply -auto-approve'

                }

            }

        }




        stage('Docker Build') {

            steps {

                echo "Building Docker Image"


                dir('app') {

                    bat "docker build -t ${IMAGE_NAME}:latest ."

                }

            }

        }




        stage('Login and Push to ACR') {

            steps {


                echo "Logging into Azure Container Registry"


                withCredentials([

                    usernamePassword(
                        credentialsId: 'azure-acr-creds',
                        usernameVariable: 'ACR_USER',
                        passwordVariable: 'ACR_PASS'
                    )

                ]) {


                    dir('app') {


                        bat """

                        docker login ${ACR_LOGIN_SERVER} ^
                        -u %ACR_USER% ^
                        -p %ACR_PASS%


                        docker tag ${IMAGE_NAME}:latest ${ACR_LOGIN_SERVER}/${IMAGE_NAME}:latest


                        docker push ${ACR_LOGIN_SERVER}/${IMAGE_NAME}:latest

                        """

                    }

                }

            }

        }




        stage('Deploy to Azure VM') {


            steps {


                echo "Deploying application to Azure VM"



                withCredentials([


                    usernamePassword(
                        credentialsId: 'azure-vm-creds',
                        usernameVariable: 'VM_USER',
                        passwordVariable: 'VM_PASS'
                    ),


                    usernamePassword(
                        credentialsId: 'azure-acr-creds',
                        usernameVariable: 'ACR_USER',
                        passwordVariable: 'ACR_PASS'
                    )


                ]) {



                    script {


                        def remote = [

                            name: 'azure-vm',

                            host: '20.198.84.41',

                            user: VM_USER,

                            password: VM_PASS,

                            allowAnyHosts: true

                        ]



                        sshCommand remote: remote, command: """


                        echo ${ACR_PASS} | docker login ${ACR_LOGIN_SERVER} -u ${ACR_USER} --password-stdin



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

        }





        stage('Health Check') {


            steps {


                echo "Checking application health"


                bat "curl http://20.198.84.41"


            }

        }


    }




    post {


        success {

            echo "Pipeline completed successfully!"

        }


        failure {

            echo "Pipeline failed. Please check Jenkins console output."

        }


    }

}