# Stage 1: Build the Java application (optional)
FROM maven:3.8.5-openjdk-17 AS build-java
WORKDIR /app

# Copy the Maven configuration
COPY pom.xml .
# If you have Java source code, uncomment the next line:
# COPY src ./src

# Build the application; if there's no Java code, this might fail
RUN mvn clean package -DskipTests

# Stage 2: Build the Jekyll site
FROM jekyll/jekyll:latest AS build-jekyll

# Use /srv/jekyll because it's writable by the default 'jekyll' user
WORKDIR /srv/jekyll

# Copy all site files into /srv/jekyll
COPY . .

# Build the Jekyll site
RUN jekyll build

# Stage 3: Combine everything into a final image
FROM openjdk:17-jdk-slim
WORKDIR /app

# Copy the built Java artifact (update 'YourApp.jar' to the actual artifact name)
COPY --from=build-java /app/target/YourApp.jar app.jar

# Copy the generated Jekyll site into /var/www/html (adjust as needed)
COPY --from=build-jekyll /srv/jekyll/_site /var/www/html

# Expose the port for the Java application
EXPOSE 8080

# Run the Java application (modify or remove if not needed)
CMD ["java", "-jar", "app.jar"]
