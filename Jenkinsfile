pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'name'
        DOCKER_REGISTRY = 'register_name'
        APP_PORT = '8080' // Change if needed
        SONAR_PROJECT_KEY = 'studyGroups'  // Change to your actual project key
        SONAR_HOST_URL = 'http://localhost:9000'  // Change if your SonarQube is hosted elsewhere
        SONAR_SCANNER_CLI = 'SonarQubeScanner' // Jenkins tool name for SonarScanner
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

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('SonarQube') { // 'SonarQube' is the Jenkins SonarQube server name
                    bat ''' 
                    mvn sonar:sonar ^
                    -Dsonar.projectKey=${SONAR_PROJECT_KEY} ^
                    -Dsonar.host.url=${SONAR_HOST_URL} ^
                    -Dsonar.login=${SONAR_TOKEN}
                    '''
                }
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
