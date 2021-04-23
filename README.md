# Minecraft Server für Linux
 - Das hier ist eine Vorlage, wie ich die Organisation meines Minecraft Servers betreibe. 
 - Auf dem System müssen systemctl und tmux installiert sein. 
 - Über Verbesserungsvorschlägen, z.B. wie ich mehrere Welten gleichzeitig mit verschiedenen Inventaren, gamerules und natürlich Maps spielen kann, würde ich mich natürlich sehr freuen. 
   - (Wirklich wichtig sind aber eigentlich nur das gleichzeitig und die Maps)
 - Wenn ihr ansonsten Ideen zur besseren Performance (außer Bukkit, Spigot und Paper) habt, auch sehr gerne schreiben. 

Wenn ihr es auf eurem Server genauso machen wollt, ladet euch alles herunter und ändert den Pfad "/home/pi/minecraft-server/" zu dem Verzeichnis, in dem ihr alles speichern wollt. Ihr müsst auch noch die Datei minecraft@.service in den Ordner /etc/systemd/system/ legen und die Datei mc ausführbar ([sudo] chmod +x) machen. Ich empfehle für den Server mindestens einen Raspberry Pi 4 sowie mehr als 10 GB Speicherplatz und 4 GB Ram. 
