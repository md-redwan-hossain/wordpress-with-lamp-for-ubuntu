 # ***This script will install Wordpress with Apache2, Php 8, MariaDB, UFW firewall***.

• Simply run `wget -P ~ https://raw.githubusercontent.com/redwan-hossain/wordpress-with-lamp-for-ubuntu-20.04/main/wp.sh && bash wp.sh` in the terminal.

• Create user and database for wordpress my following commands-

• Replace `user`  `password`  `wordpress`  with your keywords.

• `sudo mysql -u root -p`

• `GRANT ALL PRIVILEGES ON *.* TO 'user'@'localhost' IDENTIFIED BY 'password';`

• `\q`

• `sudo mysql -u user -p`

• `CREATE DATABASE wordpress;`

• `\q`

• *Drop a star if this script helps you*.
