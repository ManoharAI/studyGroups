FROM openjdk:17-jdk-slim

# Set the working directory inside the container
WORKDIR /app

COPY target/studygroups.jar app.jar

# Expose the port the application runs on
EXPOSE 8080

# Define the entrypoint to run the application
ENTRYPOINT ["java", "-jar", "app.jar"]
