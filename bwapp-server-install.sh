#!/bin/bash

echo "🛠️ Starting bWAPP setup..."

# Update system
sudo apt update && sudo apt upgrade -y

# Install LAMP stack components
echo "📦 Installing Apache, MySQL, PHP..."
sudo apt install apache2 mysql-server php php-mysqli libapache2-mod-php unzip wget -y

# Enable and start Apache
echo "🚀 Starting Apache..."
sudo systemctl enable apache2
sudo systemctl start apache2

# Start MySQL
sudo systemctl enable mysql
sudo systemctl start mysql

# Download bWAPP
echo "📥 Downloading bWAPP..."
cd /var/www/html
sudo rm -rf index.html
sudo wget https://sourceforge.net/projects/bwapp/files/bWAPP/bWAPP_latest.zip/download -O bwapp.zip
sudo unzip bwapp.zip
sudo mv bWAPP* bwapp
sudo rm bwapp.zip

# Set permissions
echo "🔐 Setting permissions..."
sudo chown -R www-data:www-data /var/www/html/bwapp
sudo chmod -R 755 /var/www/html/bwapp

# Create MySQL database and user
echo "🗃️ Configuring MySQL..."
sudo mysql -e "CREATE DATABASE bwapp;"
sudo mysql -e "CREATE USER 'bwapp'@'localhost' IDENTIFIED BY 'bug';"
sudo mysql -e "GRANT ALL PRIVILEGES ON bwapp.* TO 'bwapp'@'localhost';"
sudo mysql -e "FLUSH PRIVILEGES;"

# Optional: open port 80 in UFW
if sudo ufw status | grep -q "Status: active"; then
  echo "🌐 Allowing HTTP traffic through firewall..."
  sudo ufw allow 80/tcp
fi

echo "✅ bWAPP setup complete!"
echo "👉 Visit http://<your-server-ip>/bwapp/install.php in your browser to finish setup."
