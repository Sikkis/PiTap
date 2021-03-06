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
#Duration in seconds(default to one day).
duration=86400
#Counter for the tcpdump file.
counter=1

#Check if you are running as a root.
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

if [ $directory == "/media/USB" ]
#Remote Directory
then
  #Wait until usb is recognized.
  sleep 10

  #Mount USB.
  if [ ! -d "$directory" ]
  then
    mkdir /media/USB
  fi

  sudo mount -t vfat -o rw /dev/sda /media/USB

else
#Local Directory.
  if [ ! -d "$directory" ]
  then
  mkdir $directory
  fi
fi

cd $directory

#Start passive monitoring .
while [ 1 ]
do  

    #Run tcpdump for x seconds.
    file=tcpdump$counter.pcap
    echo "Tcpdump started on interface $interface time $(date +'%m-%d-%Y:%H:%M:%S')."
    
    tcpdump -G $duration -W 1 -i $interface -s 0 -w $file &>/dev/null
    echo "Tcpdump finished. "
    echo " "
    
    #Compress and rewrite Logfile.
    echo "Compressing Logfile starting to run in the background."
    tar_file="$(date +'%m-%d-%Y_%H-%M-%S').tar.gz"
    tar -czvf $tar_file $file &>/dev/null &
    echo " "
    
    #Keep 2 log files so it can rewrite the previous and tar the new.
    if [ $counter -eq 2 ]
    then
        counter=1
    else
        counter=$(($counter+1))
    fi

done
