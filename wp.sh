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

echo "
   ##    #####     ##     ####   #    #  ######
  #  #   #    #   #  #   #    #  #    #  #
 #    #  #    #  #    #  #       ######  #####
 ######  #####   ######  #       #    #  #
 #    #  #       #    #  #    #  #    #  #
 #    #  #       #    #   ####   #    #  ######
"

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
  sudo apt install software-properties-common dirmngr wget curl apt-transport-https -y
  sudo add-apt-repository ppa:ondrej/apache2 -y
  sudo apt update

elif [[ "$(grep -iR ondrej/apache2 /etc/apt)" != "" ]]; then
  echo "PPA already added"
  sudo apt update

else
  echo "Aborted"
fi

#apache install
if [ "$(command -v apache2)" = "" ] && [[ "$(grep -iR ondrej/apache2 /etc/apt)" != "" ]]; then
  echo "Installing Apache"
  sudo apt install apache2 -y
else
  echo "Aborted"
fi

echo "
 #####   #    #  #####
 #    #  #    #  #    #
 #    #  ######  #    #
 #####   #    #  #####
 #       #    #  #
 #       #    #  #
"

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
  sudo apt install software-properties-common dirmngr apt-transport-https -y
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

echo "
                                        ######  ######
 #    #    ##    #####      #      ##   #     # #     #
 ##  ##   #  #   #    #     #     #  #  #     # #     #
 # ## #  #    #  #    #     #    #    # #     # ######
 #    #  ######  #####      #    ###### #     # #     #
 #    #  #    #  #   #      #    #    # #     # #     #
 #    #  #    #  #    #     #    #    # ######  ######
"

#mariadb remove
if [ "$(command -v mariadb)" != "" ] && [ "$(command -v apache2)" != "" ] && [ "$(command -v php)" != "" ]; then
  echo "mariaDB found and removing"
  sudo apt purge mariadb-* -y
  sudo apt autoremove -y
else
  echo "Everything is good for mariadb"
fi

#ppa mariaDB
if [[ "$(grep -iR https://dlm.mariadb.com /etc/apt/)" = "" ]] && [ "$(command -v mariadb)" = "" ] && [ "$(command -v apache2)" != "" ] && [ "$(command -v php)" != "" ]; then

  echo "Checking MariaDB PPA status"
  echo " PPA missing so adding it"
  curl -LsS https://r.mariadb.com/downloads/mariadb_repo_setup | sudo bash -s -- --os-type=ubuntu
  sudo apt update
  sudo apt upgrade -y

elif [[ "$(grep -iR https://dlm.mariadb.com /etc/apt/)" != "" ]]; then
  echo "MariaDB PPA already added"
  sudo apt update

else
  echo "Aborted"
fi

#mariadb install
if [ "$(command -v mariadb)" = "" ] && [[ "$(grep -iR https://dlm.mariadb.com /etc/apt/)" != "" ]] && [ "$(command -v apache2)" != "" ] && [ "$(command -v php)" != "" ]; then
  echo "Installing MariaDB"
  sudo apt update
  sudo apt install mariadb-server mariadb-client mariadb-backup -y

  echo "
   ##     #####   #####  ######  #    #   #####     #     ####   #    #
  #  #      #       #    #       ##   #     #       #    #    #  ##   #
 #    #     #       #    #####   # #  #     #       #    #    #  # #  #
 ######     #       #    #       #  # #     #       #    #    #  #  # #
 #    #     #       #    #       #   ##     #       #    #    #  #   ##
 #    #     #       #    ######  #    #     #       #     ####   #    #
"

  echo "-> -> -> You must have to set root password now for securing mariadb"
  echo "-> -> -> Make sure to enable Switch to unix_socket authentication"
  sleep 2

  sudo mysql_secure_installation

else
  echo "Aborted"
fi

echo "
 #    #   ####   #####   #####   #####   #####   ######   ####    ####
 #    #  #    #  #    #  #    #  #    #  #    #  #       #       #
 #    #  #    #  #    #  #    #  #    #  #    #  #####    ####    ####
 # ## #  #    #  #####   #    #  #####   #####   #            #       #
 ##  ##  #    #  #   #   #    #  #       #   #   #       #    #  #    #
 #    #   ####   #    #  #####   #       #    #  ######   ####    ####
"

#wordpress part
FILE=/var/www/html/index.html
if [[ -f "$FILE" ]] && [ "$(command -v apache2)" != "" ] && [ "$(command -v php)" != "" ] && [ "$(command -v mariadb)" != "" ]; then
  echo "$FILE exists."
  sudo rm /var/www/html/index.html
  echo "Removed"
else
  echo "$FILE not exists."
fi

#cleaning
if [[ -d /var/www/html ]] && [ "$(command -v apache2)" != "" ] && [ "$(command -v php)" != "" ] && [ "$(command -v mariadb)" != "" ]; then
  echo "var/www/html exists"

  DIR="/var/www/html"
  if [ "$(ls -A "$DIR")" ] && [ "$(command -v apache2)" != "" ] && [ "$(command -v php)" != "" ] && [ "$(command -v mariadb)" != "" ]; then
    echo "$DIR contains files"

    read -r -p "Do you want to delete every files in apache root directory (var/www/html)? [y/n] " response
    if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]] || [[ "$response" = "" ]]; then

      sudo rm -r /var/www/html/*
      echo "Ok, deleted"
    fi

  else
    echo "$DIR is empty"
  fi

else
  echo "var/www/html doesn't exist"
fi

#downloading and setting wp
FILE=/var/www/html
if [[ -d "$FILE" ]] && [ "$(command -v apache2)" != "" ] && [ "$(command -v php)" != "" ] && [ "$(command -v mariadb)" != "" ]; then
  echo "$FILE found."
  echo "Installing WordPress"
  sleep 1
  sudo wget -P /var/www/html https://wordpress.org/latest.tar.gz
  echo "downloading wordpress archive to apache directory"

  echo "extracting wordpress"
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
  echo "$FILE not exists, so wp installaion aborted"
fi

echo "
 #    #  ######  #    #
 #    #  #       #    #
 #    #  #####   #    #
 #    #  #       # ## #
 #    #  #       ##  ##
  ####   #       #    #
"

#ufw
if [ "$(command -v ufw)" != "" ] && [ "$(command -v apache2)" != "" ] && [ "$(command -v php)" != "" ] && [ "$(command -v mariadb)" != "" ]; then
  echo "ufw installed"
  echo "updating ufw rules"
  sudo ufw enable
  sudo ufw allow 22/tcp
  sudo ufw allow 80/tcp
  sudo ufw allow 443/tcp
  sudo systemctl reload apache2

elif [ "$(command -v ufw)" = "" ] && [ "$(command -v apache2)" != "" ] && [ "$(command -v php)" != "" ] && [ "$(command -v mariadb)" != "" ]; then
  echo "installing ufw"
  echo "updating ufw rules"
  sudo apt install ufw -y
  sudo ufw enable
  sudo ufw allow 22/tcp
  sudo ufw allow 80/tcp
  sudo ufw allow 443/tcp
  sudo systemctl reload apache2

else
  echo "ufw installation aborted"
fi

#script remove
FILE=~/wp.sh
if [[ -f "$FILE" ]]; then
  echo "$FILE exists"
  sudo rm ~/wp.sh
  echo "$FILE is cleaned"

else
  echo "$FILE not found"
fi

exit
