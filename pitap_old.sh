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

#Set Variables before running the script.

#Interface to be monitored.
interface=any
#Directory to save the data change between local and usb directory.
directory=~/loot
#directory=/media/USB
#Duration in seconds to write in the file (default to one day).
duration=86400 		#seconds duration
#Maximum bytes per file.
bytes=		#maximum bytes per file

if [ $directory == "/media/USB" ]
then
  #wait until usb is recognized
  sleep 100

  #Mount USB
  if [ ! -d "$directory" ]
  then
    mkdir /media/USB
  fi

  sudo mount -t vfat -o rw /dev/sda /media/USB
else
  if [ ! -d "$directory" ]
  then
  mkdir $directory
  fi
fi

cd $directory

#Check if you are running as a root
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

#Start passive monitoring 

#Run tcpdump for x seconds
echo "Tcpdump on interface $interface time $(date +'%m-%d-%Y:%H:%M:%S')"

#port is in used modify if not need.
# tcpdump 'portrange 0-100 or port 222'-n -s 0 -G $duration -C $bytes -i $interface -w  trace-%Y-%m-%d_%H:%M:%S  &>/dev/null
tcpdump -n -s 0 -G $duration -C $bytes -i $interface -w  trace-%Y-%m-%d_%H:%M:%S  &>/dev/null
echo "Exiting from pitap"
