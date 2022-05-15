 # ***This script will install Wordpress with Apache2, Php 8, MariaDB, UFW firewall***.

• Clone the repo and enter into the cloned folder then simply run `bash wp.sh` in the terminal.

• Create user and database for wordpress my following commands-

• Replace `user`  `password`  `wordpress`  with your keywords.

• `sudo mysql -u root -p`

• `GRANT ALL PRIVILEGES ON *.* TO 'user'@'localhost' IDENTIFIED BY 'password';`

• `\q`

• `sudo mysql -u user -p`

• `CREATE DATABASE wordpress;`

• `\q`

• *Drop a star if this script helps you*.
