# Minecraft Server für Linux
 - Das hier ist eine Vorlage, wie ich die Organisation meines Minecraft Servers betreibe. 
 - Auf dem System müssen systemctl und tmux installiert sein. 
 - Über Verbesserungsvorschlägen, z.B. wie ich mehrere Welten gleichzeitig mit verschiedenen Inventaren, gamerules und natürlich Maps spielen kann, würde ich mich natürlich sehr freuen. 
   - (Wirklich wichtig sind aber eigentlich nur das gleichzeitig und die Maps)
 - Wenn ihr ansonsten Ideen zur besseren Performance (außer Bukkit, Spigot und Paper) habt, auch sehr gerne schreiben. 

Wenn ihr es auf eurem Server genauso machen wollt, ladet euch alles herunter und ändert den Pfad "/home/pi/minecraft-server/" wo es nötig ist (mc, minecraft@.service, evtl. cronjob) zu dem Verzeichnis, in dem ihr alles speichern wollt. Ihr müsst auch noch die Datei minecraft@.service in den Ordner /etc/systemd/system/ legen und die Datei mc ausführbar (```sudo chmod +x```) machen. 
Ich habe zusätzlich noch einen cronjob alle 2 Stunden (0 &midast;/2 &midast; &midast; &midast;) mit dem Command ``` . /home/pi/minecraft-server/session && /home/pi/minecraft-server/mc $ session restart && unset session ``` laufen
Zum erstmaligen Starten des Servers musst du ``` ./mc world1 enable ``` eingeben. Du kannst auch mehrere Welten erstellen. Wenn du sie gleichzeitig starten möchtest, änder in der Startdatei (mc) is_server_running zu is_session_running (Vergiss nicht, die dazugehörigen Logmeldungen anzupassen). 

Ich empfehle für den Server mindestens einen Raspberry Pi 4 sowie mehr als 10 GB Speicherplatz und 4 GB Ram. 
