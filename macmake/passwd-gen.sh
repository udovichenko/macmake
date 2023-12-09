#!/usr/bin/env bash

length=$1
default_length=20

spec_chars_max_count=$2
default_spec_chars_max_count=2

if [[ ! $spec_chars_max_count =~ ^[0-9]+$ ]]; then
	spec_chars_max_count=$default_spec_chars_max_count
fi

generate_password() {
	if [[ -z "$length" ]]; then
		length=$default_length
	fi

	base64_safe_length=$((length * 4 / 3))

	if [[ ! $length =~ ^[0-9]+$ ]]; then
		echo "Length must be a number" >&2
		exit 1
	fi

	while true; do
		password=$(openssl rand -base64 "$base64_safe_length" | tr -dc 'a-zA-Z0-9' | fold -w "$length" | head -n 1)
		if [[ $password =~ [0-9] ]]; then
			echo "$password"
			break
		fi
	done
}

add_special_chars() {
	local password=$1

	if [[ $spec_chars_max_count -eq 0 ]]; then
		echo "$password"
		return
	fi

	special_chars=('!@#$%^&*_+')
	special_chars_count=$(shuf -i1-$spec_chars_max_count -n1)

	for _ in $(seq 1 "$special_chars_count"); do
		char=$(echo "${special_chars[*]}" | fold -w1 | shuf | head -c1)
		position=$(shuf -i1-"${#password}" -n1)
		password=${password:0:((position - 1))}$char${password:$position}
	done

	echo "$password"
}

password=$(generate_password "$1")
add_special_chars "$password"
