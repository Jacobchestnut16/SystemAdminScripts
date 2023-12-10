#!/bin/bash

# Function to create a new website
create_website() {
    # Get information from user
    read -p "Enter the domain name for the website (e.g., example.com): " domain

    # Validate domain name
    if [[ ! $domain =~ ^[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$ ]]; then
        echo "Invalid domain name. Please enter a valid domain name."
        exit 1
    fi

    # Set up Apache virtual host
    cat <<EOF | sudo tee /etc/apache2/sites-available/$domain.conf > /dev/null
<VirtualHost *:80>
    ServerAdmin webmaster@$domain
    ServerName $domain
    DocumentRoot /var/www/$domain

    ErrorLog \${APACHE_LOG_DIR}/error.log
    CustomLog \${APACHE_LOG_DIR}/access.log combined

    <Directory /var/www/$domain>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>
</VirtualHost>
EOF

    # Enable the virtual host
    sudo a2ensite $domain.conf

    # Reload Apache
    sudo systemctl reload apache2

    # Create an index.html file for testing
    echo "<html><body><h1>Welcome to $domain!</h1></body></html>" | sudo tee /var/www/$domain/index.html > /dev/null

    # Display information to the user
    echo "Website $domain created successfully."
    echo "Document root: /var/www/$domain"
}

# Check if Apache is installed
if ! command -v apache2 &> /dev/null; then
    echo "Apache is not installed. Please install Apache and run the script again."
    exit 1
fi

# Check if MySQL is installed
if ! command -v mysql &> /dev/null; then
    echo "MySQL is not installed. Please install MySQL and run the script again."
    exit 1
fi

# Check if PHP is installed
if ! command -v php &> /dev/null; then
    echo "PHP is not installed. Please install PHP and run the script again."
    exit 1
fi

# Call the function to create a new website
create_website
