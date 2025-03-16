pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'name'
        DOCKER_REGISTRY = 'register_name'
    }

    stages {
        stage('Clone Repository') {
            steps {
                git 'https://github.com/ManoharAI/studyGroups.git'
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
                sh 'docker run -d -p 8080:8080 ${DOCKER_REGISTRY}/${DOCKER_IMAGE}:latest'
            }
        }
    }

    post {
        always {
            archiveArtifacts artifacts: '**/target/*.jar', fingerprint: true
        }
    }
}
