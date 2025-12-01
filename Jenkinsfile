pipeline {
    agent any

    environment {
        DOCKERHUB_CREDENTIALS = credentials('docker-hub-id')
        IMAGE_NAME = 'https://github.com/Safidi016/devops-project.git'
        STAGING_IP = '3.133.150.187'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Install & Test') {
            steps {
                sh 'npm ci'
                sh 'npm test'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    def app = docker.build("${IMAGE_NAME}")
                    docker.withRegistry('https://index.docker.io/v1/', 'docker-hub-id') {
                        app.push()
                    }
                }
            }
        }

        stage('Deploy to Staging') {
            steps {
                sshagent(['staging-ssh-key']) {
                    sh """
                        scp -o StrictHostKeyChecking=no deploy-staging.sh ubuntu@${STAGING_IP}:/tmp/
                        ssh -o StrictHostKeyChecking=no ubuntu@${STAGING_IP} 'chmod +x /tmp/deploy-staging.sh && /tmp/deploy-staging.sh ${IMAGE_NAME}'
                    """
                }
            }
        }
    }

    post {
        success {
            echo '🚀 Déploiement staging réussi !'
        }
        failure {
            echo '❌ Pipeline échoué'
        }
    }
}