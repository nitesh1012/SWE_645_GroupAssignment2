pipeline {
    agent any
    tools {
        maven 'Maven3.9.9' // Adjust to match your Maven setup
    }
    environment {
        DOCKERHUB_CREDENTIALS = credentials('docker-pass') // Adjust to match your credentials ID
    }
    stages {
        stage('Initialize') {
            steps {
                script {
                    // Define a build timestamp variable
                    env.BUILD_TIMESTAMP = new Date().format("yyyyMMddHHmmss", TimeZone.getTimeZone('UTC'))
                    echo "Build timestamp: ${env.BUILD_TIMESTAMP}"
                }
            }
        }

        stage('Building the Student Survey Image') {
            steps {
                script {
                    // Checkout SCM
                    checkout scm

                    // Change directory to 'StudentSurvey' for Maven build
                    dir('StudentSurvey') {
                        sh 'mvn clean package'
                    }

                    // Securely handle Docker login
                    withCredentials([usernamePassword(credentialsId: 'docker-pass', 
                                                      usernameVariable: 'DOCKER_USER', 
                                                      passwordVariable: 'DOCKER_PASS')]) {
                        sh """
                            echo "\$DOCKER_PASS" | docker login -u "\$DOCKER_USER" --password-stdin
                        """
                    }

                    // Build Docker image using the BUILD_TIMESTAMP
                    def imageName = "nthota2/studentsurvey645:${env.BUILD_TIMESTAMP}"
                    sh "docker build -t ${imageName} ."

                    // Save image name for later stages
                    env.IMAGE_NAME = imageName
                }
            }
        }

        stage('Pushing Image to DockerHub') {
            steps {
                script {
                    // Push the Docker image to DockerHub
                    sh "docker push ${env.IMAGE_NAME}"
                }
            }
        }

        stage('Deploying to Rancher') {
            steps {
                script {
                    // Deploy the new image to Rancher
                    sh "kubectl set image deployment/hw2-deployment container-0=${env.IMAGE_NAME}"
                }
            }
        }
    }
}
