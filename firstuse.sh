chmod +x mc
git clone https://github.com/overviewer/Minecraft-Overviewer overviewer
python3 overviewer/setup.py build
wget https://api.papermc.io/v2/projects/paper/versions/1.20.1/builds/174/downloads/paper-1.20.1-174.jar -O 1.20.1-paper.jar
wget https://piston-data.mojang.com/v1/objects/84194a2f286ef7c14ed7ce0090dba59902951553/server.jar -O 1.20.1.jar
wget https://raw.githubusercontent.com/DMBuce/mcexplore/master/mcexplore.py -O mcexplore.py
mkdir maps
touch maps/seeds
touch session
socket=$(grep -o 'socket="[^"]*"' mc | cut -d'"' -f2 | sed 's/\//\\\//g')
sed -i "s/__SOCKET__/${socket}/g" minecraft@.service
rm $0
