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

# Copy and set up the entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Expose HTTP and HTTPS ports
EXPOSE 80 443

# Use the entrypoint script
CMD ["/entrypoint.sh"]
