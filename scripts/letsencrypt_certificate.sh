#!/bin/bash

# -e: FInaliza el script cuando hay error
# -x: Muestra el comando por pantalla
set -ex

#importamos el archivo de variables
source .env

#copiamos la plantilla del archivo de configuracion del virtualhost en el servidor
cp ../conf/000-default.conf /etc/apache2/sites-available

#Configuramos al ServerName en el VirtualHost
sed -i "s/PUT_YOUR_CERBOT_DOMAIN_HERE/$CERTBOT_DOMAIN/" /etc/apache2/sites-available/000-default.conf

# Instalamos snap
snap install core
snap refresh core

# Eliminamos cualquier version anterior de certbot
apt remove certbot -y

# Instalamos certbot
snap install --classic certbot

# Solicitamos el certificado a Let's Encrypt
sudo certbot --apache -m $CERTBOT_EMAIL --agree-tos --no-eff-email -d $CERTBOT_DOMAIN --non-interactive