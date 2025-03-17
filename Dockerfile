# Stage 1: Build the application
FROM maven:3.8.5-openjdk-17 AS build
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn clean package

# Stage 2: Package the application
FROM openjdk:17-jdk-slim
WORKDIR /app
# Adjust the JAR file name if necessary (e.g., studygroups-0.0.1-SNAPSHOT.jar)
COPY --from=build /app/target/studygroups.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
