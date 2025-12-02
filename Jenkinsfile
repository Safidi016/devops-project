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
                ssh 'curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | bash'
                       sh '''
                       export NVM_DIR="$HOME/.nvm"
                       [ -s "$NVM_DIR/nvm.sh" ] && \\. "$NVM_DIR/nvm.sh"
                       nvm install 18
                       nvm use 18
                       npm ci
                       npm test
                      '''
            }
        }

        stage('Build & Push Docker') {
            steps {
                script {
                    /* image Docker */
                    def app = docker.build(IMAGE_NAME)
                    /* registry : enlève l'espace en trop */
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