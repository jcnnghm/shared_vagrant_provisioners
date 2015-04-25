#!/usr/bin/env bash

ruby_version=`cat /vagrant/.ruby-version`
gemset=`cat /vagrant/.ruby-gemset`

# Install nginx and passenger
sudo apt-get update
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 561F9B9CAC40B2F7
sudo apt-get install -y apt-transport-https ca-certificates
sudo sh -c "echo deb https://oss-binaries.phusionpassenger.com/apt/passenger trusty main > /etc/apt/sources.list.d/passenger.list"
sudo chown root: /etc/apt/sources.list.d/passenger.list
sudo chmod 600 /etc/apt/sources.list.d/passenger.list
sudo apt-get update
sudo apt-get install -y nginx-extras passenger

bash --login -c "rvm use $ruby_version@$gemset --create && cd /vagrant && bin/setup"


passenger_config="
passenger_root /usr/lib/ruby/vendor_ruby/phusion_passenger/locations.ini;
passenger_ruby /usr/local/rvm/gems/$ruby_version@$gemset/wrappers/ruby;
passenger_friendly_error_pages on;
passenger_app_env development;
"
sudo sh -c "echo \"$passenger_config\" > /etc/nginx/conf.d/passenger.conf"

server_stanza="server {
  listen 80 default_server;
  server_name _;
  root /vagrant/public;
  passenger_enabled on;
}"

sudo sh -c "echo \"$server_stanza\" > /etc/nginx/sites-available/vagrant"
sudo sh -c "[ -f /etc/nginx/sites-enabled/vagrant ] && rm /etc/nginx/sites-enabled/vagrant"
sudo sh -c "ln -s /etc/nginx/sites-available/vagrant /etc/nginx/sites-enabled/"

sudo sh -c "[ -f /etc/nginx/sites-enabled/default ] && rm /etc/nginx/sites-enabled/default"

sudo service nginx restart
