#!/bin/bash
# Mettre à jour les packages
yum update –y
# Install Apache, PHP
amazon-linux-extras install -y lamp-mariadb10.2-php7.2 php7.2
yum install -y httpd mariadb-server git
# Ajuster les permissions pour Apache
usermod -a -G apache ec2-user
chown -R ec2-user:apache /var/www
chmod 2775 /var/www && find /var/www -type d -exec sudo chmod 2775 {} \;
find /var/www -type f -exec sudo chmod 0664 {} \;
# Ajuster la configuration Apache pour permettre le CORS
echo Header set Access-Control-Allow-Origin "*" >> /etc/httpd/conf/httpd.conf
awk '/Require method/ { print; print "    Header set Access-Control-Allow-Origin \"*\" "; next }1' /etc/httpd/conf.d/userdir.conf > /etc/httpd/conf.d/userdir.conf
# Démarrer Apache
systemctl start httpd
systemctl enable httpd
# Retirer les pages HTML par défaut
cd /var/www/html
rm -rf *
# Installer la petite app de démonstration
git clone -b master https://github.com/vrioux/demotroistier1 .
# Injecter le nom d'hôte (ou IP) et le mot de passe de la BD dans le code de l'app
sed -i.bak "s/<password>/LunchAndLearn2020/;" /var/www/html/index.php
sed -i.bak "s/<dbhost>/172.31.12.169/;" /var/www/html/index.php
sed -i.bak "s/root/app/;" /var/www/html/index.php
# Retirer les pages web statiques car ce tier est seulement l'app
rm -f *.html