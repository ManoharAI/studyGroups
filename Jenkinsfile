pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'name'
        DOCKER_REGISTRY = 'register_name'
        APP_PORT = '8080' // Change if needed
    }

    stages {
        stage('Clone Repository') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'github-credentials', usernameVariable: 'GIT_USER', passwordVariable: 'GIT_PASS')]) {
                    sh 'git clone https://$GIT_USER:$GIT_PASS@github.com/ManoharAI/studyGroups.git'
                }
            }
        }

        stage('Build with Maven') {
            steps {
                sh 'mvn clean install'
            }
        }

        stage('Run JUnit Tests') {
            steps {
                junit '**/target/surefire-reports/*.xml'
            }
        }

        stage('Docker Build') {
            steps {
                sh 'docker build -t ${DOCKER_REGISTRY}/${DOCKER_IMAGE}:latest .'
            }
        }

        stage('Docker Push') {
            steps {
                withDockerRegistry([credentialsId: 'docker-hub-credentials', url: 'https://index.docker.io/v1/']) {
                    sh 'docker push ${DOCKER_REGISTRY}/${DOCKER_IMAGE}:latest'
                }
            }
        }

        stage('Deploy Container') {
            steps {
                sh '''
                docker stop my_container || true
                docker rm my_container || true
                docker run -d --name my_container -p ${APP_PORT}:8080 ${DOCKER_REGISTRY}/${DOCKER_IMAGE}:latest
                '''
            }
        }
    }

    post {
        always {
            archiveArtifacts artifacts: '**/target/*.jar', fingerprint: true
        }
        cleanup {
            sh 'docker system prune -f'
        }
    }
}
