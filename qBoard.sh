#! /bin/bash
######################
# Dependencies:      #
# xclip, xsel, xvkbd #
######################
qClip="/home/doduser/Documents/qboard/qClip"
config="/home/doduser/Documents/qBoard/qboard.config"
split="#!=~=~=!#"
mode=""
qCopy(){
	##############################################################
	# Grab the selected text and put it into the qClip file      #
	# followed by the designated split string                    #
	##############################################################
	echo -e "$(xsel)" >> $qClip
	echo -e "$split" >> $qClip
}
qPaste(){
	#############################################################
	# Paste the next item in the qClip file, and then remove it # 
	#############################################################
	readEntry
	printf "$clip" | awk 'NR>1{print PREV} {PREV=$0} END{printf("%s",$0)}' | xclip -sel clipboard
	# xvkbd -xsendevent -text "\Cv"
	xte 'keydown Control_L' 'key v' 'keyup Control_L'
	((clipSize+=1))
	newFile=$(tail -n +$clipSize "$qClip")
	echo -ne "$newFile" > $qClip
	
	if [ $mode == "Rotate" ]; then
		wordCount=$(wc -l $qClip)
		if [ "${wordCount[0]%% *}" == "0" ]; then
			echo "$clip" >> $qClip
		else
			echo -e "\n$clip" >> $qClip
		fi
		echo "$split" >> $qClip
	fi
}
safeQpaste() {
	##############################################################
	# Paste the next item in the qClip file, but don't remove it # 
	##############################################################
	readEntry
	printf "$clip" | awk 'NR>1{print PREV} {PREV=$0} END{printf("%s",$0)}' | xclip -sel clipboard
	# xvkbd -xsendevent -text "\Cv"
	xte 'keydown Control_L' 'key v' 'keyup Control_L'
}
qDump() {
	#######################################################################
	# Empty the clipboard file to prevent unintended pasting of old stuff #
	#######################################################################
	> $qClip
}
qMode() {
	#################################################################
	# toggle the current mode -- currently supported modes include: #
	# [Standard, Rotate]                                            #
	#################################################################
	if [ $mode == "Standard" ]; then
		mode="Rotate"
	elif [ $mode == "Rotate" ]; then
		mode="Standard"
	fi 
	echo "$mode" > $config
	notify-send -u normal -i /usr/share/icons/gnome/256x256/apps/accessories-text-editor.png "Set qBoard to $mode mode."
}
readMode() {
	######################################################################
	# read the file to get the current mode, and remove it from the file #
	######################################################################
	read -r mode < $config
}
readEntry() {
		###################################################
		# read from the file, and save the entry in $clip # 
		# and the number of lines in $clipSize            #
		###################################################
	clip=""
	clipSize=1
	while IFS='' read -r line; do
		if [ "$line" != "$split" ] ; then
			clip+="$line\n"
			((clipSize++))
		else
			break
		fi
	done < $qClip
	clip=$(printf "$clip" | awk 'NR>1{print PREV} {PREV=$0} END{printf("%s",$0)}')
}
#############################
# Executed code begins here #
#############################
readMode
case $1 in
		"-c")
			qCopy
		;;
		"-p")
			if [ $2 == "--safe" ]; then
				safeQpaste
			else
				qPaste
			fi
		;;
		"-d")
			qDump
		;;
		"-m")
			qMode
		;;
		*)
		;;
esac