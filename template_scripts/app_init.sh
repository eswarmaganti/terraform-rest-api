#! /bin/bash

yes | sudo apt-get update
yes | sudo apt install apache2
sudo systemctl enable apache2
sudo systemctl start apache2
sudo systemctl status apache2 > mysql_status.log
sudo su -
echo "<h1>Hello World from Webtier - $(hostname -s)</h1>" > /var/www/html/index.html