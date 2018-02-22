alias alias-edit='gedit ~/.bash_aliases'
alias adb-wear-connect='adb -d forward tcp:5601 tcp:5601'

#alias sshpi='ssh pi@192.168.15.151'
#alias sshfspi='sshfs  pi@192.168.15.151:/mnt/usb/ ~/pi-usb'
#alias sshfspi-remove='fusermount -u ~/pi-usb'

alias sshpi2='ssh pi@bifrost.thenaterhood.com -p42000'
alias sshfspi2='sshfs -p42000 pi@bifrost.thenaterhood.com:/mnt/usb/ ~/pi2'
alias sshfspi2-remove='fusermount -u ~/pi2'

alias sshrepkap11='ssh repkap11.com'
alias sshfsrepkap11='mkdir ~/repkap11 ; sshfs repkap11.com:/ ~/repkap11'
alias sshfsrepkap11-remove='fusermount -u ~/repkap11 ; rmdir ~/repkap11'

#alias sshrepkam09='ssh mark@repkam09.com'
#alias sshfsrepkam09='mkdir ~/repkam09 ; sshfs mark@repkam09.com:/home/mark/website/dl ~/repkam09'
#alias sshfsrepkam09-remove='fusermount -u ~/repkam09 ; rmdir ~/repkam09'
alias xclip="xclip -selection c"

alias gs="git status"
alias gd="git diff"
alias gdc="git diff --cached"
alias gka="gitk --all &"
alias u="sudo apt update ; sudo apt upgrade"
