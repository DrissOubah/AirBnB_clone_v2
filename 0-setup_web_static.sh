#!/usr/bin/env bash
#Sets up my web servers for the deployment of web_static
sudo apt-get update
sudo apt-get -y install nginx
sudo mkdir -p /data/web_static/releases/test/
sudo mkdir -p /data/web_static/shared/
echo "<html>
  <head>
  </head>
  <body>
    Holberton School
  </body>
</html>" | sudo tee /data/web_static/releases/test/index.html
sudo ln -sf /data/web_static/releases/test/ /data/web_static/current
sudo chown -R ubuntu:ubuntu /data/
echo "
server {
	location /hbnb_static {
		alias /data/web_static/current/;
		index index.html;
	}
}" | sudo tee /etc/nginx/sites-available/hbnb_static
sudo rm -f /etc/nginx/sites-enabled/default
sudo ln -sf /etc/nginx/sites-available/hbnb_static /etc/nginx/sites-enabled/
sudo service nginx restart
