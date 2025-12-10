# DespliegueWordpress

## Configuración Apache

```apache
<VirtualHost *:80>
    #ServerName PUT_YOUR_CERTBOT_DOMAIN_HERE
    ServerAdmin webmaster@localhost
    DocumentRoot /var/www/html/

    DirectoryIndex index.php index.html

    <Directory /var/www/html/>
        AllowOverride All
    </Directory>

    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
```

**ServerName** - Define el dominio principal del sitio.

**ServerAdmin** - Email del administrador del servidor.

**DocumentRoot** - Directorio raíz donde se alojará WordPress.

**DirectoryIndex** - Archivos por defecto que Apache buscará al acceder a un directorio.

**AllowOverride All** - Permite que el archivo .htaccess sobrescriba la configuración de Apache.

**ErrorLog / CustomLog** - Rutas de los archivos de registro.

## Script install_lamp.sh

Instala Apache, PHP, MySQL y configura el VirtualHost.

```bash
#!/bin/bash

set -ex

apt update
apt upgrade -y
apt install apache2 -y
apt install php libapache2-mod-php php-mysql -y
cp ../conf/000-default.conf /etc/apache2/sites-available/000-default.conf
systemctl restart apache2
cp ../php/index.php /var/www/html
apt install mysql-server -y
```

**apt update** - Actualiza la lista de paquetes disponibles.

**apt upgrade -y** - Actualiza los paquetes instalados a sus últimas versiones.

**apt install apache2 -y** - Instala el servidor web Apache2.

**apt install php libapache2-mod-php php-mysql -y** - Instala PHP y los módulos necesarios para Apache y MySQL.

**cp ../conf/000-default.conf /etc/apache2/sites-available/000-default.conf** - Copia la configuración personalizada del VirtualHost.

**systemctl restart apache2** - Reinicia Apache para aplicar los cambios.

**cp ../php/index.php /var/www/html** - Copia un archivo PHP de prueba.

**apt install mysql-server -y** - Instala el servidor de base de datos MySQL.

## Script letsencrypt_certificate.sh

Configura el certificado SSL con Let's Encrypt.

```bash
#!/bin/bash

set -ex

source .env
cp ../conf/000-default.conf /etc/apache2/sites-available
sed -i "s/PUT_YOUR_CERBOT_DOMAIN_HERE/$CERTBOT_DOMAIN/" /etc/apache2/sites-available/000-default.conf
snap install core
snap refresh core
apt remove certbot -y
snap install --classic certbot
certbot --apache -m $CERTBOT_EMAIL --agree-tos --no-eff-email -d $CERTBOT_DOMAIN --non-interactive
```

**source .env** - Importa las variables de entorno del archivo .env.

**cp ../conf/000-default.conf /etc/apache2/sites-available** - Copia la plantilla del VirtualHost.

**sed -i "s/PUT_YOUR_CERBOT_DOMAIN_HERE/$CERTBOT_DOMAIN/" /etc/apache2/sites-available/000-default.conf** - Reemplaza el placeholder con el dominio real.

**snap install core** - Instala snap (gestor de paquetes necesario para Certbot).

**snap refresh core** - Actualiza snap a la última versión.

**apt remove certbot -y** - Elimina cualquier instalación previa de Certbot.

**snap install --classic certbot** - Instala Certbot mediante snap.

**certbot --apache -m $CERTBOT_EMAIL --agree-tos --no-eff-email -d $CERTBOT_DOMAIN --non-interactive** - Solicita y configura automáticamente el certificado SSL.

## Script deploy.sh

Descarga, configura e instala WordPress con WP-CLI.

```bash
#!/bin/bash

set -ex

source .env

rm -f /tmp/wp-cli.phar
wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar -P /tmp
chmod +x /tmp/wp-cli.phar
mv /tmp/wp-cli.phar /usr/local/bin/wp

rm -rf /var/www/html/*

wp core download --locale=es_ES --path=/var/www/html --allow-root

mysql -u root -e "DROP DATABASE IF EXISTS $DB_NAME"
mysql -u root -e "CREATE DATABASE $DB_NAME"
mysql -u root -e "DROP USER IF EXISTS $DB_USER@'$IP_CLIENTE_MYSQL'"
mysql -u root -e "CREATE USER $DB_USER@'$IP_CLIENTE_MYSQL' IDENTIFIED BY '$DB_PASSWORD'"
mysql -u root -e "GRANT ALL PRIVILEGES ON $DB_NAME.* TO $DB_USER@'$IP_CLIENTE_MYSQL'"

wp config create --dbname=$DB_NAME --dbuser=$DB_USER --dbpass=$DB_PASSWORD --dbhost=$DB_HOST --path=/var/www/html --allow-root

wp core install --url=$CERTBOT_DOMAIN --title="$WORDPRESS_TITLE" --admin_user=$WORDPRESS_ADMIN_USER --admin_password=$WORDPRESS_ADMIN_PASSWORD --admin_email=$WORDPRESS_ADMIN_EMAIL --path=/var/www/html --allow-root

wp rewrite structure '/%postname%/' --path=/var/www/html --allow-root

wp plugin install wps-hide-login --activate --path=/var/www/html --allow-root

wp option update whl_page $URL_HIDE_LOGIN --path=/var/www/html --allow-root

cp ../htaccess/.htaccess /var/www/html/.htaccess

chown -R www-data:www-data /var/www/html
```

