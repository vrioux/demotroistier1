#!/bin/bash
# Mettre à jour les packages
yum update –y
# Installer Apache
yum install -y httpd git
# Ajuster les permissions pour Apache
usermod -a -G apache ec2-user
chown -R ec2-user:apache /var/www
chmod 2775 /var/www && find /var/www -type d -exec sudo chmod 2775 {} \;
find /var/www -type f -exec sudo chmod 0664 {} \;
# Démarrer Apache
systemctl start httpd
systemctl enable httpd
# Retirer les pages HTML par défaut
cd /var/www/html
rm -rf *
# Installer la petite app de démonstration
git clone -b master https://github.com/vrioux/demotroistier1 .
# Injecter le nom d'hôte (ou IP) et le mot de passe de l'app
sed -i.bak "s/<apihost>/54.151.45.176/;" /var/www/html/index.html
# Retirer les pages PHP car ce tier sert seulement le contenu HTML
rm -f *.php
