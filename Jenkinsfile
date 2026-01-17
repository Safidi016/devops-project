pipeline {
   agent any

      environment {
        DOCKERHUB_CRED = credentials('docker-hub-id')
        IMAGE_NAME     = 'safidisoa/devops-project:latest'
        ADMIN_MAIL     = 'safidisoafrederic@gmail.com'
        SMTP_SERVER    = 'smtp.gmail.com'
        SMTP_PORT      = '587'
        SMTP_CRED      = credentials('smtp-credentials')
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



//       post {
//          success {
//             echo '🚀  Staging déployé sur http://3.133.150.187:3000'
//             echo "Destinataire mail : ${env.ADMIN_MAIL}"
//             // Envoi du mail récapitulatif
//          emailext (
//     subject: "[Jenkins] Nouvelle fonctionnalité déployée sur staging",
//     body: """
//         Bonjour,

//         Un développeur vient de pousser une modification qui a été déployée avec succès sur l’environnement de staging :

//         •  Commit  : ${env.GIT_COMMIT.take(7)}
//         •  Auteur  : ${env.GIT_AUTHOR_NAME}
//         •  Message : ${env.GIT_COMMIT_MSG}
//         •  URL     : http://3.133.150.187:3000

//         Merci de vérifier et valider la nouvelle fonctionnalité.

//         Cordialement,
//         Jenkins – Pipeline CI/CD
//     """.stripIndent(),
//      to: env.ADMIN_MAIL
// )
//         }
//         failure {
//             echo '❌ Build échoué'
//         }
//     }
post {
    success {
        script {
            // Récupération des infos Git
            def commit = sh(returnStdout: true, script: 'git rev-parse HEAD').trim()
            def author = sh(returnStdout: true, script: 'git log -1 --pretty=format:"%an"').trim()
            def msg    = sh(returnStdout: true, script: 'git log -1 --pretty=format:"%s"').trim()

            echo "🚀  Staging déployé sur http://3.133.150.187:3000"
            echo "Destinataire mail : ${env.ADMIN_MAIL}"

            emailext (
                subject: "[Jenkins] Nouvelle fonctionnalité déployée sur staging",
                body: """
                    Bonjour,

                    Un développeur vient de pousser une modification qui a été déployée avec succès sur l’environnement de staging :

                    •  Commit  : ${commit.take(7)}
                    •  Auteur  : ${author}
                    •  Message : ${msg}
                    •  URL     : http://3.133.150.187:3000 

                    Merci de vérifier et valider la nouvelle fonctionnalité.

                    Cordialement,
                    Jenkins – Pipeline CI/CD
                """.stripIndent(),
                to: env.ADMIN_MAIL
                from : 'safidisoafrederic@gmail.com'
            )
        }
    }
    failure {
        echo '❌ Build échoué'
    }
}

}