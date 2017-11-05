#!/bin/bash
red=`tput setaf 1`
green=`tput setaf 2`
yellow=`tput setaf 3`
reset=`tput sgr0`
echo "${yellow}"
echo "__________.___________________ _________  "
echo "\______   \   \__    ___/  _  \\______   \ "
echo " |     ___/   | |    | /  /_\  \|     ___/ "
echo " |    |   |   | |    |/    |    \    |     "
echo " |____|   |___| |____|\____|__  /____|     "
echo "                              \/      ${red}v0.3${reset}"
echo ""
echo "Use CTRL+C to exit"
echo ""

#Set Variables
interface=eth0		#interface
directory=~/loot 	#directory to save the files
duration=10 		#seconds duration
bytes=1 		#maximum bytes per file

if [ ! -d "$directory" ]
then
	mkdir ~/loot
fi

cd $directory

#Check if you are running as a root
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

#Start passive monitoring 

#Run tcpdump for x seconds
echo "Tcpdump on interface $interface"
#port is in used modify if not need.

tcpdump 'portrange <select port range> or port <select port>'-n -s 0 -G $duration -C $bytes -i $interface -w  trace-%Y-%m-%d_%H:%M:%S  &>/dev/null
echo "Exiting from pitap"
