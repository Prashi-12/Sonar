pipeline {
    agent any
    tools {
        maven 'Maven-3.8.5'
        jdk 'JDK-11'
    }
    environment {
        SONARQUBE = 'sonarqube'
    }
    stages {
        stage('Checkout') {
            steps {
                git branch: 'prashanth.developer', url: 'https://github.com/Prashi-12/prashanth.developer.git'
            }
        }
        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv(SONARQUBE) {
                    sh '''
                        mvn clean verify sonar:sonar \
                        -Dsonar.projectKey=my-project \
                        -Dsonar.host.url=http://<your-public-worker-ip>:30090 \
                        -Dsonar.login=<your-sonarqube-token>
                    '''
                }
            }
        }
        stage('Quality Gate') {
            steps {
                timeout(time: 5, unit: 'MINUTES') {
                    waitForQualityGate abortPipeline: true
                }
            }
        }
        stage('Build & Deploy to Nexus') {
            steps {
                sh 'mvn clean deploy'
            }
        }
    }
}
