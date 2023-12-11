#!/usr/bin/env bash

passed_tests_count=0
failed_tests_count=0

function echo-red() {
	echo -e "\033[0;31m$1\033[0m"
}

function echo-green() {
	echo -e "\033[0;32m$1\033[0m"
}

echo "---"

function test() {
	local test_command=$1
	local test_description=$2

	if ! $test_command; then
		echo -e "$test_description: \033[0;31mFAIL\033[0m"
		((failed_tests_count++))
	else
		echo -e "$test_description: \033[0;32mOK\033[0m"
		((passed_tests_count++))
	fi
}

function test-results() {
	echo "---"
	if [[ $failed_tests_count -gt 0 ]]; then
		echo-red "$passed_tests_count tests passed, $failed_tests_count tests failed"
		exit 1
	else
		echo-green "All $passed_tests_count tests passed"
	fi
}

"$@"
