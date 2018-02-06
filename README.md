# What is this?

It's a simple bash script for starting an SSL tunnel and an OpenVPN connection
based on a directory system.

# How can I use this?

* You need to acquire .ssl and .ovpn files for your VPN.

* Create a folder where you will keep your VPN files

`mkdir /home/VPN/`

* Copy your .ssl and .ovpn files based on this structure.

* Each server has it's own folder. Say you have VPN servers in New York, Budapest and Tokyo. Create three folders for them.

`cd /home/VPN/`

`mkdir NewYork Budapest Tokyo`

* Copy your corresponding .ssl and .ovpn files into the directories

* Clone into this repository

`git clone https://github.com/plaktos/startvpn-sh.git`

* Copy the script into the root folder of your VPN directory

`cp startvpn-sh/startvpn.sh startvpn.sh`

* Run the script, you need superuser privileges

`sudo ./startvpn.sh`

* Pick a server and press enter.
