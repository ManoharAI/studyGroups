#
# Stage 1: Build the Java application (optional)
#
FROM maven:3.8.5-openjdk-17 AS build-java
WORKDIR /app

# Copy the Maven configuration
COPY pom.xml .

# If you do have Java source code in a src/ directory, uncomment the next line:
# COPY src ./src

# Run Maven. If there's no actual Java code, this will fail unless you skip or handle it.
# Using '|| echo ...' prevents the build from failing outright if there's no src folder.
RUN mvn clean package -DskipTests || echo "No Java code found, skipping Java build."

#
# Stage 2: Build the Jekyll site
#
FROM jekyll/jekyll:latest AS build-jekyll

# Use /srv/jekyll because it's writable by the default 'jekyll' user
WORKDIR /srv/jekyll

# Copy all site files into /srv/jekyll
COPY . .

# Build the Jekyll site
RUN jekyll build

#
# Stage 3: Combine everything into a final image
#
FROM openjdk:17-jdk-slim
WORKDIR /app

# If you actually built a JAR in Stage 1, copy it here. 
# Change 'YourApp.jar' to match the real artifact name from /app/target/.
COPY --from=build-java /app/target/YourApp.jar app.jar || echo "No JAR found, skipping."

# Copy the generated Jekyll site into /var/www/html (or wherever you want your static files)
COPY --from=build-jekyll /srv/jekyll/_site /var/www/html

# Expose your Java port (if you're running a Java service)
EXPOSE 8080

# Default command to run your Java app. If you don't have a Java app, remove or change this.
CMD ["java", "-jar", "app.jar"]
