# Stage 1: Build the Java application
FROM maven:3.8.5-openjdk-17 AS build-java
WORKDIR /app

COPY pom.xml .
#COPY src ./src
RUN mvn clean package -DskipTests

# Stage 2: Build the Jekyll site
FROM jekyll/jekyll:latest AS build-jekyll
WORKDIR /jekyll
COPY . .
RUN jekyll build

# Stage 3: Combine everything into a final image
FROM openjdk:17-jdk-slim
WORKDIR /app

# Copy the built Java artifact
COPY --from=build-java /app/target/YourApp.jar app.jar

# Copy the generated Jekyll site (if you need it in the same container)
COPY --from=build-jekyll /jekyll/_site /var/www/html

# Expose your Java port
EXPOSE 8080

CMD ["java", "-jar", "app.jar"]