**#!/bin/bash** - Indica que el script debe ejecutarse usando el intérprete Bash.

**set -ex** - Activa modo de error inmediato (-e) y muestra cada comando antes de ejecutarlo (-x).

**source .env** - Carga las variables de entorno definidas en el archivo .env.

**rm -f /tmp/wp-cli.phar** - Elimina cualquier descarga previa del archivo WP-CLI en /tmp.

**wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar -P /tmp** - Descarga la herramienta WP-CLI en su versión PHAR dentro del directorio /tmp.

**chmod +x /tmp/wp-cli.phar** - Otorga permisos de ejecución al archivo descargado de WP-CLI.

**mv /tmp/wp-cli.phar /usr/local/bin/wp** - Mueve WP-CLI al directorio binario global para poder ejecutarlo como wp.

**rm -rf /var/www/html/\*** - Elimina cualquier instalación previa de WordPress existente en el directorio web.

**wp core download --locale=es_ES --path=/var/www/html --allow-root** - Descarga la última versión de WordPress en español dentro del directorio /var/www/html.

**mysql -u root -e "DROP DATABASE IF EXISTS $DB_NAME"** - Elimina la base de datos existente con ese nombre, si la hubiera.

**mysql -u root -e "CREATE DATABASE $DB_NAME"** - Crea una nueva base de datos para WordPress.

**mysql -u root -e "DROP USER IF EXISTS $DB_USER@'$IP_CLIENTE_MYSQL'"** - Elimina el usuario MySQL previo asociado a esa IP si existe.

**mysql -u root -e "CREATE USER $DB_USER@'$IP_CLIENTE_MYSQL' IDENTIFIED BY '$DB_PASSWORD'"** - Crea un nuevo usuario MySQL con la contraseña especificada para esa IP cliente.

**mysql -u root -e "GRANT ALL PRIVILEGES ON $DB_NAME.\* TO $DB_USER@'$IP_CLIENTE_MYSQL'"** - Asigna todos los permisos del esquema de WordPress al usuario MySQL recién creado.

**wp config create --dbname=$DB_NAME --dbuser=$DB_USER --dbpass=$DB_PASSWORD --dbhost=$DB_HOST --path=/var/www/html --allow-root** - Genera automáticamente el archivo wp-config.php con las credenciales y parámetros de conexión proporcionados.

**wp core install --url=$CERTBOT_DOMAIN --title="$WORDPRESS_TITLE" --admin_user=$WORDPRESS_ADMIN_USER --admin_password=$WORDPRESS_ADMIN_PASSWORD --admin_email=$WORDPRESS_ADMIN_EMAIL --path=/var/www/html --allow-root** - Realiza la instalación inicial de WordPress configurando URL, título, usuario admin y correo.

**wp rewrite structure '/%postname%/' --path=/var/www/html --allow-root** - Configura la estructura de enlaces permanentes para que usen solo el nombre del post.

**wp plugin install wps-hide-login --activate --path=/var/www/html --allow-root** - Instala y activa el plugin WPS Hide Login.

**wp option update whl_page $URL_HIDE_LOGIN --path=/var/www/html --allow-root** - Actualiza la opción del plugin para establecer la URL personalizada de acceso al login.

**cp ../htaccess/.htaccess /var/www/html/.htaccess** - Copia un archivo .htaccess personalizado dentro del directorio principal de WordPress.

**chown -R www-data:www-data /var/www/html** - Asigna como propietario del directorio web al usuario y grupo www-data.

## .htaccess

```apache
<IfModule mod_rewrite.c>
    RewriteEngine On
    RewriteBase /
    RewriteRule ^index\.php$ - [L]
    RewriteCond %{REQUEST_FILENAME} !-f
    RewriteCond %{REQUEST_FILENAME} !-d
    RewriteRule . /index.php [L]
</IfModule>
```

**<IfModule mod_rewrite.c>** - Ejecuta estas reglas sólo si el módulo mod_rewrite está habilitado.

**RewriteEngine On** - Activa el motor de reescritura de URLs.

**RewriteBase /** - Define la ruta base para las reglas (la raíz del sitio).

**RewriteRule ^index\\.php$ - [L]** - Si se solicita index.php directamente, no reescribir y terminar.

**RewriteCond %{REQUEST_FILENAME} !-f** - Continuar sólo si el archivo solicitado no existe.

**RewriteCond %{REQUEST_FILENAME} !-d** - Continuar sólo si el directorio solicitado no existe.

**RewriteRule . /index.php [L]** - Redirigir todo lo demás a index.php y terminar reglas.

## Ejecución Install Lamp

<img width="1624" height="705" alt="image" src="https://github.com/user-attachments/assets/7882cc64-91a2-481a-8902-f60978b0fdbd" />

## Ejecución Certificado

<img width="1107" height="707" alt="image" src="https://github.com/user-attachments/assets/4ea3617d-ca17-48ff-81c9-2ee51a5463fe" />

## Ejecución Deploy

<img width="1628" height="700" alt="image" src="https://github.com/user-attachments/assets/431e14ba-a630-4ea9-8f51-0a07cf7d5c63" />

## Sitio Web

<img width="1871" height="1035" alt="image" src="https://github.com/user-attachments/assets/67cde20e-3f16-4c4c-9cc9-54f316781d51" />

## Login con ruta personalizada

<img width="1868" height="1031" alt="image" src="https://github.com/user-attachments/assets/a854f209-5c08-4764-8c31-8330838c5ba6" />
