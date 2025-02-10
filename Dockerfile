FROM ubuntu:latest

# Install required packages
RUN apt-get update && apt-get install -y \
    apache2 \
    php \
    git \
    curl \
    certbot \
    python3-certbot-apache && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Clone the repository
RUN git clone https://github.com/fastrackcloud/website-automation.git

# Copy website files to the Apache web root
RUN cp -r ./website-automation/* /var/www/html/ && \
    mv /var/www/html/htaccess /var/www/html/.htaccess

# Update Apache configuration
RUN sed -i '19iDirectoryIndex index.php /html/index.php' /etc/apache2/sites-available/000-default.conf

# Enable Apache SSL module and rewrite module
RUN a2enmod ssl rewrite

# Generate SSL certificate using Certbot (requires domain to be properly set up)
RUN certbot --apache -n --agree-tos --email admin@fastrackcloud.com \
    -d www.fastrackcloud.com -d fastrackcloud.com

# Restart Apache to apply SSL configuration
RUN service apache2 restart

# Expose ports 80 and 443
EXPOSE 80 443

# Start Apache in the foreground
CMD ["apachectl", "-D", "FOREGROUND"]
 
