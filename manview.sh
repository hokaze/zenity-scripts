#!/bin/bash
# Manual Page Viewer using zenity v0.2 by HoKaze

#tests to see if a page was queried on the command line
if [ -z "$1" ]; then

	#zenity dialog for entering a page to view
	manpage=$(zenity --entry --text "Which manual page?" --entry-text "" --title "Manual Viewer")

else
	
	#sets the page	based on the command line parameter
	manpage=$1
fi

#tests if man page exists or not and displays notification before exiting
checkpage=$(man $manpage)
if [ -z "$checkpage" ]; then
	zenity --error --title "Manual Viewer"	 --text="The requested man page does not exist."
	exit 1
fi

#zenity dialog that displays the man page
man $manpage | zenity --text-info --title "Manual Viewer" --width 640 --height 480

#closes program
exit 0
