# yadtube-dlp
A simple yt-dlp GUI built with yad to download Youtube videos and audio.

# Demo
![til](./video.gif)

# IMPORTANT
On some distros like Ubuntu 24.04, the yt-dlp package from the distro repository (e.g. apt) is broken. It doesn't allow to
download any videos. So first check if it's able to download running: <br/> 
`yt-dlp [URL] -f 'bv*[height=1080]+ba`

If it gives no error, you can continue.

Otherwise, remove yt-dlp and proceed to script installation. Don't worry, the script will download the package from the official yt-dlp GitHub repository, wich works.

# Installation
`git clone https://github.com/triboremen/yadtube-dlp`<br/>
`cd yadtube-dlp` <br/>
`chmod + yadtube-dlp.sh` <br/>
`./yadtube-dlp.sh` <br/>

The script will check if all necesary packages are installed. Just follow it instructions.

# Usage
Just go to the folder where the script is and run it:
`./yadtube-dlp.sh`
A menu will pop up. Just select the options you want.
The script will store the downloaded files in the `~/Downloads` folder.

# Adding to PATH
In order to execute the script whenever you are in the machine, just:

`cp script-folder/yadtube-dlp ~/.local/bin;reboot`

# Additional info
Tested on Ubuntu 24.04 with latest updates
