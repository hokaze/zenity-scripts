#!/bin/bash
#file cleanup script by HoKaze (version 0.2)

#runs this script as root if not already
chk_root () {

  if [ ! $( id -u ) -eq 0 ]; then
    exec gksu "${0}" # call this script as root
    exit ${?}  # since we're 'execing' above, we wont reach this exit
               # unless something goes wrong.
  fi

}

#this calls the earlier chk_root function
chk_root

#this creates a zenity checklist for the cleanup options
ans=$(zenity --width 400 --height 280  --list --title "File Cleaner" --text "Please select cleanup options" --checklist  --column "Pick" --column "options" autoclean "Remove partial packages" clean "Clean apt-get cache" autoremove "Remove unneeded dependencies" residual "Clean leftover config from removed packages" localepurge "Remove unneeded locales" clearFScache "Clear filesystem memory cache" rmbrokensym "Remove broken symlinks (use at own risk)" --separator=" : ")

#this checks if the autoclean option was selected and runs it
if [[ $ans == *"Remove partial packages"* ]]; then
	echo -e "\n-Remove partial packages-" >> /tmp/cleanup_log.txt
	apt-get autoclean >> /tmp/cleanup_log.txt
	fi

#this checks if the clean option was selected and runs it
if [[ $ans == *"Clean apt-get cache"* ]]; then
	echo -e "\n-Clean apt-get cache-" >> /tmp/cleanup_log.txt
	apt-get clean >> /tmp/cleanup_log.txt
	fi

#this checks if the autoremove option was selected and runs it
if [[ $ans == *"Remove unneeded dependencies"* ]]; then
	echo -e "\n-Remove unneeded dependencies-" >> /tmp/cleanup_log.txt
	apt-get autoremove >> /tmp/cleanup_log.txt
	fi

#this checks if the residual option was selected and runs it
if [[ "$ans" == *"Clean leftover config from removed packages"* ]]; then
	echo -e "\n-Clean leftover config from removed packages-" >> /tmp/cleanup_log.txt
	dpkg -l | grep -i ^rc | awk '{print $1}' | xargs -n 10 aptitude -y purge >> /tmp/cleanup_log.txt
	fi

#this checks if the locale option was selected and runs it
if [[ $ans == *"Remove unneeded locales"* ]]; then
	x-terminal-emulator -e apt-get install localepurge
	fi

#this checks if clearFScache option was selected and runs it
if [[ $ans == *"Clear filesystem memory cache"* ]]; then
	sync
	echo 3 > /proc/sys/vm/drop_caches
	fi

#this checks if the rmbrokensym option was selected and runs it
if [[ $ans == *"Remove broken symlinks (use at own risk)"* ]]; then
	echo -e "\n-Remove broken symlinks-" >> /tmp/cleanup_log.txt
	cd /
	find -L . -type l -print0 | xargs -0 --no-run-if-empty rm
>> /tmp/cleanup_log.txt
	fi

#opens the log file created
cat /tmp/cleanup_log.txt | zenity --title "File Cleanup Log" --text-info --width 500 --height 350
