# Dockerfile to host the files as a web server 
# Should be using nginx with the html and js files moved over to the default nginx location /usr/share/nginx/html

FROM nginx:alpine

WORKDIR /usr/share/nginx/html
COPY nginx.conf /etc/nginx/nginx.conf
COPY index.html index.js ./
EXPOSE 80