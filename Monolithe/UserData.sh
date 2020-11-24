#!/bin/bash
# Mettre à jour les packages
yum update –y
# Installer Apache, PHP et MariaDB
amazon-linux-extras install -y lamp-mariadb10.2-php7.2 php7.2
yum install -y httpd mariadb-server git
# Ajuster les permissions pour Apache
usermod -a -G apache ec2-user
chown -R ec2-user:apache /var/www
chmod 2775 /var/www && find /var/www -type d -exec sudo chmod 2775 {} \;
find /var/www -type f -exec sudo chmod 0664 {} \;
# Démarrer Apache et MariaDB
systemctl start httpd
systemctl enable httpd
systemctl start mariadb
systemctl enable mariadb
# Configurer le mot de passe MariaDB root
mysql -e "UPDATE mysql.user SET Password = PASSWORD('LunchAndLearn2020') WHERE User = 'root'"
systemctl restart mariadb
# Retirer les pages HTML par défaut
cd /var/www/html
rm -rf *
# Installer la petite app de démonstration
git clone -b master https://github.com/vrioux/demotroistier1 .
# Injecter le nom d'hôte (ou IP) et le mot de passe de la BD dans le code de l'app
sed -i.bak "s/<password>/LunchAndLearn2020/;" /var/www/html/index.php
sed -i.bak "s/<dbhost>/127.0.0.1/;" /var/www/html/index.php
