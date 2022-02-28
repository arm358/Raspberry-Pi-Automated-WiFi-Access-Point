# Raspberry-Pi-Automated-WiFi-Access-Point
An automated WiFI Access Point setup script for Raspberry Pis. Turns your Pi into an access point that forwards traffic through the ethernet port. In essence, converts your Raspberry Pi into a WiFi router!


## Instructions
1. Clone the repository using git<br>
    `git clone https://github.com/arm358/Raspberry-Pi-Automated-WiFi-Access-Point`
2. Change directory into the repository<br>
    `cd Raspberry-Pi-Automated-WiFi-Access-Point`
3. Make the script executable<br>
    `sudo chmod +x setup.sh`
4. Run the script<br>
    `./setup.sh`
5. Enter network name, password, and password confirmation
6. Reboot!

## Notes
1. This will create a 2.4ghz WiFi network on channel 2
2. Country code is set to United States
4. To change these settings, edit the `/etc/hostapd/hostapd.conf` file
