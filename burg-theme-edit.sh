#!/bin/bash
#BURG Theme (background) editor version 0.2 by HoKaze

#runs this script as root if not already
chk_root () {

  if [ ! $( id -u ) -eq 0 ]; then
    echo "Please enter root's password."
    exec su -c "${0}" # call this script as root
    exit ${?}  # since we're 'execing' above, we wont reach this exit
               # unless something goes wrong.
  fi

}

#this calls the earlier chk_root function
chk_root

#main program loop starts here
loop=1
while [ "$loop" = "1" ]
do
	#lists options
	clear
	echo -e "* This is the BURG Theme editor version 0.1 * \n"
	echo "1. Replace background (GUI version, requires zenity)"
	echo "2. Restore default background (command line)"
	echo "3. Install zenity (debian, ubuntu, mint, etc)"
	echo "4. Replace background (command line only version)"
	echo -e "5. Exit \n"

	#this reads input from the user
	echo "Please select an option number:"
	read command

	#this handles which theme to edit (GUI Version)
	if [ "$command" = "1" ]; then

		#checks if zenity is installed, exits if it isn't
		type -P zenity &>/dev/null || { echo "This option requires zenity but it's not installed." >&2; exit 1; }

		#this lists all themes and ignores the conf.d and icons folders
		echo -e "\nChoose a theme to edit:"
		themelist=$(ls /boot/burg/themes/ | grep -v "conf.d" | grep -v "icons")

		#this creates a drop-down list of themes and gets user input
		theme=$(zenity --entry $themelist --text="Choose a theme" --title="BURG Theme Editor")
		
		#this sets the paths for file to load and save	
		themepath=/boot/burg/themes/$theme/
		loadpath=$(zenity --title "Select the image to use" --file-selection)
		savepath=$(zenity --title "Select the image to replace" --file-selection --filename=$themepath --save --confirm-overwrite)

		#this makes a backup of the original image
		mv "$savepath" "$savepath.bak"

		#this copies the new image to the theme's folder and renames it
		cp "$loadpath" "$savepath"
		echo -e "\nDone"
		sleep 3
		fi

	#this handles which theme to restore
	if [ "$command" = "2" ]; then
		echo -e "\nChoose a theme to restore"

		#this lists all themes and ignores the conf.d and icons folders
		ls /boot/burg/themes/ | grep -v "conf.d" | grep -v "icons"
		read theme

		#sets folder of theme and current folder	
		themepath=/boot/burg/themes/$theme/
		originaldirectory=$(pwd)

		#moves to theme folder, restores all .bak files to original filename then moves back to original folder	
		cd $themepath
		ls -1 | awk -F\. '/.bak/ { print "mv " $0, $1".png" }' | bash
		cd $originaldirectory
		echo -e "\nRestored all .png.bak files to .png"
		sleep 3
		fi

	#installs zenity on debian-based distros
	if [ "$command" = "3" ]; then
		apt-get install zenity
		sleep 3
		fi

	#this handles which theme to edit (command-line version)
	if [ "$command" = "4" ]; then
		echo -e "\nChoose a theme to edit:"

		#this lists all themes and ignores the conf.d and icons folders
		ls /boot/burg/themes/ | grep -v "conf.d" | grep -v "icons"
		read theme

		#this sets the paths for file to load and save	
		themepath=/boot/burg/themes/$theme/
		echo "Filepath of file to load:"		
		read loadpath
		echo ""
		ls -l "$themepath"
		echo -e "\nFilename of file to replace:"
		read savepath
		savepath=$themepath$savepath

		#this makes a backup of the original image
		mv "$savepath" "$savepath.bak"

		#this copies the new image to the theme's folder and renames it
		cp "$loadpath" "$savepath"
		echo -e "\nDone"
		sleep 3
		fi

	#ends main loop
	if [ "$command" = "5" ]; then
		loop=0
		fi

#closes program
	done
	echo -e "\nThanks for using my script."
	echo "It still has many bugs and a long way to go..."
	sleep 2
	exit
