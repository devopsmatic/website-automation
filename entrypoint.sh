#!/bin/bash

# Enable SSL if required
if [ "$RUN_CERTBOT" = "true" ]; then
    echo "Running Certbot for SSL..."
    certbot --apache -n --agree-tos --email admin@fastrackcloud.com \
      -d www.fastrackcloud.com -d fastrackcloud.com --redirect
fi

# Setup SSL auto-renewal if required
if [ "$CERTBOT_RENEWAL" = "true" ]; then
    echo "Setting up Certbot auto-renewal..."
    echo "0 0 */60 * * certbot renew --quiet" | crontab -
fi

# Start Apache
echo "Starting Apache..."
exec apachectl -D FOREGROUND
