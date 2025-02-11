# Use Ubuntu as the base image
FROM ubuntu:latest

# Install required packages
RUN apt-get update && apt-get install -y \
    curl \
    ca-certificates \
    apache2 \
    php \
    git \
    certbot \
    python3-certbot-apache && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Enable Apache SSL module and rewrite module
RUN a2enmod ssl rewrite

# Clone the repository
RUN git clone https://github.com/fastrackcloud/website-automation.git /website-automation

# Copy website files to the Apache web root
RUN cp -r /website-automation/* /var/www/html/ && \
    mv /var/www/html/htaccess /var/www/html/.htaccess

# Expose HTTP and HTTPS ports
EXPOSE 80 443

# Set entrypoint script
CMD ["/bin/bash", "-c", "
    if [ \"$RUN_CERTBOT\" = \"true\" ]; then
        echo 'Running Certbot for SSL...'
        certbot --apache -n --agree-tos --email admin@fastrackcloud.com \
          -d www.fastrackcloud.com -d fastrackcloud.com --redirect
    fi
    if [ \"$CERTBOT_RENEWAL\" = \"true\" ]; then
        echo 'Setting up Certbot auto-renewal...'
        echo '0 0 */60 * * certbot renew --quiet' | crontab -
    fi
    echo 'Starting Apache...'
    apachectl -D FOREGROUND
"]
