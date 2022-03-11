• Simply run `bash wp.sh` in the terminal.

• Make sure you running the terminal from the same directory where wp.sh file is located.

• Create user and database for wordpress my following commands-

• Replace `user`  `password`  `wordpress`  with your keywords.

• `mysql -u root -p`

• `GRANT ALL PRIVILEGES ON *.* TO 'user'@'localhost' IDENTIFIED BY 'password';`

• `\q`

• `mysql -u user -p`

• `CREATE DATABASE wordpress;`

• `\q`
