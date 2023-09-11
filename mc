#!/bin/bash

# If you developed some improvement for this code yourself, feel free to open a pull request or issue (https://github.com/Simonesien/mcserver)

socket="/home/pi/minecraft-server/" # change it if the script is in /bin or if you would like the worldfiles to be stored in /tmp or /mnt
version_vanilla="1.20.1" # for render mode you need to use the vanilla jar because paper does not support piped commands - at least I cannot get it to work (see https://github.com/PaperMC/Paper/issues/7126)
version="1.20.1-paper"
java_binary="/home/pi/.sdkman/candidates/java/current/bin/java"
java_params="-Xms2560M -Xmx2560M -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1 -Dusing.aikars.flags=https://mcflags.emc.gs -Daikars.new.flags=true"

is_server_running() {
	tmux -L minecraft has-session > /dev/null 2>&1
	return $?
}

is_session_running(){
	tmux -L minecraft has-session -t minecraft-$session > /dev/null 2>&1
	return $?
}
mc_command() {
	tmux -L minecraft send-keys -t minecraft-$session.0 "$1" ENTER
	return $?
}

start_server() {
	if is_server_running; then
		echo "Server already running"
		return 1
	fi
	echo "Starting Server in tmux session"
	/usr/bin/tmux -L minecraft new-session -c $socket$session -s minecraft-$session -d "${java_binary} ${java_params} -jar server.jar nogui"
	return $?
}

stop_server() {
	if ! is_session_running; then
		echo "Session is not running!"
		return 1
	fi

	echo "Warning players"
	mc_command "title @a times 3 14 3"
	for i in {10..1}; do
		mc_command "title @a subtitle {\"text\":\"in $i seconds\",\"color\":\"gray\"}"
		mc_command "title @a title {\"text\":\"$1\",\"color\":\"dark_red\"}"
		sleep 1
	done

	echo "Kicking players"
	mc_command "kick @a $2"
	echo "Stopping server"
	mc_command "stop" || (echo "Failed to send stop command to server"; return 1)

	wait=0
	while is_server_running; do
		sleep 1

		wait=$((wait+1))
		if [ $wait -gt 30 ]; then
			echo "Could not stop server, timeout"
			return 1
		fi
	done
	if [ "$1" == "Restarting" ]; then
		start_server
		return $?
	fi
	return 0
}

enable_server() {
	if is_server_running; then
		echo "Server already running"
		return 1
	fi
	sudo systemctl enable ${socket}minecraft@.service
	sudo ln -s ${socket}minecraft@.service /etc/systemd/system/multi-user.target.wants/minecraft@$session.service
	sudo systemctl start minecraft@$session.service
	return $?
}

disable_server() {
	if ! is_session_running; then
		if [ -z "$1" ]; then
			echo "Session is not running!"
			return 1
		fi
	fi
	sudo systemctl stop minecraft@$session.service
	if [ -z "$1" ]; then
		wait=0
		while is_server_running; do
			sleep 1

			wait=$((wait+1))
			if [ $wait -gt 30 ]; then
				echo "Could not stop server, timeout"
				return 1
			fi
		done
	fi
	sudo systemctl disable ${socket}minecraft@.service
	return $?
}

attach_session() {
	if ! is_session_running; then
		echo "Cannot attach to session, session not running"
		return 1
	fi

	tmux -L minecraft attach-session -t minecraft-$session
	return 0
}

create_world() {
	if [ -e $socket$session ]; then
		echo "World already exists. Consider re-naming the existing world."
		return 1
	fi
	mkdir $socket$session
	touch $socket$session/server.properties
	touch $socket$session/eula.txt
	echo "eula=true" >> $socket$session/eula.txt
	ln -s $socket$version.jar $socket$session/server.jar
	return $?
}

remove_world() {
	removedir=$(basename $socket$session)
	if ! [ -d "$socket$removedir" ] || [ "$removedir" == ".." ] || [ "$removedir" == "." ] || [ "$removedir" == "overviewer" ] || [ "$removedir" == "" ]; then
		echo "World doesn´t exist or isn´t a removable world-directory."
		return 1
	fi
	echo -n "(N/y/No/yes) "
	rm -r -I $socket$removedir
	return $?
}

expand_world(){
	echo "Running script for generating the world in a square of 100 * 100 Chunks."
	python3 ${socket}mcexplore.py -c "java -Xmx2560M -jar server.jar nogui" -p $socket$session 100 || return 1
}

render_map(){
	if ! [ -e $socket$session ]; then
		echo "World does not exist."
		return 1
	fi
	echo "Rendering minecraft world to a web-viewable map."
	python3 ${socket}overviewer/overviewer.py "$socket${session}/world" "${socket}maps/$session" --simple-output || return 1

	size=$(du -sh ${socket}maps/$session | cut -f1)
	echo "$size $session" >> ${socket}maps/seeds
}

case "$1" in
$1)
	session="$1"
	case "$2" in
	start)
		start_server
		echo session=$session >> ${socket}session
		exit $?
		;;
	stop)
		stop_server "Shutting down" "Server ist aus"
		cat /dev/null > ${socket}session
		exit $?
		;;
	restart)
		stop_server "Restarting" "Verbinde in 1 Minute erneut"
		exit $?
		;;
	enable)
		enable_server
		exit $?
		;;
	disable)
		disable_server $3
		exit $?
		;;
	attach)
		attach_session
		exit $?
		;;
	create)
		if ! [ -z "$3" ]; then
			if [ -e $socket$3 ];
				then
					version=$(basename $socket$3)
				else
					echo "Jar does not exist."
			fi
		fi
		create_world
		exit $?
		;;
	remove)
		remove_world
		exit $?
		;;
	render)
		if ! [ "$3" == "bg_start" ];
			then
			if is_server_running; then
				echo "Server already running"
				exit 1
			fi
			if [ -e $socket$session ]; then
				echo "World already exists. Consider re-naming the existing world."
				exit 1
			fi
			if [ "$session" == "random" ];
				then
					session=$RANDOM
					echo "World Seed (randomly generated): $session"
				else
					echo "World Seed: $session"
			fi
			if [ "$4" == "" ]; then
				version=$version_vanilla
			else
				version=$4
			fi
			version=$version_vanilla
			create_world
			tmux -L minecraft new-session -c $socket$session -s minecraft-$session -d "${socket}mc $session render bg_start"
			attach_session
			else
			echo "online-mode=false" >> $socket$session/server.properties
			echo "level-seed=$session" >> $socket$session/server.properties
			echo "level-name=world" >> $socket$session/server.properties
			echo "generate-structures=true" >> $socket$session/server.properties # Change to false if you don't want structures to be generated
			expand_world && render_map
			exit $?
		fi
		exit $?
		;;
	overview)
		render_map
		exit $?
		;;
	*)
		echo "Usage: ${0} {worldname} {start|stop|restart|enable|disable (force)|attach|create (version)|remove|render (version)|overview}"
		exit 2
		;;
	esac
	;;
esac
