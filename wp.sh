#! /usr/bin/env bash

#sudo
if [[ "$(whoami)" = "root" ]] && [[ "$(command -v sudo)" = "" ]]; then
  echo "performing update -> -> -> -> ->"
  apt update
  echo "installing sudo -> -> -> -> ->"
  apt install sudo -y

elif [[ "$(whoami)" = "root" ]] && [[ "$(command -v sudo)" != "" ]]; then
  echo "sudo is already installed"
  apt update

else
  echo "you are not root"
  sudo apt update
fi

#wget
if [ "$(command -v wget)" != "" ]; then
  echo "wget installed"
else
  sudo apt install wget -y
fi

#apache remove
if [ "$(command -v apache2)" != "" ]; then
  echo "apache found and removing"
  sudo apt purge apache2 -y
  sudo apt autoremove -y
else
  echo "Everything is good for apache"
fi

#ppa apache
if [[ "$(grep -iR ondrej/apache2 /etc/apt)" = "" ]]; then
  echo "Checking apache2 PPA status"
  echo " PPA missing so adding it"
  sudo apt install software-properties-common -y
  sudo add-apt-repository ppa:ondrej/apache2 -y
  sudo apt update

elif [[ "$(grep -iR deadsnakes/ppa /etc/apt)" != "" ]]; then
  echo "PPA already added"
  sudo apt update

else
  echo "Aborted"
fi

#apache install
if [ "$(command -v apache2)" = "" ]; then
  echo "Installing Apache"
  sudo apt install apache2 -y
else
  echo "Aborted"
fi

#php remove
if [ "$(command -v php)" != "" ] && [ "$(command -v apache2)" != "" ]; then
  echo "php found and removing"
  sudo apt purge php* -y
  sudo apt autoremove -y
else
  echo "Everything is good again"
fi

#ppa php
if [[ "$(grep -iR ondrej/php /etc/apt)" = "" ]] && [ "$(command -v apache2)" != "" ]; then
  echo "Checking php PPA status"
  echo " PPA missing so adding it"
  sudo apt install software-properties-common -y
  sudo add-apt-repository ppa:ondrej/php -y
  sudo apt update

elif [[ "$(grep -iR ondrej/php /etc/apt)" != "" ]]; then
  echo "PPA already added"
  sudo apt update

else
  echo "Aborted"
fi

#php 8 install
if [ "$(command -v php)" = "" ] && [ "$(command -v apache2)" != "" ]; then
  echo "Installing PHP 8"
  sudo apt install php8.0 php8.0-cli php8.0-common php8.0-curl php8.0-gd php8.0-intl php8.0-mbstring php8.0-mysql php8.0-imagick php8.0-opcache php8.0-readline php8.0-xml php8.0-xsl php8.0-zip php8.0-bz2 php8.0-bcmath libapache2-mod-php8.0 -y
else
  echo "Aborted"
fi

#mariadb remove
if [ "$(command -v mariadb)" != "" ] && [ "$(command -v php)" != "" ]; then
  echo "apache found and removing"
  sudo apt purge mariadb-* -y
  sudo apt autoremove -y
else
  echo "Everything is good for mariadb"
fi

#mariadb install
if [ "$(command -v mariadb)" = "" ] && [ "$(command -v php)" != "" ]; then
  echo "Installing MariaDB"
  sudo apt install mariadb-server mariadb-client -y
  sudo mysql_secure_installation

  echo "Enabling unix socket"
  echo "Enter root password"
  mysql -u root -p <<-EOF
  UPDATE mysql.user SET plugin = 'mysql_native_password' WHERE user = 'root' AND plugin = 'unix_socket';
  FLUSH PRIVILEGES;
  exit
EOF

else
  echo "Aborted"
fi

#wordpress part
FILE=/var/www/html/index.html
if [[ -f "$FILE" ]]; then
  echo "$FILE exists."
  sudo rm /var/www/html/index.html
  echo "Removed"
else
  echo "$FILE not exists."
fi

#cleaning
read -r -p "Do you want to delete every files in apache root directory (var/www/html)? [y/N] " response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]] || [[ "$response" = "" ]]; then

  sudo rm -r /var/www/html/*

else

  echo "Ok, old files are not deleted"

fi

FILE=/var/www/html
if [[ -d "$FILE" ]]; then
  echo "$FILE found."
  echo "Installing WordPress"
  sleep 1
  sudo wget -P /var/www/html https://wordpress.org/latest.tar.gz
  echo "downloading wordpress archive to apache directory"

  sudo tar -zvxf /var/www/html/latest.tar.gz -C /var/www/html
  echo "the archive has a folder named wordpress"

  sudo mv /var/www/html/wordpress/* /var/www/html
  echo "moving wp files to apache root directory from wordpress folder"

  sudo rm /var/www/html/latest.tar.gz
  echo "deleting the archive"

  sudo rmdir /var/www/html/wordpress
  echo "deleting the folder named wordpress"
  echo "Done...."

  echo "Setting permission"
  sudo find /var/www/html -type d -exec chmod 750 {} \;
  sudo find /var/www/html -type f -exec chmod 640 {} \;

  sudo systemctl restart apache2

  sudo adduser "$USER" www-data
  sudo chown -R www-data:www-data /var/www/html
  sudo chmod u=rwX,g=srX,o=rX -R /var/www/html

else
  echo "$FILE not exists."
fi

exit
