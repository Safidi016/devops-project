pipeline {
    agent any

    environment {
        DOCKERHUB_CRED = credentials('docker-hub-id')
        IMAGE_NAME     = 'safidisoa/devops-project:latest'
    }

    stages {
        stage('Checkout') {
            steps { checkout scm }
        }

        stage('Install & Test') {
            steps {
                sh 'npm ci'
                sh 'npm test'
            }
        }

        stage('Build & Push Docker') {
            steps {
                script {
                    def app = docker.build(IMAGE_NAME)
                    docker.withRegistry('https://index.docker.io/v1/', 'docker-hub-id') {
                        app.push()
                    }
                }
            }
        }

        stage('Deploy to staging') {
            steps {
                sshagent(['self-ssh-key']) {
                    sh """
                        scp -o StrictHostKeyChecking=no deploy-staging.sh ubuntu@localhost:/tmp/
                        ssh -o StrictHostKeyChecking=no ubuntu@localhost 'chmod +x /tmp/deploy-staging.sh && /tmp/deploy-staging.sh ${IMAGE_NAME}'
                    """
                }
            }
        }
    }

    post {
        success { echo '🚀 Staging déployé sur http://<IP>:3000' }
        failure { echo '❌ Build échoué' }
    }
}