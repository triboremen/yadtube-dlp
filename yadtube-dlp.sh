#!/bin/bash

pkgs_list=('yad' 'zenity' 'gawk' 'yt-dlp' 'ffmpeg')

for package in ${pkgs_list[@]}
do
	which $package > /dev/null
	if [[ $? > 0 ]]
	then
		echo "$package is not installed"
		echo $package >> missing-pkgs
	fi
done

if [ -f missing-pkgs ]
then
	while true
	do
		echo
		read -p "These packages are necessary for this script. You want to install them (y/n) " ans
		echo
		case $ans in
			Y | y )
			if grep -q "yt-dlp" missing-pkgs
				then
					if [ ! -d ~/.local/bin ]
					then
						mkdir ~/.local/bin
					fi
					wget https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -O ~/.local/bin/yt-dlp
					chmod a+rx ~/.local/bin/yt-dlp
					sed -e "s/yt-dlp//g" -i missing-pkgs
			fi
			sudo apt install -y $(<missing-pkgs)
			rm missing-pkgs
			while true
			do	echo
				read -p "In order to add yt-dlp package to PATH, is necessary to reboot the machine. Do you want to do it now? (y/n) " ans
				echo
				case $ans in
					Y | y )
					sudo reboot
					break;;
					
					N | n )
					break;;
					
					* )
					echo "Invalid answer"
				esac
			done
			break;;
			
			N | n )
			break;;
			
			* )
			echo "Invalid answer"
		esac
	done
fi

opt1="Download video"
opt2="Download audio"

menu=$(zenity --list --title="yadtube-dlp" --radiolist \
--width=400 --height=300 \
--column="" --column="" \
FALSE "$opt1" \
FALSE "$opt2" )

case $menu in

	$opt1 )
		video() {
		exec > $tempfile 2>&1
		date > /dev/null
		yt-dlp "$url" "$quality" -o ~/Downloads/"%(title)s.%(ext)s"
		}

		menu=$(yad --title="yadtube-dlp" \
		--form \
		--width=600 \
		--height=300 \
		--field="Video URL: " "" \
		--field="Quality":CB "The best"\!"1080p Max"\!"720p Max" \
		--button="OK" )


		timestamp=$(date +%d-%m-%Y:%H:%M)
		url=$(echo $menu | gawk -F'|' '{ print $1 }')
		quality=$(echo $menu | gawk -F'|' '{ print $2 }')
		tempfile=$(mktemp -t yt-dlp.XXXXXX)


		if [ "$quality" == "The best" ]
		then
			quality="-f bestvideo+bestaudio"

		elif [ "$quality" == "1080p Max" ]
		then
			quality="-f bestvideo[height<=1080]+bestaudio"

		elif [ "$quality" == "720p Max" ]
		then
			quality="-f bestvideo[height<=720]+bestaudio"
		fi


		video \
		| tail -f $tempfile \
		| yad --text-info --title="Downloading..." \
		--button="Cancel":"pkill yt-dlp" \
		--button="Exit" \
		--button="OK":1 \
		--width=900 --height=500 > $tempfile --tail

		rm -f $tempfile
		;;
	$opt2 )
		audio() {
		exec > $tempfile 2>&1
		date > /dev/null
		yt-dlp "$url" -f bestaudio -x --audio-format mp3 -o ~/Downloads/"%(title)s.%(ext)s"
		}

		menu=$(yad --title="yadtube-dlp" \
		--form \
		--width=600 \
		--height=200 \
		--field="URL: " "" \
		--button="OK" )

		timestamp=$(date +%d-%m-%Y:%H:%M)
		url=$(echo $menu | gawk -F'|' '{ print $1 }')
		tempfile=$(mktemp -t yt-dlp.XXXXXX)


		audio \
		|tail -f $tempfile \
		| yad --text-info --title="Downloading..." \
		--button="Cancel":"pkill yt-dlp" \
		--button="Exit" \
		--button="OK":1 \
		--width=900 --height=500 > $tempfile --tail

		rm -f $tempfile
		;;
esac
exit
