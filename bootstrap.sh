echo updating package information
apt-add-repository -y ppa:brightbox/ruby-ng >/dev/null 2>&1
apt-get -y update >/dev/null 2>&1

sudo apt-get install build-essential

sudo apt-get install ruby2.2 ruby2.2-dev
update-alternatives --set ruby /usr/bin/ruby2.2 >/dev/null 2>&1
update-alternatives --set gem /usr/bin/gem2.2 >/dev/null 2>&1

echo installing Bundler
gem install bundler -N >/dev/null 2>&1

sudo apt-get install git

sudo apt-get install nodejs
sudo apt-get install npm

# Needed for docs generation.
update-locale LANG=en_US.UTF-8 LANGUAGE=en_US.UTF-8 LC_ALL=en_US.UTF-8

cd /vagrant

#This file is supposed to be at the root according to go .___.
cp ./vagrant_ansible_inventory_default ../

./go init 

echo 'all set, rock on!'
