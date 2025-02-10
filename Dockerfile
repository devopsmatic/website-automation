FROM ubuntu:latest

# Install required packages
RUN apt-get update && apt-get install -y \
    curl \
    ca-certificates \
    apache2 \
    php \
    git && \
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

# Expose ports 80 and 443
EXPOSE 80 443

# Start Apache in the foreground
CMD ["apachectl", "-D", "FOREGROUND"]
