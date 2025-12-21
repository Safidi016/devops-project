pipeline {
   agent any

    environment {
        DOCKERHUB_CRED = credentials('docker-hub-id')
        IMAGE_NAME     = 'safidisoa/devops-project:latest'
    }

    stages {
        stage('Checkout') {
            steps { checkout scm }
        }

        stage('Install & Test') {
            steps {
                sh '''
                    curl -L https://nodejs.org/dist/v18.18.0/node-v18.18.0-linux-x64.tar.gz  | tar -xz -C /tmp
                    export PATH=/tmp/node-v18.18.0-linux-x64/bin:$PATH
                    node -v
                    npm -v
                    npm install
                    npm test
                '''
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
                        scp -o StrictHostKeyChecking=no deploy-staging.sh ubuntu@172.31.15.14:/tmp/
                        ssh -o StrictHostKeyChecking=no ubuntu@172.31.15.14 'chmod +x /tmp/deploy-staging.sh && /tmp/deploy-staging.sh ${IMAGE_NAME}'
                    """
                }
            }
        }
    }

    post {
        success { echo '🚀 Staging déployé sur http://3.133.150.187:3000' 
}
     failure { echo '❌ Build échoué ' }
    }
}