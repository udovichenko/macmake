#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source "$DIR/echoes.sh"

port="$1"
if [ -z "$port" ]; then
	echo-red "ERROR: Please specify a port as the first argument" >&2
	exit 1
fi

pid="$(lsof -t -i:"$port")"

if [ -z "$pid" ]; then
	echo-yellow "No process found on port $port"
else
	if kill "$pid"; then
		echo-green "Killed process $pid on port $port"
	else
		echo-red "Failed to kill process $pid on port $port" >&2
	fi
fi
