# Alpino in Docker #

With `alpino.bash` you can run Alpino inside Docker. This was tested on
Linux.

About Alpino: http://www.let.rug.nl/vannoord/alp/Alpino/


## Upgrade ##

If you have been using an older version of `alpino.bash`, you may need
to update the Docker image, before using the new script:

    docker pull rugcompling/alpino:latest


## Starting Alpino in Docker ##

There are two ways of starting Alpino in Docker.

**1:** This brings you into a bash shell inside Docker, where you can run
Alpino itself:

    alpino.bash $HOME/alpino

Inside the shell, there is a virtual directory `~/data` that corresponds
to the real directory you gave as an argument to the script, in this
case `$HOME/alpino`. You use it to save and access data on your regular
file system.

**2:** You can also run a single command, without going to the shell first:

    alpino.bash $HOME/alpino Alpino

In this case, there is no directory `~/data` in Docker, but there is
`/work/data` with the same purpose.


## Examples of running Alpino inside Docker ##

Inside Docker, you can run Alpino interactively, or as a command line
tool.


### Interactive use ###

This starts the Alpino GUI:

    Alpino

This GUI is only available if you are running Docker on your local
machine. If you logged in to a remote machine and run Docker there, then
Alpino can't access the X11 server on your local machine.
(Perhaps this will be fixed someday.)

This starts and interactive version of Alpino without the GUI:

    Alpino -notk


### Use as a command line tool ###

This tokenizes and parses the text from `~/data/text.txt` and saves the
results in the directory `~/data/xml`:

	cd ~/data
	mkdir xml
    partok text.txt | Alpino -flag treebank xml debug=1 end_hook=xml user_max=900000 -parse
