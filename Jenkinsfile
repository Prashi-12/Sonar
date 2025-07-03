pipeline {
    agent any

    tools {
        maven 'Maven 3'
        jdk 'JDK-17'
    }

    stages {
        stage('Checkout') {
            steps {
                git url: 'https://github.com/Prashi-12/hello-sonar.git', branch: 'main'
            }
        }

        stage('Build and SonarQube Analysis') {
            steps {
                withSonarQubeEnv('MySonarQube') {
                    sh 'mvn clean verify sonar:sonar'
                }
            }
        }

        stage('Quality Gate') {
            steps {
                timeout(time: 2, unit: 'MINUTES') {
                    waitForQualityGate abortPipeline: true
                }
            }
        }
    }
}
