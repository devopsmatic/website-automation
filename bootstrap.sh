#!/bin/bash
sudo apt-get update
sudo apt-get install apache2 php git -y
sudo systemctl enable apache2.service
sudo systemctl start apache2
sudo git clone https://github.com/devopsmatic/website-automation.git
sudo cp ./website-automation/* /var/www/html
sudo mv /var/www/html/htaccess /var/www/html/.htaccess
sudo sed -i '19iDirectoryIndex index.php /html/index.php' /etc/apache2/sites-available/000-default.conf 
sudo systemctl restart apache2

