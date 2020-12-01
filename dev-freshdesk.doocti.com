server {
    listen 80;
    server_name dev-freshdesk.doocti.com;
    return 301 https://$host$request_uri;
}
server {
    listen 443;
    server_name dev-freshdesk.doocti.com;
    ssl_certificate           /etc/letsencrypt/live/doocti.com/fullchain.pem;
    ssl_certificate_key       /etc/letsencrypt/live/doocti.com/privkey.pem;
    ssl on;
    ssl_session_cache  builtin:1000  shared:SSL:10m;
    ssl_protocols  TLSv1 TLSv1.1 TLSv1.2;
    ssl_ciphers HIGH:!aNULL:!eNULL:!EXPORT:!CAMELLIA:!DES:!MD5:!PSK:!RC4;
    ssl_prefer_server_ciphers on;
    gzip  on;
    gzip_http_version 1.1;
    gzip_vary on;
    gzip_comp_level 6;
    gzip_proxied any;
    gzip_types text/plain text/css application/json application/javascript application/x-javascript text/javascript text/xml application/xml application/rss+xml application/atom+xml application/rdf+xml;
    gzip_buffers 16 8k;
    gzip_disable “MSIE [1-6].(?!.*SV1)”;
    
    access_log  /var/log/nginx/metabase.access.log;
    
location / {
    proxy_pass            http://localhost:8011;
    proxy_set_header    host $host;
    proxy_http_version  1.1;
    proxy_set_header upgrade $http_upgrade;         
    proxy_set_header connection "upgrade";     
    } 
}
