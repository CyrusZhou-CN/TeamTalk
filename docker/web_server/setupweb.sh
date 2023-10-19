#!/bin/bash
server_ip(){
        getent hosts $1  | awk '{print $1}'
}

echo "setup database"
sed -i "s/\$db\['default'\]\['hostname'\].*/\$db\['default'\]\['hostname'\] = '$( server_ip "${MARIADB_SERVER}" )';/g" /www/wwwroot/default/application/config/database.php
sed -i "s/\$db\['default'\]\['username'\].*/\$db\['default'\]\['username'\] = '$MARIADB_USER';/g" /www/wwwroot/default/application/config/database.php
sed -i "s/\$db\['default'\]\['password'\].*/\$db\['default'\]\['password'\] = '$MARIADB_PASSWORD';/g" /www/wwwroot/default/application/config/database.php
sed -i "s/\$db\['default'\]\['database'\].*/\$db\['default'\]\['database'\] = '$MARIADB_DATABASE';/g" /www/wwwroot/default/application/config/database.php

echo "setup config"
sed -i "s/\$config\['msfs_url'\].*/\$config\['msfs_url'\] = '${MSFS_URL}';/g" /www/wwwroot/default/application/config/config.php
sed -i "s/\$config\['http_url'\].*/\$config\['http_url'\] = '${HTTP_URL}';/g" /www/wwwroot/default/application/config/config.php

echo "setup display errors"
sed -i "s/display_errors = Off/display_errors = On/g" /usr/local/php/etc/php.ini
sed -i "s/display_startup_errors = Off/display_startup_errors = On/g" /usr/local/php/etc/php.ini
sed -i "s/error_reporting =.*/error_reporting = E_ALL/g" /usr/local/php/etc/php.ini
sed -i "s/\[www\]/\[www\]\nphp_flag\[display_errors\] = on/g" /usr/local/php/etc/php-fpm.conf

exec /opt/main.sh