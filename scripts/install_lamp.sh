#!/bin/bash

set -ex

apt update

apt upgrade

apt install apache2 -y

apt install php libapache2-mod-php php-mysql -y

cp ../conf/000-default.conf /etc/apache2/sites-available/000-default.conf

systemctl restart apache2

cp ../php/index.php /var/www/html

apt install mysql-server -y