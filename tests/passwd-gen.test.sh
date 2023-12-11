#!/usr/bin/env bash

source ./test-lib.sh

test-default-length() {
	local output=$(make passwd-gen | wc -c)
	local expected=21 # 20 chars + newline

	[[ $output -eq $expected ]]
}
test test-default-length "Is default password length 20 chars"

test-has-special-chars() {
	local output=$(make passwd-gen)
	local expected='[!@#$%^&*_+]'

	[[ $output =~ $expected ]]
}
test test-has-special-chars "Does default password have special chars"

test-has-numbers() {
	local output=$(make passwd-gen l=1 n=0 s=0)
	local expected='[0-9]'

	[[ $output =~ $expected ]]
}
test test-has-numbers "Does default password have numbers"

test-custom-length() {
	local min_length=3
	local max_length=40
	local step=3
	local rand_spec_chars_max_count=$(shuf -i1-"$max_length" -n1)

	for i in $(seq "$min_length" "$step" "$max_length"); do
		local output=$(make passwd-gen l=$i | wc -c)
		local expected=$((i + 1)) # i chars + newline

		[[ $output -eq $expected ]]
	done
}
test test-custom-length "Does custom password length work"

test-results
