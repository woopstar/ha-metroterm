#!/bin/bash

# økonomi: 0
# normal: 1
# luksus: 2

# email -> @ skal erstattes med %40, eksempel: navn@test.com bliver til navn%40test.com

USERNAME=xxx
PASSWORD=xxx
METROID=xxx
KOMFORT=${1:-1}

MYTMPDIR="$(mktemp -d)"
trap 'rm -rf -- "$MYTMPDIR"' EXIT

# login
http_response=$(curl 'https://myupway.com/LogIn' \
  -H 'Content-Type: application/x-www-form-urlencoded' \
  -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/99.0.4844.51 Safari/537.36' \
  -H 'Referer: https://myupway.com/Welcome' \
  -c $MYTMPDIR/cookies.txt \
  --data-raw "returnUrl=&Email=$USERNAME&Password=$PASSWORD" \
  --connect-timeout 2 --max-time 2 -sL -k -o /dev/null -w "%{http_code}" \
  --compressed)

if [ "$http_response" != "200" ]; then
    echo "Unable to log in"
    exit 1
fi

# set value
http_response=$(curl 'https://myupway.com/System/138609/Manage/2.2' \
  -H 'Content-Type: application/x-www-form-urlencoded' \
  -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/99.0.4844.51 Safari/537.36' \
  -H 'Referer: https://myupway.com/System/138609/Manage/2.2' \
  -b /$MYTMPDIR/cookies.txt \
  --data-raw "$METROID=$KOMFORT" \
  --connect-timeout 2 --max-time 2 -sL -k -o /dev/null -w "%{http_code}" \
  --compressed)

if [ "$http_response" != "200" ]; then
    echo "Unable to set value for komfort drift"
    exit 1
fi

# logout
http_response=$(curl 'https://myupway.com/LogOut' \
  -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/99.0.4844.51 Safari/537.36' \
  -b $MYTMPDIR/cookies.txt \
  --connect-timeout 2 --max-time 2 -sL -k -o /dev/null -w "%{http_code}" \
  --compressed)

if [ "$http_response" != "200" ]; then
    echo "Unable to log out"
    exit 1
fi

exit 0
