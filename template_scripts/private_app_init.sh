#! /bin/bash


documentdb_uri=${documentdb_uri}
documentdb_username=${documentdb_username}
documentdb_password=${documentdb_password}

set -x

yes | sudo apt update

yes | sudo apt install git pyhton3 default-jdk wget curl  ca-certificates

# installing nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
source ~/.bashrc
nvm install v20.12.2


# installing docker
yes | sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
yes | sudo apt-get update

# install the docker packages
yes | sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# adding the local user to docker group
sudo usermod -aG docker $USER

wget https://truststore.pki.rds.amazonaws.com/global/global-bundle.pem

documentdb_certificate_path=$(printf %s "$(pwd)/global-bundle.pem" | jq -sRr @uri)
mongodb_uri="mongodb://${documentdb_username}:${documentdb_password}@${documentdb_uri}:27017/?tls=true&tlsCAFile=$${documentdb_certificate_path}&replicaSet=rs0&readPreference=secondaryPreferred&retryWrites=false"


docker pull eswarmaganti/mern-tasks-app

docker run -d --name mern-tasks-app \
  -p 5001:5001 \
  -e MONGODB_URI=$mongodb_uri
  eswarmaganti/mern-tasks-app
