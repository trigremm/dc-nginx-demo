# sudo ln -s /etc/nginx/sites-available/www.demo.com /etc/nginx/sites-enabled/www.demo.com
# sudo rm -f /etc/nginx/sites-enabled/default
# sudo nginx -t && sudo nginx -s reload

upstream www-demo-com {
  server 127.0.0.1:8330;
}

server {
    gzip on;
    gzip_disable "msie6";
    gzip_min_length 1000;
    gzip_types *;
    gzip_proxied any;

    server_name www.demo.com demo.com;
    access_log /var/log/nginx/www-demo-com.access.log;

    # security
    add_header Referrer-Policy "strict-origin";
    add_header X-Content-Type-Options nosniff;
    add_header X-Frame-Options "SAMEORIGIN";
    add_header X-XSS-Protection "1; mode=block";
    add_header Strict-Transport-Security 'max-age=31536000; includeSubDomains; preload';

    location / {
        proxy_set_header Host $http_host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_pass       http://www-demo-com/;
        proxy_redirect   off;
    }
}
