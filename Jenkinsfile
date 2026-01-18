pipeline {
    agent any

    environment {
        DOCKERHUB_CRED = credentials('docker-hub-id')
        IMAGE_NAME     = 'safidisoa/devops-project:latest'
        ADMIN_MAIL     = 'safidylegrand@gmail.com'
        SMTP_CRED      = credentials('smtp-credentials')
        TRIVY_SERVER   = 'http://172.31.15.14:4954'   // IP du serveur Trivy
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Install & Test') {
            steps {
                sh '''
                curl -L https://nodejs.org/dist/v18.18.0/node-v18.18.0-linux-x64.tar.gz | tar -xz -C /tmp
                export PATH=/tmp/node-v18.18.0-linux-x64/bin:$PATH
                node -v
                npm -v
                npm install
                npm test
                '''
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    docker.build(IMAGE_NAME)
                    env.DOCKER_IMAGE_BUILT = "true"
                }
            }
        }

        stage('Security Scan (Trivy)') {
            steps {
                echo 'Analyse de sécurité de l’image Docker avec Trivy (Grafana / Prometheus)'
