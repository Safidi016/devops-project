pipeline {
    agent any

    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-id')   // ID Jenkins du credential Docker Hub
        TARGET_IP             = '3.133.150.187'               // IP publique de ton EC2
    }

    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/Safidi016/devops-project.git'
            }
        }

        stage('Build & Test') {
            steps {
                sh 'npm install'
                sh 'npm test'
            }
        }

        stage('Docker Build & Push') {
            steps {
                script {
                    def img = docker.build("safidi016/mon-app:latest")
                    docker.withRegistry('https://index.docker.io/v1/', 'dockerhub-id') {
                        img.push()
                    }
                }
            }
        }

        stage('Deploy') {
            steps {
                sshagent(['ec2-ssh']) {          // ID Jenkins du credential SSH (clé privée)
                    sh """
                        scp -o StrictHostKeyChecking=no deploy.sh ubuntu@${TARGET_IP}:/tmp/
                        ssh -o StrictHostKeyChecking=no ubuntu@${TARGET_IP} 'bash /tmp/deploy.sh'
                    """
                }
            }
        }
    }
}