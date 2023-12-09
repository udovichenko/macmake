#!/bin/bash

if [ $# -ne 1 ]; then
  echo 1>&2 "USAGE: $0 <phpVersion>"
  exit 2
fi

INSTALLED_VERSIONS=$(find /opt/homebrew/opt | grep 'php@' | sed 's/\/opt\/homebrew\/opt\/php@//')

if [[ ! -f /opt/homebrew/opt/php@${1}/bin/php ]]; then
  echo 1>&2 "/opt/homebrew/opt/php@${1}/bin/php was not found"
  printf 'valid options:\n%s\n' "${INSTALLED_VERSIONS[*]}"
  exit 2
fi

for VERSION in ${INSTALLED_VERSIONS[*]}; do
  brew unlink "php@$VERSION" > /dev/null 2>&1
  brew services stop "php@$VERSION" > /dev/null 2>&1
done

brew link --force --overwrite "php@$1" > /dev/null 2>&1
brew services start "php@$1" > /dev/null 2>&1
