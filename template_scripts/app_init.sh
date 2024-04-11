#! /bin/bash

set -x

documentdb_uri=${documentdb_uri}
documentdb_username=${documentdb_username}
documentdb_password=${documentdb_password}

# update the package manager
ßyes | sudo apt-get update
yes | sudo apt install jq

documentdb_certificate_path=$(printf %s "/opt/SP/global-bundle.pem" | jq -sRr @uri)
mongodb_uri="mongodb://${documentdb_username}:${documentdb_password}@${documentdb_uri}:27017/?tls=true&tlsCAFile=$${documentdb_certificate_path}&replicaSet=rs0&readPreference=secondaryPreferred&retryWrites=false"



project_dir="/opt/SP/mern-tasks-app"
react_client_path="$${project_dir}/react-client"
node_api_path="$${project_dir}/tasks-api"
script_path="$${node_api_path}/src/server.js"




yes | sudo apt install wget

# install git
yes | sudo apt install git


sudo mkdir /opt/SP
sudo chown -R ubuntu /opt/SP
cd /opt/SP
# pull the github repo
git clone https://github.com/eswarmaganti/mern-todo-app.git

sleep 10

# install the DocumentDB Certificate
wget https://truststore.pki.rds.amazonaws.com/global/global-bundle.pem


# install node
cd ~
curl -sL https://deb.nodesource.com/setup_18.x -o nodesource_setup.sh
sudo bash nodesource_setup.sh
sudo apt install nodejs
sleep 10


# install PM2 to run the application in background
sudo npm install -g pm2

# change the dir to proj dir
cd $react_client_path
npm install
npm run build

# install the node packages
cd $node_api_path
npm install

touch .env
echo "MONGODB_URI=$${mongodb_uri}" >> .env
echo "PORT=5001" >> .env

# Run the node server
# pm2 start $script_path
node $script_path

