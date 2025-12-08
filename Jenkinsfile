// Jenkinsfile – Pipeline complet CI/CD (Build → Test → Docker → Deploy)
// Compatible avec n’importe quel agent Jenkins disposant de Docker et SSH

pipeline {
    /* ------------------------------------------------------------------
       1.  CHOIX DE L’AGENT
       ------------------------------------------------------------------ */
    agent any          // « any » = le 1er exécuteur libre (peut être un nœud, un pod K8s, etc.)

    /* ------------------------------------------------------------------
       2.  VARIABLES D’ENVIRONNEMENT
           Elles seront injectées dans TOUTES les étapes du pipeline.
       ------------------------------------------------------------------ */
    environment {
        // Récupération des identifiants Docker Hub stockés dans Jenkins
        // (Manage Jenkins → Manage Credentials → ID global « docker-hub-id »)
        DOCKERHUB_CRED = credentials('docker-hub-id')

        // Nom complet de l’image : <compte>/<repo>:<tag>
        IMAGE_NAME = 'safidisoa/devops-project:latest'
    }

    /* ------------------------------------------------------------------
       3.  STAGES (étapes séquentielles)
       ------------------------------------------------------------------ */
    stages {
        /* ----------------------------------------------------------
           3-a. Récupération du code source
           ---------------------------------------------------------- */
        stage('Checkout') {
            steps {
                // clone du repo lié au job multibranch (ou au SCM configuré)
                checkout scm
            }
        }

        /* ----------------------------------------------------------
           3-b. Installation de Node.js 18.18.0 et lancement des tests
           ---------------------------------------------------------- */
        stage('Install & Test') {
            steps {
                // Script shell multiligne :
                //  - télécharge une version portable de Node
                //  - l’extrait dans /tmp
                //  - met à jour le PATH pour cette étape uniquement
                //  - lance « npm install » puis « npm test »
                sh '''
                    curl -L https://nodejs.org/dist/v18.18.0/node-v18.18.0-linux-x64.tar.gz \
                      | tar -xz -C /tmp
                    export PATH=/tmp/node-v18.18.0-linux-x64/bin:$PATH
                    node -v
                    npm -v
                    npm install
                    npm test
                '''
            }
        }

        /* ----------------------------------------------------------
           3-c. Construction de l’image Docker et push sur Docker Hub
           ---------------------------------------------------------- */
        stage('Build & Push Docker') {
            steps {
                script {
                    // « docker.build » utilise le Dockerfile présent à la racine du repo
                    def app = docker.build(IMAGE_NAME)

                    // Connexion à Docker Hub via les creds définis plus haut
                    docker.withRegistry('https://index.docker.io/v1/', 'docker-hub-id') {
                        app.push()          // push du tag « latest »
                        // app.push("v${BUILD_NUMBER}") // exemple de tag supplémentaire
                    }
                }
            }
        }

        /* ----------------------------------------------------------
           3-d. Déploiement sur la VM de staging
           ---------------------------------------------------------- */
        stage('Deploy to staging') {
            steps {
                // Chargement de la clé SSH « self-ssh-key » stockée dans Jenkins
                sshagent(['self-ssh-key']) {
                    sh """
                        # Copie du script de déploiement sur la VM
                        scp -o StrictHostKeyChecking=no deploy-staging.sh ubuntu@<IP_STAGING>:/tmp/

                        # Exécution distante : rendre exécutable puis lancer le script
                        # Le script récupère le nom d’image via la variable IMAGE_NAME
                        ssh -o StrictHostKeyChecking=no ubuntu@<IP_STAGING> \
                          'chmod +x /tmp/deploy-staging.sh && /tmp/deploy-staging.sh ${IMAGE_NAME}'
                    """
                }
            }
        }
    }

    /* ------------------------------------------------------------------
       4.  POST-ACTIONS (succès ou échec)
       ------------------------------------------------------------------ */
    post {
        success {
            echo '🚀 Staging déployé sur http://3.133.150.187:3000'
            // On peut ajouter ici un webhook Slack, un mail, etc.
        }
        failure {
            echo '❌ Build échoué'
            // Idem : notifications, clean-up, ...
        }
    }
}