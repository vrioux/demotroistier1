LAMP server haute dispo exemple

[Monolithique]
----------------------------

1- Lancer une instance EC2 t2.medium
UserData:

#!/bin/bash
# Update packages
yum update –y
# Install Apache, PHP, MariaDB
amazon-linux-extras install -y lamp-mariadb10.2-php7.2 php7.2
yum install -y httpd mariadb-server git
# Set users
usermod -a -G apache ec2-user
chown -R ec2-user:apache /var/www
chmod 2775 /var/www && find /var/www -type d -exec sudo chmod 2775 {} \;
find /var/www -type f -exec sudo chmod 0664 {} \;
# Start Apache and MariaDB
systemctl start httpd
systemctl enable httpd
systemctl start mariadb
systemctl enable mariadb
mysql -e "UPDATE mysql.user SET Password = PASSWORD('LunchAndLearn2020') WHERE User = 'root'"
systemctl restart mariadb
cd /var/www/html
rm -rf *
# Install this simple Todo app
git clone -b master https://github.com/vrioux/demotroistier1 .
sed -i.bak "s/<password>/LunchAndLearn2020/;" /var/www/html/index.php
sed -i.bak "s/<dbhost>/127.0.0.1/;" /var/www/html/index.php

NE PAS OUBLIER SECURITY GROUP port 80
AJOUTER TAG Name=qqch

[Multi-tier]
-----------------------------
# Tier BD :
#!/bin/bash
# Update packages
yum update –y
# Install MariaDB
#amazon-linux-extras install -y lamp-mariadb10.2-php7.2
yum install -y mariadb-server
# Start MariaDB
systemctl start mariadb
systemctl enable mariadb
mysql -e "UPDATE mysql.user SET Password = PASSWORD('LunchAndLearn2020') WHERE User = 'root'"
systemctl restart mariadb

Tier app :
ATTENTION changer le PRIVATE ip tu sed ci-dessous
Après, modifier SG du DB tier pour être accessible de app
Ne pas oublier 80 from world

#!/bin/bash
# Update packages
yum update –y
# Install Apache, PHP
amazon-linux-extras install -y lamp-mariadb10.2-php7.2 php7.2
yum install -y httpd mariadb-server git
# Set users
usermod -a -G apache ec2-user
chown -R ec2-user:apache /var/www
chmod 2775 /var/www && find /var/www -type d -exec sudo chmod 2775 {} \;
find /var/www -type f -exec sudo chmod 0664 {} \;
# Start Apache and MariaDB
echo Header set Access-Control-Allow-Origin "*" >> /etc/httpd/conf/httpd.conf
awk '/Require method/ { print; print "    Header set Access-Control-Allow-Origin \"*\" "; next }1' /etc/httpd/conf.d/userdir.conf > /etc/httpd/conf.d/userdir.conf
systemctl start httpd
systemctl enable httpd
cd /var/www/html
rm -rf *
# Install this simple Todo app
git clone -b master https://github.com/vrioux/demotroistier1 .
sed -i.bak "s/<password>/LunchAndLearn2020/;" /var/www/html/index.php
sed -i.bak "s/<dbhost>/172.31.4.62/;" /var/www/html/index.php
# garder juste le php
rm -f *.html

Tier web :
ATTENTION changer le PUBLIC ip du sed ci-dessous
Ne pas oublier 80 from world

#!/bin/bash
# Update packages
yum update –y
# Install Apache
#amazon-linux-extras install -y lamp-mariadb10.2-php7.2
yum install -y httpd git
# Set users
usermod -a -G apache ec2-user
chown -R ec2-user:apache /var/www
chmod 2775 /var/www && find /var/www -type d -exec sudo chmod 2775 {} \;
find /var/www -type f -exec sudo chmod 0664 {} \;
# Start Apache
systemctl start httpd
systemctl enable httpd
cd /var/www/html
rm -rf *
# Install this simple Todo app
git clone -b master https://github.com/vrioux/demotroistier1 .
sed -i.bak "s/<apihost>/35.183.78.3/;" /var/www/html/index.html
# garder juste le html
rm -f *.php
