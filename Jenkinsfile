pipeline {
    agent any
    tools {
        maven 'Maven3.9.9' // Ensure this matches the Maven name in Global Tool Configuration
    }

    environment {
        DOCKERHUB_PASS = credentials('docker-pass')
        BUILD_TAG = ''
    }
    stages {
        stage("Building the Student Survey Image") {
            steps {
                script {
                    checkout scm
                    dir('StudentSurvey') { 
                        // Build using Maven
                        sh "pwd"
                        sh 'mvn clean package'
                    }
                                        
                    sh 'echo ${BUILD_TIMESTAMP}'
                    withCredentials([usernamePassword(credentialsId: 'docker-pass', 
                                                      usernameVariable: 'DOCKER_USER', 
                                                      passwordVariable: 'DOCKER_PASS')]) {
                        sh """
                            echo ""\$DOCKER_PASS" | docker login -u "\$DOCKER_USER" --password-stdin"
                        """
                    }

                    BUILD_TAG = "${BUILD_TIMESTAMP}".replace(' ', '_').replace(':', '-')

                    sh "docker build -t nthota2/studentsurvey645:${BUILD_TAG} ."
                }
            }


        }

        stage("Pushing Image to DockerHub") {
            steps {
                script {
                    sh 'docker push nthota2/studentsurvey645:${BUILD_TIMESTAMP}'
                }
            }
        }

        stage("Deploying to Rancher as single pod") {
            steps {
                sh 'kubectl set image deployment/stusurvey-pipeline stusurvey-pipeline=nthota2/studentsurvey645:${BUILD_TIMESTAMP} -n jenkins-pipeline'
            }
        }

        stage("Deploying to Rancher as with load balancer") {
            steps {
                sh 'kubectl set image deployment/studentsurvey645-lb studentsurvey645-lb=nthota2/studentsurvey645:${BUILD_TIMESTAMP} -n jenkins-pipeline'
            }
        }
    }
}
