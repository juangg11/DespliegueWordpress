# DespliegueWordpress

Explicación de comandos
#!/bin/bash


Indica que el script debe ejecutarse usando el intérprete Bash.

set -ex


Activa modo de error inmediato (-e) y muestra cada comando antes de ejecutarlo (-x).

source .env


Carga las variables de entorno definidas en el archivo .env.

rm -f /tmp/wp-cli.phar


Elimina cualquier descarga previa del archivo WP-CLI en /tmp.

wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar -P /tmp


Descarga la herramienta WP-CLI en su versión PHAR dentro del directorio /tmp.

chmod +x /tmp/wp-cli.phar


Otorga permisos de ejecución al archivo descargado de WP-CLI.

mv /tmp/wp-cli.phar /usr/local/bin/wp


Mueve WP-CLI al directorio binario global para poder ejecutarlo como wp.

rm -rf /var/www/html/*


Elimina cualquier instalación previa de WordPress existente en el directorio web.

wp core download --locale=es_ES --path=/var/www/html --allow-root


Descarga la última versión de WordPress en español dentro del directorio /var/www/html.

mysql -u root -e "DROP DATABASE IF EXISTS $DB_NAME"


Elimina la base de datos existente con ese nombre, si la hubiera.

mysql -u root -e "CREATE DATABASE $DB_NAME"


Crea una nueva base de datos para WordPress.

mysql -u root -e "DROP USER IF EXISTS $DB_USER@'$IP_CLIENTE_MYSQL'"


Elimina el usuario MySQL previo asociado a esa IP si existe.

mysql -u root -e "CREATE USER $DB_USER@'$IP_CLIENTE_MYSQL' IDENTIFIED BY '$DB_PASSWORD'"


Crea un nuevo usuario MySQL con la contraseña especificada para esa IP cliente.

mysql -u root -e "GRANT ALL PRIVILEGES ON $DB_NAME.* TO $DB_USER@'$IP_CLIENTE_MYSQL'"


Asigna todos los permisos del esquema de WordPress al usuario MySQL recién creado.

wp config create --dbname=$DB_NAME --dbuser=$DB_USER --dbpass=$DB_PASSWORD --dbhost=$DB_HOST --path=/var/www/html --allow-root


Genera automáticamente el archivo wp-config.php con las credenciales y parámetros de conexión proporcionados.

wp core install --url=$CERTBOT_DOMAIN --title="$WORDPRESS_TITLE" --admin_user=$WORDPRESS_ADMIN_USER --admin_password=$WORDPRESS_ADMIN_PASSWORD --admin_email=$WORDPRESS_ADMIN_EMAIL --path=/var/www/html --allow-root


Realiza la instalación inicial de WordPress configurando URL, título, usuario admin y correo.

wp rewrite structure '/%postname%/' --path=/var/www/html --allow-root


Configura la estructura de enlaces permanentes para que usen solo el nombre del post.

wp plugin install wps-hide-login --activate --path=/var/www/html --allow-root


Instala y activa el plugin WPS Hide Login.

wp option update whl_page $URL_HIDE_LOGIN --path=/var/www/html --allow-root


Actualiza la opción del plugin para establecer la URL personalizada de acceso al login.

cp ../htaccess/.htaccess /var/www/html/.htaccess


Copia un archivo .htaccess personalizado dentro del directorio principal de WordPress.

chown -R www-data:www-data /var/www/html


Asigna como propietario del directorio web al usuario y grupo www-data.

# .htaccess

Este archivo configura la reescritura de URLs para dirigir todas las peticiones a `index.php`:

- Activa el motor de reescritura
- Define la raíz del sitio como base
- Si se solicita `index.php` directamente, no hace nada
- Si el archivo o directorio solicitado no existe, redirige a `index.php`
````apache
<IfModule mod_rewrite.c>
    RewriteEngine On
    RewriteBase /
    RewriteRule ^index\.php$ - [L]
    RewriteCond %{REQUEST_FILENAME} !-f
    RewriteCond %{REQUEST_FILENAME} !-d
    RewriteRule . /index.php [L]
</IfModule>
````

**Explicación de las directivas:**

- `<IfModule mod_rewrite.c>` - Ejecuta estas reglas sólo si el módulo mod_rewrite está habilitado
- `RewriteEngine On` - Activa el motor de reescritura de URLs
- `RewriteBase /` - Define la ruta base para las reglas (la raíz del sitio)
- `RewriteRule ^index\.php$ - [L]` - Si se solicita index.php, no reescribir y terminar
- `RewriteCond %{REQUEST_FILENAME} !-f` - Continuar sólo si el archivo no existe
- `RewriteCond %{REQUEST_FILENAME} !-d` - Continuar sólo si el directorio no existe
- `RewriteRule . /index.php [L]` - Redirigir todo lo demás a index.php

Ejecución Install Lamp
<img width="1624" height="705" alt="image" src="https://github.com/user-attachments/assets/7882cc64-91a2-481a-8902-f60978b0fdbd" />

Ejecucion Certificado
<img width="1107" height="707" alt="image" src="https://github.com/user-attachments/assets/4ea3617d-ca17-48ff-81c9-2ee51a5463fe" />

Ejecucion Deploy
<img width="1628" height="700" alt="image" src="https://github.com/user-attachments/assets/431e14ba-a630-4ea9-8f51-0a07cf7d5c63" />

Sitio Web
<img width="1871" height="1035" alt="image" src="https://github.com/user-attachments/assets/67cde20e-3f16-4c4c-9cc9-54f316781d51" />
(Con la ruta con secreto)
<img width="1868" height="1031" alt="image" src="https://github.com/user-attachments/assets/a854f209-5c08-4764-8c31-8330838c5ba6" />
