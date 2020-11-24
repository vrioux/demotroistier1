#!/bin/bash
# Mettre à jour les packages
yum update –y
# Installer MariaDB
yum install -y mariadb-server
# Démarrer MariaDB
systemctl start mariadb
systemctl enable mariadb
# Créer un utilisateur dans MariaDB permettre l'authentification à distance
mysql -e "CREATE USER 'app'@'%' IDENTIFIED BY 'LunchAndLearn2020'; GRANT ALL PRIVILEGES ON *.* TO 'app'@'%' IDENTIFIED BY 'LunchAndLearn2020';"
systemctl restart mariadb
