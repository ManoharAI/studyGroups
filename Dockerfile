# Stage 1: Build the application using Maven
FROM maven:3.8.5-openjdk-17 AS build
WORKDIR /app

# Copy the Maven configuration and source code
COPY pom.xml .
COPY src ./src

# Build the application (adjust command and flags as needed)
RUN mvn clean package -DskipTests

# Stage 2: Create the runtime image with the built JAR
FROM openjdk:17-jdk-slim
WORKDIR /app

# Update the JAR name if necessary; ensure it matches your build artifact
COPY --from=build /app/target/studygroups.jar app.jar

# Expose the port your application listens on
EXPOSE 8080

# Define the entrypoint to run the application
ENTRYPOINT ["java", "-jar", "app.jar"]
