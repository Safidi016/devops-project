pipeline {
    agent any

    environment {
        DOCKERHUB_CRED = credentials('docker-hub-id')
        IMAGE_NAME     = 'safidisoa/devops-project:latest'
        ADMIN_MAIL     = 'safidylegrand@gmail.com'
        SMTP_CRED      = credentials('smtp-credentials')
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
                }
            }
        }

        stage('Security Scan (Trivy)') {
            steps {
                sh '''
                echo "Installation de Trivy dernière version"
                curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sudo sh -s -- -b /usr/local/bin

                echo "Téléchargement du template HTML"
                curl -o html.tpl https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/html.tpl

                echo "Analyse de sécurité de l’image Docker avec template HTML"
                trivy image \
                  --format template \
                  --template html.tpl \
                  --output trivy-report.html \
                  ${IMAGE_NAME}
                '''
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', 'docker-hub-id') {
                        docker.image(IMAGE_NAME).push()
                    }
                }
            }
        }

        stage('Deploy to staging') {
            steps {
                sshagent(['self-ssh-key']) {
                    sh '''
                    scp -o StrictHostKeyChecking=no deploy-staging.sh ubuntu@172.31.15.14:/tmp/
                    ssh -o StrictHostKeyChecking=no ubuntu@172.31.15.14 \
                    "chmod +x /tmp/deploy-staging.sh && /tmp/deploy-staging.sh ${IMAGE_NAME}"
                    '''
                }
            }
        }
    }

    post {

        always {
            archiveArtifacts artifacts: 'trivy-report.html', fingerprint: true
        }

        success {
            script {
                def commit = sh(returnStdout: true, script: 'git rev-parse --short HEAD').trim()
                def author = sh(returnStdout: true, script: 'git log -1 --pretty=format:"%an"').trim()
                def msg    = sh(returnStdout: true, script: 'git log -1 --pretty=format:"%s"').trim()

                emailext(
                    subject: "[Jenkins] Déploiement réussi sur Staging",
                    body: """
Bonjour,

Une nouvelle version de l’application a été déployée avec succès sur l’environnement de staging.

• Commit  : ${commit}
• Auteur  : ${author}
• Message : ${msg}
• URL     : http://3.133.150.187:3000

Cordialement,
Jenkins CI/CD
""",
                    to: env.ADMIN_MAIL
                )
            }
        }

        failure {
            echo '❌ Build échoué'
        }
    }
}
