#! /bin/bash

yes | sudo apt-get update
yes | sudo apt install mysql
sudo systemctl enable mysql
sudo systemctl start mysql
sudo systemctl status mysql > mysql_status.log