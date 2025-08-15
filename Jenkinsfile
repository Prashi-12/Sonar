pipeline {
    agent any
    tools {
        maven 'Maven-3.8.5'
        jdk 'JDK-11'
    }
    environment {
        SONARQUBE = 'SonarQube'
        SONAR_HOST_URL = "http://16.171.23.207:30090/"
        NEXUS_MAVEN_URL = "http://56.228.7.62:30081/repository/maven-releases"
        NEXUS_DOCKER_REPO = "13.60.191.181:30500/hello-sonar"
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
                        sh '''
                            mvn clean verify sonar:sonar \
                              -Dsonar.projectKey=my-project \
                              -Dsonar.host.url=$SONAR_HOST_URL \
                              -Dsonar.login=$SONAR_TOKEN
                        '''
                    }
                }
            }
        }

        stage('Quality Gate') {
            steps {
                timeout(time: 15, unit: 'MINUTES') {
                    waitForQualityGate abortPipeline: true
                }
            }
        }

        stage('Build & Deploy to Nexus') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'nexus', usernameVariable: 'NEXUS_USERNAME', passwordVariable: 'NEXUS_PASSWORD')]) {
                    sh '''
                        mkdir -p /var/jenkins_home/.m2
                        cat > /var/jenkins_home/.m2/settings.xml <<EOF
<settings>
  <servers>
    <server>
      <id>nexus</id>
      <username>${NEXUS_USERNAME}</username>
      <password>${NEXUS_PASSWORD}</password>
    </server>
  </servers>
</settings>
EOF
                        mvn -s /var/jenkins_home/.m2/settings.xml clean deploy
                    '''
                }
            }
        }

        stage('Download Artifact from Nexus') {
            steps {
                sh '''
                    mvn dependency:get \
                      -DrepoUrl=$NEXUS_MAVEN_URL \
                      -Dartifact=com.example:hello-sonar:1.0-SNAPSHOT \
                      -Ddest=hello-sonar.jar
                '''
            }
        }

        stage('Build & Push Docker Image') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'nexus', usernameVariable: 'NEXUS_USERNAME', passwordVariable: 'NEXUS_PASSWORD')]) {
                    sh '''
                        docker build -t $NEXUS_DOCKER_REPO:latest .
                        echo $NEXUS_PASSWORD | docker login 13.60.191.181:30500 -u $NEXUS_USERNAME --password-stdin
                        docker push $NEXUS_DOCKER_REPO:latest
                    '''
                }
            }
        }
    }
}
