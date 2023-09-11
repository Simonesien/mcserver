# Minecraft Server für Linux
## English
 - This is a template for how I organize my Minecraft server.
 - ```python3```, ```systemctl``` and ```tmux``` must be installed on the system.
   - I also recommend at least one Raspberry Pi 4 for the server with at least (preferably more) 16 GB of storage space and 4 GB of RAM (preferably more). With the specified specs, a Vanilla Jar is enough for 5-8 players, and Paper for 12-15 players.

If you want to do the same on your server, download everything (```git clone https://github.com/Simonesien/mcserver/```) and change the variables at the beginning of the ```mc``` file where necessary. You also have to make the file executable (```sudo chmod +x mc```). If necessary, also change the user and group with whose permissions the server will later run with in ```minecraft@.service```.

To start the server for the first time, you have to go to the location of the script (configured in $socket) and create a world ```./mc world1 create```. For permanent starting ```./mc world1 enable```, for one-time starting ```./mc world1 start```. Help is available with ```./mc help```.

For my own purposes I also have a cron job running every 2 hours (0 &midast;/2 &midast; &midast; &midast;) with the command ```. /home/pi/minecraft-server/session && /home/pi/minecraft-server/mc $session restart && unset session``` to restart automatically.

## Deutsch
 - Das hier ist eine Vorlage, wie ich die Organisation meines Minecraft Servers betreibe.
 - Auf dem System müssen ```python3```, ```systemctl``` und ```tmux``` installiert sein.
   - Außerdem empfehle ich für den Server mindestens einen Raspberry Pi 4 mit mindestens (besser mehr) 16 GB Speicherplatz und 4 GB Ram (auch lieber mehr). Mit den angegebenen Specs reicht es mit einem Vanilla Jar für 5-8 Spieler, mit Paper für 12-15 Spieler.

Wenn ihr es auf eurem Server genauso machen wollt, ladet euch alles herunter (```git clone https://github.com/Simonesien/mcserver/```) und ändert die Variablen am Anfang der ```mc``` Datei wo es nötig ist. Ihr müsst die Datei auch noch ausführbar (```sudo chmod +x mc```) machen. Ändert auch, falls nötig, den Benutzer und die Gruppe, mit deren Berechtigungen der Server später laufen soll in ```minecraft@.service```.

Zum erstmaligen Starten des Servers müsst ihr in den Ort des Skriptes (konfiguriert in $socket) gehen und eine Welt erstellen ```./mc world1 create```. Zum dauerhaften Starten ```./mc world1 enable```, zum einmaligen Starten ```./mc world1 start```. Hilfe gibt es mit ```./mc help```.

Für meine Zwecke habe ich zusätzlich noch einen cronjob alle 2 Stunden (0 &midast;/2 &midast; &midast; &midast;) mit dem Command ```. /home/pi/minecraft-server/session && /home/pi/minecraft-server/mc $session restart && unset session``` zum automatischen Neustarten laufen.
