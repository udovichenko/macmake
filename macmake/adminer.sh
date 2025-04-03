#!/bin/bash

PORT=8888
ADMINER_DIR="$HOME/Projects/adminer"
TMP_FILE="${ADMINER_DIR}/adminer-tmp.php"
CACHE_FILE="${ADMINER_DIR}/adminer-latest.php"
TARGET_FILE="${ADMINER_DIR}/adminer.php"

echo-red() {
	echo -e "\033[0;31m$1\033[0m"
}

echo-green() {
	echo -e "\033[0;32m$1\033[0m"
}

echo-yellow() {
	echo -e "\033[0;33m$1\033[0m"
}

update() {
	mkdir -p "$ADMINER_DIR"

	wget --no-check-certificate https://github.com/vrana/adminer/releases/download/v5.1.1/adminer-5.1.1-en.php -O "$TMP_FILE"
	WGET_EXIT_CODE=$?

	if [ $WGET_EXIT_CODE -eq 0 ]; then
		cp "$TMP_FILE" "$CACHE_FILE"
		cp "$TMP_FILE" "$TARGET_FILE"
	else
		if [ -f "$CACHE_FILE" ]; then
			cp "$CACHE_FILE" "$TARGET_FILE"
			echo-yellow "[WARN] Download failed. Using cached Adminer file"
		else
			echo-red "[ERROR] Download failed and no cached Adminer file found"
			exit 1
		fi
	fi
}

run() {
	if [ ! -f "$TARGET_FILE" ]; then
		echo-yellow "[WARN] No adminer.php file found. Downloading the latest version..."
		update
	fi

	echo-green "[OK] Adminer is available at:"

	echo "http://localhost:$PORT/adminer.php"
	php -S localhost:$PORT -t "$HOME/Projects/adminer"
}

stop() {
	lsof -ti:$PORT | xargs kill -9
}

"$@"
