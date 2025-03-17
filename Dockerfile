# Stage 1: Build the Java application
FROM maven:3.8.5-openjdk-17 AS build-java
WORKDIR /app

# Copy Maven configuration and Java source code
COPY pom.xml .
#COPY src ./src

# Build the application (skipping tests)
RUN mvn clean package -DskipTests

# Stage 2: Build the Jekyll site
FROM jekyll/jekyll:latest AS build-jekyll
WORKDIR /srv/jekyll

# Copy all site files into /srv/jekyll
COPY . .

# Build the Jekyll site
RUN jekyll build

# Stage 3: Combine everything into a final image
FROM openjdk:17-jdk-slim
WORKDIR /app

# Copy the built Java artifact – update the JAR name if needed
COPY --from=build-java /app/target/studygroups-1.0.0.jar app.jar

# Copy the generated Jekyll site into /var/www/html
COPY --from=build-jekyll /srv/jekyll/_site /var/www/html

# Expose the port used by the Java application
EXPOSE 8080

# Command to run the Java application
CMD ["java", "-jar", "app.jar"]
