FROM openjdk:11-jdk-slim
WORKDIR /app
COPY hello-sonar.jar app.jar
ENTRYPOINT ["java", "-jar", "app.jar"]
