# Stage 1: Build the Jekyll site
FROM jekyll/jekyll:latest AS build-jekyll
WORKDIR /srv/jekyll
COPY . .
RUN jekyll build

# Stage 2: Serve the generated site with Nginx
FROM nginx:alpine
# Copy the generated site into the Nginx html folder
COPY --from=build-jekyll /srv/jekyll/_site /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
