#!/bin/bash

#Add user
echo "Creating the user that runs the experiment (eve)"
adduser eve
adduser eve pi
adduser eve sudo 
adduser eve gpio
adduser eve i2c



#Enable I2C
echo "dtparam=i2c_arm=on" >> /boot/firmware/config.txt
echo "i2c-dev" >> /etc/modules


#Install Packages
apt update -y && apt upgrade -y
apt install -y git python3 python3-pip python3-dev python3-venv libatlas-base-dev
#apt install -y nfs-kernel-server vim tmux

#Git Clone Repo
mkdir /eve
git clone https://github.com/hw5e/eve-pi.git /eve -b test


python3 -m venv /eve/venv

umask 022
/eve/venv/bin/pip3 dash_html_components install dash_core_components adafruit-circuitpython-ads1x15 adafruit-circuitpython-mcp230xx adafruit-circuitpython-onewire adafruit-circuitpython-ds18x20 adafruit-circuitpython-pca9685 numpy slackclient==1.3.2 pandas matplotlib configparser tornado dash scipy w1thermsensor


#Copy Service to Location
cp /eve/webui/eve_webui.service /lib/systemd/system/eve_webui.service
chmod 644 /lib/systemd/system/eve_webui.service
systemctl enable eve_webui

#Setup file storage

#Setup WebUI
/eve/webui/tools/init.py --no-npm

cp /eve/scripts/live/sample-conf.ini /eve/scripts/live/eve-conf.ini

#Reboot
echo ""
echo ""
echo "Setup Complete."
read -r -p "Reboot Now? (Y/n): " reb_tog
case "$reb_tog" in
    [yY][eE][sS]|[yY]) 
        reboot
        ;;
    *)
esac

