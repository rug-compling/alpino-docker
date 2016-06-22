# Alpino in Docker #

Met `alpino.bash` kun je Alpino in Docker draaien. Dit is getest op
Linux.

Over Alpino zelf, zie: http://www.let.rug.nl/vannoord/alp/Alpino/

## Upgrade ##

Als je eerder een oudere versie van `alpino.bash` hebt gebruikt, zorg er
dan voor dat ook het Docker-image met Alpino is bijgewerkt naar de huidige
versie:

    docker pull rugcompling/alpino:latest

## Starten van Alpino in Docker ##

Voorbeeld van het starten van Docker met Alpino:

    alpino.bash $HOME/alpino

Hierna ben je in een shell in Docker, en kun je Alpino zelf aanroepen.

In de shell is er een directory `~/data` die gelijk is aan de externe
directory die je hebt opgegeven als argument, in dit geval
`$HOME/alpino`. Die directory gebruik je om data uit te wisselen tussen
Docker en je gewone bestandssysteem.

## Voorbeelden van aanroep binnen Docker ##

Eenmaal in de shell kun je Alpino interactief gebruiken, of als command
line tool.

### Interactief gebruik ###

Dit start de GUI van Alpino:

    Alpino

De GUI is alleen beschikbaar als Docker draait op je eigen machine. Als
je vanaf je eigen machine eerst bent ingelogd op een andere machine waar
Docker draait, dan werkt dit niet, omdat Alpino dan geen toegang heeft
tot je X-server. (Misschien wordt dit ooit opgelost.)

Dit start een interactieve versie van Alpino zonder GUI:

    Alpino -notk

### Als command line tool ###

Dit tokeniseert en parst de tekst uit `~/data/text.txt` en bewaart de
resultaten in de directory `~/data/xml`:

	cd ~/data
	mkdir xml
    partok text.txt | Alpino -flag treebank xml debug=1 end_hook=xml user_max=900000 -parse
