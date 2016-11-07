# Set MySQL root password
debconf-set-selections <<< 'mysql-server-5.5 mysql-server/root_password password root'
debconf-set-selections <<< 'mysql-server-5.5 mysql-server/root_password_again password root'

# Install packages
apt-get update
apt-get -y install mysql-server-5.5 php5-mysql libsqlite3-dev apache2 php5 php5-dev build-essential php-pear ruby1.9.1-dev php5-gd php5-curl

# Set timezone
echo "America/New_York" | tee /etc/timezone
dpkg-reconfigure --frontend noninteractive tzdata

# Setup database
echo "DROP DATABASE IF EXISTS test" | mysql -uroot -proot
echo "CREATE USER 'devdb'@'localhost' IDENTIFIED BY 'devdb'" | mysql -uroot -proot
echo "CREATE DATABASE devdb" | mysql -uroot -proot
echo "GRANT ALL ON devdb.* TO 'devdb'@'localhost'" | mysql -uroot -proot
echo "FLUSH PRIVILEGES" | mysql -uroot -proot

# Apache changes
echo "ServerName localhost" >> /etc/apache2/apache2.conf
a2enmod rewrite
cat /var/custom_config_files/apache2/default | tee /etc/apache2/sites-available/000-default.conf

# Install Mailcatcher
echo "Installing mailcatcher"
echo "install mime types"
gem install mime-types --version "< 3"
gem install mailcatcher --no-ri --no-rdoc
mailcatcher --http-ip=192.168.56.1

# Configure PHP
echo "Configuring PHP"
#sudo php5enmod opcache
sed -i '/;sendmail_path =/c sendmail_path = "/usr/local/bin/catchmail"' /etc/php5/apache2/php.ini
sed -i '/display_errors = Off/c display_errors = On' /etc/php5/apache2/php.ini
sed -i '/error_reporting = E_ALL & ~E_DEPRECATED/c error_reporting = E_ALL | E_STRICT' /etc/php5/apache2/php.ini
sed -i '/html_errors = Off/c html_errors = On' /etc/php5/apache2/php.ini
sed -i '/upload_max_filesize = 2M/c  upload_max_filesize 10M' /etc/php5/apache2/php.ini
sed -i '/post_max_size = 8M/c post_max_size = 20M' /etc/php5/apache2/php.ini
sed -i '/opcache.enable=0/c opcache.enable=1' /etc/php5/apache2/php.ini
sed -i '/;opcache.memory_consumption=64/c opcache.memory_consumption=128' /etc/php5/apache2/php.ini
sed -i '/max_execution_time = 30/c max_execution_time = 120' /etc/php5/apache2/php.ini
#sed -i '/memory_limit = 128M/c memory_limit = 1024M' /etc/php5/apache2/php.ini

# Make sure things are up and running as they should be




#Install Git
echo "Installing Git"
apt-get -y install git

#Install Drush
echo "Installing drush ... "
sudo apt-get -y install curl
sudo curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer
sudo ln -s /usr/local/bin/composer /usr/bin/composer
sudo git clone https://github.com/drush-ops/drush.git /usr/local/src/drush
cd /usr/local/src/drush
sudo git checkout $drushVersion
sudo ln -s /usr/local/src/drush/drush /usr/bin/drush
sudo composer install
service apache2 restart