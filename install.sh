#// As root
apt update
apt -y install wordpress php libapache2-mod-php mysql-server php-mysql 
apt -y install curl php-curl zip php-zip php-mbstring php-dom
apt -y install php-imagemagick imagemagick ghostscript gnuplot graphviz html2ps 
apt -y install libpcre3 libpcre3-dev libsodium-dev
mysql -u root  
CREATE DATABASE wordpress DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;
GRANT ALL ON wordpress.* TO 'wordpress'@'localhost' IDENTIFIED BY '<DB_PASSWORD>';
FLUSH PRIVILEGES;
EXIT;
systemctl restart apache2
touch /etc/apache2/conf-available/wordpress.conf
echo '<Directory /var/www/html/>' >> /etc/apache2/conf-available/wordpress.conf
echo '    AllowOverride All' >> /etc/apache2/conf-available/wordpress.conf
echo '<Directory /var/www/html/>' >> /etc/apache2/conf-available/wordpress.conf
ln /etc/apache2/conf-available/wordpress.conf /etc/apache2/conf-enabled/wordpress.conf
a2enmod rewrite
systemctl restart apache2
wget -P /tmp "https://wordpress.org/latest.tar.gz"
tar xzvf /tmp/latest.tar.gz
touch /tmp/wordpress/.htaccess
mkdir /tmp/wordpress/wp-content/upgrade
cp -r /tmp/wordpress/ /var/www/html
chown -R www-data:www-data /var/www/html
find /var/www/html/ -type d -exec chmod 755 {} \;
find /var/www/html/ -type f -exec chmod 644 {} \;
touch /var/www/html/wp-config.php
echo "<?php " >> /var/www/html/wp-config.php
echo "define( 'DB_NAME', 'wordpress');" >> /var/www/html/wp-config.php
echo "define( 'DB_USER', 'wordpress');" >> /var/www/html/wp-config.php
echo "define( 'DB_PASSWORD', '<DB_PASSWORD>');" >> /var/www/html/wp-config.php
echo "define( 'DB_HOST', 'localhost');" >> /var/www/html/wp-config.php
echo "define( 'DB_CHARSET',  'utf8mb4' );" >> /var/www/html/wp-config.php
echo "$table_prefix = 'wp_';" >> /var/www/html/wp-config.php
echo "if ( !defined('ABSPATH') )" >> /var/www/html/wp-config.php
echo "        define('ABSPATH', dirname(__FILE__) . '/');" >> /var/www/html/wp-config.php
echo "require_once(ABSPATH . 'wp-settings.php');" >> /var/www/html/wp-config.php
systemctl restart apache2
exit
