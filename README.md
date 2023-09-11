# Minecraft Server for Linux
This is a template for how to organize a Minecraft server on Linux.

## Requirements:
 - ```python3```, ```systemctl``` and ```tmux``` must be installed on the system.
 - I also recommend at least one Raspberry Pi 4 for the server with at least (preferably more) 16 GB of storage space and 4 GB of RAM (preferably more). With the specified specs, a Vanilla Jar is enough for 5-8 players, and Paper for 12-15 players.

## Installation:
Download everything (```git clone https://github.com/Simonesien/mcserver/```) and change the variables at the beginning of the ```mc``` file where necessary. Then run the firstuse.sh script (```chmod +x firstuse.sh; ./firstuse.sh```). If necessary, also change the user and group with whose permissions the server will later run with in ```minecraft@.service```.

For my own purposes I also have a cron job running every 2 hours (0 &midast;/2 &midast; &midast; &midast;) with the command ```. /home/pi/minecraft-server/session && /home/pi/minecraft-server/mc $session restart && unset session``` to restart automatically.

## Capabilities / Use:
With this tool, you can manage your minecraft worlds. You can enable or disable them across server restarts, you can quickly move from one world to an other, have the server console stay in the background, but be accessible at any time, pre-generate seeds to look at or render an existing world to a browser view.

To create a world, run ```./mc worldname create```. For permanent starting ```./mc worldname enable```, for one-time starting ```./mc worldname start```.
You can render a specific or random seed to a browser view using ```./mc seed render``` respectively ```./mc random render```. To generate an overview of an existing world, run ```./mc worldname overview```. Outputs will be saved to ```./maps/```.
Help is available with ```./mc help```.

If you've developed some improvement for this code yourseld, feel free to open a pull request or issue.

Credits for render and overview: [DMBuce](https://github.com/DMBuce/mcexplore), [Minecraft-Overviewer Project](https://github.com/overviewer/Minecraft-Overviewer)
