alias ll='ls -Fla --group-directories-first'
alias rm='rm -i'
PS1='[Alpino] \w '
HOME=/work
cd ~/data
echo
echo Run \'info\' to get help
echo
if [ "$ADVERSION" != "3" ]
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

EOT
fi
. /work/data/init.sh
