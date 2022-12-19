#!/bin/bash
if [ -z "$*" ]; then echo "No args"; exit 1; fi

scriptDir=$(dirname -- "$(readlink -f -- "$BASH_SOURCE")")
cd "$scriptDir" || exit 1

USERNAME=andreas%40kruger.nu
PASSWORD=xxxxxxx
SYSTEMID=138609

COOKIE=/tmp/metrotherm_cookie
JSON_FILE="/tmp/metrotherm.json"

# Install curl jq and grep
apk add -q -f --no-cache curl jq grep

# Invalidate cookie after 10 minutes to force a new login
if [ -f $COOKIE ]; then
  find $COOKIE -maxdepth 1 -mmin +10 -type f -delete
fi

# login
if [ ! -f $COOKIE ]; then
  curl 'https://myupway.com/LogIn' \
    -H 'Content-Type: application/x-www-form-urlencoded' \
    -c $COOKIE \
    --data-raw "returnUrl=&Email=$USERNAME&Password=$PASSWORD" \
    --connect-timeout 2 --max-time 2 -sL -k -o /dev/null \
    --compressed
fi

# Fetch data
curl 'https://myupway.com/PrivateAPI/Values' -b $COOKIE --compressed --connect-timeout 2 --max-time 2 -sLk -o $JSON_FILE \
  --data-raw "hpid=$SYSTEMID&variables=48009&variables=40067&variables=40014&variables=40013&variables=43005&variables=43009&variables=40008&variables=40012&variables=43081&variables=43084&variables=44069&variables=44701&variables=40782"

# Get output as string or number/float/int
if [ "$2" == "string" ]; then
  cat $JSON_FILE | jq ".Values[] | select(.VariableId == $1) | {CurrentValue} | .[]" | sed 's/"//g'
else
  cat $JSON_FILE | jq ".Values[] | select(.VariableId == $1) | {CurrentValue} | .[]" | sed 's/"//g' | grep -oP "\K(-)?([0-9]+(.[0-9])?)"
fi
