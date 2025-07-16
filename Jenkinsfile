pipeline {
    agent any

    parameters {
        string(name: 'BRANCH_NAME', defaultValue: 'main', description: 'Git branch to build')
    }

    tools {
        maven 'Maven 3'
        jdk 'JDK-17'
    }

    stages {
        stage('Checkout') {
            steps {
                git url: 'https://github.com/Prashi-12/Sonar.git', branch: "${params.BRANCH_NAME}"
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
