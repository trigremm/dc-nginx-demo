FROM nginx:stable-alpine as production-stage
COPY ./index.html /usr/share/nginx/html
COPY ./conf.d/default.conf /etc/nginx/conf.d/default.conf

EXPOSE 80
EXPOSE 443
CMD ["nginx", "-g", "daemon off;"]
