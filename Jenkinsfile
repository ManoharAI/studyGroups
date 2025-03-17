pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'name'
        DOCKER_REGISTRY = 'register_name'
        APP_PORT = '8080' // Port on which your application listens
        SONAR_PROJECT_KEY = 'studyGroups'
        SONAR_HOST_URL = 'http://localhost:9000'
        SONAR_SCANNER_CLI = 'SonarQubeScanner'
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
                withSonarQubeEnv('SonarQube') {
                    withCredentials([string(credentialsId: 'Sonar-token', variable: 'SONAR_TOKEN')]) {
                        bat ''' 
                        mvn sonar:sonar ^
                        -Dsonar.projectKey=%SONAR_PROJECT_KEY% ^
                        -Dsonar.host.url=%SONAR_HOST_URL% ^
                        -Dsonar.login=%SONAR_TOKEN%
                        '''
                    }
                }
            }
        }
        stage('Docker Build') {
            steps {
                bat 'docker build -t %DOCKER_REGISTRY%/%DOCKER_IMAGE%:latest .'
            }
        }
        stage('Deploy Container') {
            steps {
                bat '''
                docker stop my_container || true
                docker rm my_container || true
                docker run -d --name my_container -p %APP_PORT%:8080 %DOCKER_REGISTRY%/%DOCKER_IMAGE%:latest
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
