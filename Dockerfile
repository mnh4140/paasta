FROM nginx:latest
#COPY index.html /usr/share/nginx/html
#COPY Jenkinsfile /etc/nginx/conf.d/default.conf
#nginx file copy
COPY default.conf /etc/nginx/conf.d/default.conf
COPY index.html /usr/share/nginx/html/index.html
#EXPOSE 80
EXPOSE 4140
