server {
  listen 80;
  listen [::]:80;
  server_name dev-wallboard.doocti.com;
  return 301 https://$host$request_uri;
}

server {
  listen 443 ssl;

  root /var/www/html;
  index index.php index.html index.htm index.nginx-debian.html;
  server_name dev-wallboard.doocti.com;

  ssl on;
	ssl_certificate     /etc/letsencrypt/live/doocti.com/fullchain.pem;
	ssl_certificate_key /etc/letsencrypt/live/doocti.com/privkey.pem;

  location / {
    try_files $uri $uri/ =404;
  }

  location ~ /.well-known {
    allow all;
  }
location /doocti-extension1 {
    try_files $uri $uri/$request_uri /doocti-extension1/index.html;
  }


  location /doocti-customer-portal {
    try_files $uri $uri/$request_uri /doocti-customer-portal/index.html;
  }

  location /doocti-extension {
    try_files $uri $uri/$request_uri /doocti-extension/index.html;
  }


  location @rewrites {
		rewrite ^(.+)$ /doocti-customer-portal/index.html last;
  }

  location ~ \.php$ {
    include snippets/fastcgi-php.conf;
    fastcgi_pass unix:/run/php/php7.1-fpm.sock;
  }

  location ~ /\.ht {
    deny all;
  }
}
