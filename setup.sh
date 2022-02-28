#!/bin/sh
CYAN='\033[0;36m'
NC='\033[0m'
GRE='\033[0;32m'
echo "\n${CYAN}########## Welcome! This script will turn your Raspberry Pi into  ##########"
echo          "########## a WiFi Access Point that will forward traffic through  ##########"
echo          "########## the ethernet port. Simply plug an ethernet cable into  ##########"
echo          "########## your Raspberry Pi, run this script, enter your desired ##########"
echo          "########## name and password, then reboot! Your network will then ##########"
echo          "########## be visible. Connect as you would to other networks!    ##########"



echo "\n${GRE}Setting up WiFi Access Point...${NC}"

read -p "Enter your desired WiFi Network Name: " ssid
read -p "Enter your desired password: " pw1
read -p "Enter your desired password (again): " pw2

if [ X"$pw1" = X"$pw2" ]
then
    sudo raspi-config nonint do_wifi_country US
    sudo apt-get install dnsmasq hostapd -y
    sudo DEBIAN_FRONTEND=noninteractive apt-get install -y netfilter-persistent iptables-persistent
    sudo sed -i '$ainterface wlan0\nstatic ip_address=10.20.1.1/24\nnohook wpa_supplicant' /etc/dhcpcd.conf
    sudo touch /etc/sysctl.d/routed-ap.conf
    echo "net.ipv4.ip_forward=1" | sudo tee /etc/sysctl.d/routed-ap.conf
    sudo iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
    sudo netfilter-persistent save
    sudo mv /etc/dnsmasq.conf /etc/dnsmasq.conf.orig
    sudo touch /etc/dnsmasq.conf
    echo "interface=wlan0" | sudo tee /etc/dnsmasq.conf
    sudo sed -i '$adhcp-range=10.20.1.5,10.20.1.100,255.255.255.0,24\ndomain=ap\naddress=/rpi.ap/10.20.1.1' /etc/dnsmasq.conf
    sudo touch /etc/hostapd/hostapd.conf
    echo "country_code=US" | sudo tee /etc/hostapd/hostapd.conf
    sudo sed -i -e '$a\' -e "interface=wlan0\nssid=${ssid}\nhw_mode=g\nchannel=2\nmacaddr_acl=0\nauth_algs=1\nignore_broadcast_ssid=0\nwpa=2\nwpa_passphrase=${pw1}\nwpa_key_mgmt=WPA-PSK\nwpa_pairwise=TKIP\nrsn_pairwise=CCMP" /etc/hostapd/hostapd.conf
    sudo systemctl unmask hostapd.service
    sudo systemctl enable hostapd.service
    echo "\n\n\n"
    echo          "########## All Done! The RPi IP Address is 10.20.1.1 ##########"
    echo          "########## You can also access your RPi at rpi.ap    ##########"
    echo          "########## Please reboot for changes to take effect  ##########"
    echo "\n\n\n"
else
    echo "Passwords do not match! Please run the script again"
    exit
fi
