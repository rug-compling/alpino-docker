# TODO: nano werkt niet als Docker in rootmodus draait
# oplossing? -> https://stackoverflow.com/questions/50658883/how-to-correctly-use-system-user-in-docker-container

alias ..='cd ..'
alias ll='ls -Fla --group-directories-first'
alias rm='rm -i'
alias mc='. /usr/share/mc/bin/mc-wrapper.sh'
PS1='[Alpino] \w '
HOME=/work
cd ~/data
echo
echo Run \'info\' to get help
echo
if [ "$ADVERSION" != "4" ]
then
    echo "There is a new version of 'alpino.bash' and 'alpino.cmd'"
    echo Download the new version from https://github.com/rug-compling/alpino-docker
    echo
fi
if [ ! -f /work/data/init.sh ]
then
    cat <<EOT > /work/data/init.sh
# dit bestand wordt gesourced bij interactief gebruik van Alpino in Docker

# bestand met macrodefinities gebruikt door 'alto', 'dtsearch' en 'dtview'
export ALTO_MACROFILE="$ALTO_MACROFILE"

# voor Tred: volledige attributenset van Alpino gebruiken
#export TRED_ALPINO_FULL=1

#export EDITOR=emacs
export EDITOR=nano
#export EDITOR=vim
EOT
fi
. /work/data/init.sh

export COLUMNS
export LINES

case "$TRED_ALPINO_FULL" in
    1|j|J|ja|Ja|JA|y|Y|yes|Yes|YES|true|True|TRUE)
        echo '!alpino'    >   /work/.tred.d/extensions/extensions.lst
        echo  alpino_full >>  /work/.tred.d/extensions/extensions.lst
        ;;
    *)
        echo  alpino        >   /work/.tred.d/extensions/extensions.lst
        echo '!alpino_full' >>  /work/.tred.d/extensions/extensions.lst
        ;;
esac

