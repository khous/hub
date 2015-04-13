#!/usr/bin/bash
#usage sh bootstrap.sh /path/to/key-file.pem user@123.0.0.1
cd /home/ubuntu

sudo git clone https://github.com/khous/hub.git
cd hub/deploy 

echo updating package information
sudo apt-add-repository -y ppa:brightbox/ruby-ng
sudo apt-get -y update

echo updating package
sudo apt-get update
echo installing build essential
sudo apt-get install -y build-essential

echo installing ruby
sudo apt-get install -y ruby2.2 ruby2.2-dev
sudo update-alternatives --set ruby /usr/bin/ruby2.2
sudo update-alternatives --set gem /usr/bin/gem2.2

echo installing Bundler
gem install bundler -N

#Setup and install node
curl -sL https://deb.nodesource.com/setup | sudo bash
sudo apt-get install -y nodejs

sudo apt-get install -y npm
sudo apt-get install -y nginx

# Needed for docs generation.
update-locale LANG=en_US.UTF-8 LANGUAGE=en_US.UTF-8 LC_ALL=en_US.UTF-8

cd /home/ubuntu/hub
bundle install

bundle exec jekyll b --config _config.yml,_config_public.yml

sudo cp -r deploy/usr/* /usr
sudo cp -r deploy/etc/* /etc

#Install google auth proxy
GOOGLE_AUTH_DIR_NAME=google_auth_proxy-1.1.1.darwin-amd64.go1.4.2

wget https://github.com/bitly/google_auth_proxy/releases/download/v1.1.1/$GOOGLE_AUTH_DIR_NAME.tar.gz
tar xvzf $GOOGLE_AUTH_DIR_NAME.tar.gz && rm $GOOGLE_AUTH_DIR_NAME.tar.gz

sudo cp $GOOGLE_AUTH_DIR_NAME/* /usr/local/18f/bin
cd deploy
sudo npm install

#suboptimal, rebuilding both public and private site, probably only need private site
sudo node_modules/forever/bin/forever start hookshot.js -b master -c 'cd /home/ubuntu/hub/; bundle exec jekyll b --config _config.yml,_config_public.yml' -p 4000

sudo service google_auth_proxy start
# sudo nginx -s reload
# Need to transfer server cert first :/
echo 'Copy the server ssl key and cert wherever, deploy github ssh keys, nginx -s reload'