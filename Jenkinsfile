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
                    git branch: 'main', url: 'https://github.com/ManoharAI/studyGroups.git'
            }
        }

        stage('Build with Maven') {
            steps {
                bat 'mvn clean install'
            }
        }

        stage('Run JUnit Tests') {
            steps {
                junit '**/target/surefire-reports/*.xml'
            }
        }

        stage('Docker Build') {
            steps {
                bat 'docker build -t ${DOCKER_REGISTRY}/${DOCKER_IMAGE}:latest .'
            }
        }

        stage('Docker Push') {
            steps {
                withDockerRegistry([credentialsId: 'docker-hub-credentials', url: 'https://index.docker.io/v1/']) {
                    bat 'docker push ${DOCKER_REGISTRY}/${DOCKER_IMAGE}:latest'
                }
            }
        }

        stage('Deploy Container') {
            steps {
                bat '''
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
