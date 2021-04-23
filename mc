TMUX_SOCKET="minecraft"

is_server_running() {
	tmux -L $TMUX_SOCKET has-session > /dev/null 2>&1
	#tmux -L $TMUX_SOCKET has-session -t $TMUX_SESSION > /dev/null 2>&1
	return $?
}

is_session_running(){
	tmux -L $TMUX_SOCKET has-session -t $TMUX_SESSION > /dev/null 2>&1
	return $?
}
mc_command() {
	cmd="$1"
	tmux -L $TMUX_SOCKET send-keys -t $TMUX_SESSION.0 "$cmd" ENTER
	return $?
}

start_server() {
	if is_server_running; then
		echo "Server already running"
		return 1
	fi
	echo "Starting Server in tmux session"
	echo session=$session >> /home/pi/minecraft-server/session
	tmux -L $TMUX_SOCKET new-session -c $MC_HOME -s $TMUX_SESSION -d java -Xmx2560M -jar server.jar nogui
	#tmux -L $TMUX_SOCKET new-session -c $MC_HOME -s $TMUX_SESSION -d java -Xmx2560M -Xms1024M -jar server.jar nogui
	return $?
}

stop_server() {
	if ! is_session_running; then
		echo "Session is not running!"
		return 1
	fi

	# Warn players
	echo "Warning players"
	mc_command "title @a times 3 14 3"
	for i in {10..1}; do
		mc_command "title @a subtitle {\"text\":\"in $i seconds\",\"color\":\"gray\"}"
		mc_command "title @a title {\"text\":\"Shutting down\",\"color\":\"dark_red\"}"
		sleep 1
	done

	# Issue shutdown
	echo "Kicking players"
	mc_command "kick @a Server ist aus"
	echo "Stopping server"
	mc_command "stop"
	if [ $? -ne 0 ]; then
		echo "Failed to send stop command to server"
		return 1
	fi

	# Wait for server to stop
	wait=0
	while is_server_running; do
		sleep 1

		wait=$((wait+1))
		if [ $wait -gt 30 ]; then
			echo "Could not stop server, timeout"
			return 1
		fi
	done
	cat /dev/null > /home/pi/minecraft-server/session
	return 0
}

restart_server() {	
	if ! is_session_running; then
		echo "Session is not running!"
		return 1
	fi

	# Warn players
	echo "Warning players"
	mc_command "title @a times 3 14 3"
	for i in {10..1}; do
		mc_command "title @a subtitle {\"text\":\"in $i seconds\",\"color\":\"gray\"}"
		mc_command "title @a title {\"text\":\"Restarting\",\"color\":\"dark_red\"}"
		sleep 1
	done

	# Issue shutdown
	echo "Kicking players"
	mc_command "kick @a Verbinde in 1 Minute erneut"
	echo "Stopping server"
	mc_command "stop"
	if [ $? -ne 0 ]; then
		echo "Failed to send stop command to server"
		return 1
	fi

	# Wait for server to stop
	wait=0
	while is_server_running; do
		sleep 1

		wait=$((wait+1))
		if [ $wait -gt 30 ]; then
			echo "Could not stop server, timeout"
			return 1
		fi
	done
	#tmux -L $TMUX_SOCKET new-session -c $MC_HOME -s $TMUX_SESSION -d java -Xmx2560M -Xms1024M -jar server.jar nogui
	return $?
}

enable_server() {
	if is_server_running; then
		echo "Server already running"
		return 1
	fi
	cat /dev/null > /home/pi/minecraft-server/session
	sudo systemctl enable minecraft@$session.service
	sudo systemctl start minecraft@$session.service
}

disable_server() {
	if ! is_session_running; then
		echo "Session is not running!"
		return 1
	fi
	sudo systemctl stop minecraft@$session.service
	wait=0
	while is_server_running; do
		sleep 1

		wait=$((wait+1))
		if [ $wait -gt 30 ]; then
			echo "Could not stop server, timeout"
			return 1
		fi
	done
	sudo systemctl disable minecraft@$session.service
	cat /dev/null > /home/pi/minecraft-server/session
}

attach_session() {
	if ! is_server_running; then
		echo "Cannot attach to server session, server not running"
		return 1
	fi

	tmux -L $TMUX_SOCKET attach-session -t $TMUX_SESSION
	return 0
}

case "$1" in
$1)
	session="$1"
	TMUX_SESSION="minecraft-$1"
	MC_HOME="/home/pi/minecraft-server/$1/"
	case "$2" in
	start)
		start_server
		exit $?
		;;
	stop)
		stop_server
		exit $?
		;;
	restart)
		restart_server
		exit $?
		;;
	enable)
		enable_server
		exit $?
		;;
	disable)
		disable_server
		exit $?
		;;
	attach)
		attach_session
		exit $?
		;;
	*)
		echo "Usage: ${0} {session} {start|stop|restart|enable|disable|attach}"
		exit 2
		;;
	esac
	;;
esac
