#! /bin/bash

sudo apt-get -y update
sudo apt-get -y upgrade
sudo apt-get install -y build-essential
sudo apt-get install -y python-software-properties python g++ make

# Install Docker
sudo apt-get install -y docker.io
sudo groupadd docker
sudo usermod -aG docker $USER

# Configure MySQL
sudo docker run --name blog-mysql -e MYSQL_ROOT_PASSWORD=$MYSQL_ROOT_PASSWORD -e MYSQL_DATABASE=$MYSQL_DATABASE -e MYSQL_USER=$MYSQL_USER -e MYSQL_PASSWORD=$MYSQL_PASSWORD -p 3306:3306 -d mysql

# Install NPM and Node JS LTS
curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -
sudo apt-get install -y nodejs

cd ~/blog
npm install --production
sudo npm install -g forever

# Install Nginx
sudo apt-get install -y nginx

# Configure Nginx
sudo rm /etc/nginx/sites-available/default
sudo cp ~/blog/nginx.conf /etc/nginx/sites-available/ghost
sudo ln -s /etc/nginx/sites-available/ghost /etc/nginx/sites-enabled/ghost

# Start Nginx and Ghost
sudo cp ~/blog/upstart.conf /etc/init/ghost.conf
sudo service nginx restart
cd ~/blog/
NODE_ENV=production forever start index.js