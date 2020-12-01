server {
	listen 80;
	listen [::]:80;

	root /var/www/html/TNT20190307tenant3/aster-dialer-api/services;

	# Add index.php to the list if you are using PHP
	index index.php index.html index.htm index.nginx-debian.html;

	server_name bharathuniv.test.doocti.com;

	location / {
		try_files $uri $uri/ /index.php?/$request_uri;
		#proxy_pass http://localhost:8094/;
	}

	location ~ \.php$ {
		include snippets/fastcgi-php.conf;
		fastcgi_pass unix:/run/php/php7.1-fpm.sock;
	}

	location ~ /\.ht {
		deny all;
	}
}
