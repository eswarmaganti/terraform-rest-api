#! /bin/bash

yes | sudo apt-get update

yes | sudo apt-get install gnupg curl

# install the gpg key
curl -fsSL https://www.mongodb.org/static/pgp/server-7.0.asc | \
   sudo gpg -o /usr/share/keyrings/mongodb-server-7.0.gpg \
   --dearmor

# create a apt repo list file for mongodb
echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-7.0.gpg ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/7.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-7.0.list

yes | sudo apt-get update

# install mongodb
yes | sudo apt-get install mongodb-org

sleep 10

# start the mongodb server
sudo systemctl start mongod
