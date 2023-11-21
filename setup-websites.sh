#!/bin/bash

# Parse command-line options
while [[ "$#" -gt 0 ]]; do
  case $1 in
    -sites|--sites)
      shift
      siteNames=($1)
      ;;
    *)
      echo "Unknown parameter passed: $1"
      exit 1
      ;;
  esac
  shift
done

# Install Apache
sudo apt update
sudo apt install -y apache2

# Create website directories and set permissions
for site in "${sites[@]}"; do
    sudo mkdir "/var/www/${site}"
    sudo chown -R www-data:www-data "/var/www/${site}"
    echo "${site}" | sudo tee "/var/www/${site}/index.html" > /dev/null
done

# Create virtual host configuration files
for site in "${sites[@]}"; do
    sudo tee "/etc/apache2/sites-available/${site}.conf" > /dev/null <<EOF
<VirtualHost *:80>
    ServerAdmin webmaster@${site}
    ServerName ${site}
    DocumentRoot /var/www/${site}
    ErrorLog \${APACHE_LOG_DIR}/error.log
    CustomLog \${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
EOF
done

# Enable virtual hosts
for site in "${sites[@]}"; do
    sudo a2ensite "${site}.conf"
done

# Restart Apache
sudo service apache2 restart

# Update hosts file
for site in "${sites[@]}"; do
    echo "127.0.0.1 ${site}" | sudo tee -a /etc/hosts > /dev/null
done

echo "Websites set up successfully!"
