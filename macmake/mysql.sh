#!/bin/bash

create() {
	echo -n "Enter DB name: "
	read -r DB_NAME
	echo

	if mysql -u root -e "USE $DB_NAME" 2> /dev/null; then
		echo "Database '$DB_NAME' already exists."
		echo "Exiting..."
		exit 1
	fi

	mysql -u root -e "CREATE DATABASE $DB_NAME CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
	echo "Database '$DB_NAME' created."
}

"$@"
