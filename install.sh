#!/usr/bin/env bash

# Text Color Variables
GREEN='\033[32m'  # Green
YELLOW='\033[33m' # YELLOW
CLEAR='\033[0m'   # Clear color and formatting

# Setup script for setting up a new macos machine
echo -e "${GREEN}Starting Install !${CLEAR}"

## Setup /etc/sudoers for sudo without password prompt
# echo -e "${GREEN}Setup NOPASSWD for %staff ${CLEAR}"
# sudo grep -q '^%staff' /etc/sudoers || sudo sed -i '' 's/^%admin.*/&\n%staff          ALL = (ALL) NOPASSWD: ALL/' /etc/sudoers

## Command Line Tools for Xcode
# echo "Install command line developer tools"
# xcode-select --install
# xcode-select -p &> /dev/null
# if [ $? -ne 0 ]; then
#   echo "Xcode CLI tools not found. Installing them..."
#   touch /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress;
#   PROD=$(softwareupdate -l |
#     grep "\*.*Command Line" |
#     head -n 1 | awk -F"*" '{print $2}' |
#     sed -e 's/^ *//' |
#     tr -d '\n')
#   softwareupdate -i "$PROD" -v;
# else
#   echo "Xcode CLI tools OK"
# fi

install() {
    sudo apt-get update

    echo -e "${YELLOW}Install apache2${CLEAR}"
    sudo apt-get install -y apache2
    sudo ufw allow "Apache Full"
    
    echo -e "${YELLOW}Install mysql${CLEAR}"
    sudo apt-get install -y mysql-server
    sudo mysql --skip-column-names -B -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'root';"

    echo -e "${YELLOW}Install php5${CLEAR}"
    sudo apt-get install -y php libapache2-mod-php php-mysql
   
    echo -e "${YELLOW}Install python3${CLEAR}"
    sudo apt-get install -y python3-pip
   
    echo -e "${YELLOW}Install phpmyadmin${CLEAR}"
    sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/dbconfig-install boolean true"
    sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/app-password-confirm password root"
    sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/admin-pass password root"
    sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/app-pass password root"
    sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2"
    sudo apt-get -y install phpmyadmin

}

install
