server {
  listen 80;
  listen [::]:80;
  server_name TNT20190307tenant3.doocti.com;
  return 301 https://$host$request_uri;
}

server {
        listen 443 ssl;

        root /var/www/html/TNT20190307tenant3/aster-dialer-api/services;
        index index.php index.html index.htm index.nginx-debian.html;
        server_name TNT20190307tenant3.doocti.com;
		
		ssl on;
		ssl_certificate     /etc/letsencrypt/live/doocti.com/fullchain.pem;
		ssl_certificate_key /etc/letsencrypt/live/doocti.com/privkey.pem;
	
        location / {
                try_files $uri $uri/ =404;
        }

        location ~ /.well-known {
                allow all;
        }

		location @rewrites {
			rewrite ^(.+)$ /doocti-report/index.html last;
  }

        location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/run/php/php7.1-fpm.sock;
    }

    location ~ /\.ht {
        deny all;
    }
}
