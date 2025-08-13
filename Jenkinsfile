pipeline {
    agent any
    tools {
        maven 'Maven-3.8.5'
        jdk 'JDK-11'
    }
    environment {
        SONARQUBE = 'SonarQube' // Jenkins SonarQube server configuration name
    }
    stages {
        stage('Checkout') {
            steps {
                git branch: 'prashanth.developer', url: 'https://github.com/Prashi-12/Sonar.git'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv("${SONARQUBE}") {
                    withCredentials([string(credentialsId: 'sonarqube', variable: 'SONAR_TOKEN')]) {
                        sh """
                            mvn clean verify sonar:sonar \
                              -Dsonar.projectKey=my-project \
                              -Dsonar.host.url=$SONAR_HOST_URL \
                              -Dsonar.login=$SONAR_TOKEN
                        """
                    }
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
                withCredentials([usernamePassword(credentialsId: 'nexus', usernameVariable: 'NEXUS_USERNAME', passwordVariable: 'NEXUS_PASSWORD')]) {
                    sh """
                        mvn -s /var/jenkins_home/.m2/settings.xml clean deploy \
                          -Dnexus.username=$NEXUS_USERNAME \
                          -Dnexus.password=$NEXUS_PASSWORD
                    """
                }
            }
        }
    }
}
