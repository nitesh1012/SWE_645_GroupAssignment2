pipeline {
    agent any
    environment {
        DOCKERHUB_PASS = credentials('docker-pass')
    }
    stages {
        stage("Building the Student Survey Image") {
            steps {
                script {
                    checkout scm
                    sh 'rm -rf *.war'
                    sh 'jar -cvf StudentSurvey.war -C WebContent/ .'
                    sh 'echo ${BUILD_TIMESTAMP}'
                    sh "docker login -u hekme5 -p ${DOCKERHUB_PASS}"
                    def customImage = docker.build("hekme5/studentsurvey645:${BUILD_TIMESTAMP}")
                }
            }
        }

        stage("Pushing Image to DockerHub") {
            steps {
                script {
                    sh 'docker push hekme5/studentsurvey645:${BUILD_TIMESTAMP}'
                }
            }
        }

        stage("Deploying to Rancher as single pod") {
            steps {
                sh 'kubectl set image deployment/stusurvey-pipeline stusurvey-pipeline=nitesh1012/studentsurvey645:${BUILD_TIMESTAMP} -n jenkins-pipeline'
            }
        }

        stage("Deploying to Rancher as with load balancer") {
            steps {
                sh 'kubectl set image deployment/studentsurvey645-lb studentsurvey645-lb=nitesh1012/studentsurvey645:${BUILD_TIMESTAMP} -n jenkins-pipeline'
            }
        }
    }
}
