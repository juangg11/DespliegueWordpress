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

# htacces

Ejemplo de .htaccess explicado línea por línea
RewriteEngine On


Activa el motor de reescritura de Apache para permitir reglas RewriteRule.

RewriteCond %{HTTPS} !=on


Comprueba si la petición no está usando HTTPS.

RewriteRule ^ https://%{HTTP_HOST}%{REQUEST_URI} [L,R=301]


Redirige permanentemente la URL a su versión HTTPS.

RewriteCond %{HTTP_HOST} ^www\.(.*)$ [NC]


Detecta cuando la petición viene desde un dominio que empieza con www..

RewriteRule ^ https://%1%{REQUEST_URI} [L,R=301]


Redirige a la versión sin www manteniendo la ruta original.

RewriteCond %{REQUEST_FILENAME} !-f


Comprueba que la ruta pedida no corresponde a un archivo real.

RewriteCond %{REQUEST_FILENAME} !-d


Comprueba que la ruta pedida no corresponde a un directorio real.

RewriteRule . /index.php [L,QSA]


Envía todas las solicitudes al controlador principal index.php, preservando los parámetros.

Options -Indexes


Desactiva el listado de directorios para evitar mostrar archivos internos.

DirectoryIndex index.php index.html


Define el orden de archivos que Apache sirve como página por defecto.

<Files .htaccess>


Selecciona específicamente el archivo .htaccess.

Require all denied


Bloquea completamente el acceso público al archivo seleccionado.

</Files>


Cierra el bloque de protección del archivo.

ErrorDocument 404 /errors/404.html


Indica la página personalizada a mostrar cuando ocurre un error 404.

ErrorDocument 500 /errors/500.html


Indica la página personalizada a mostrar cuando ocurre un error 500.

AddDefaultCharset UTF-8


Define UTF-8 como codificación de caracteres por defecto en las respuestas.

FileETag None


Deshabilita el uso de ETags para simplificar la cache de archivos.

Header set X-Frame-Options "SAMEORIGIN"


Permite mostrar el sitio en iframes solo desde el mismo dominio.

Header set X-XSS-Protection "1; mode=block"


Activa un modo básico de protección contra ataques XSS en navegadores compatibles.

Header set X-Content-Type-Options "nosniff"


Evita que el navegador trate de adivinar el tipo de archivo y fuerce el MIME real.

Redirect 301 /antigua-pagina.html /nueva-pagina/


Redirige permanentemente una URL antigua hacia su versión nueva.

# Capturas:
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
