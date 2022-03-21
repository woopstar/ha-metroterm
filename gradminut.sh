#!/bin/bash

# email -> @ skal erstattes med %40, eksempel: navn@test.com bliver til navn%40test.com

USERNAME=xxx
PASSWORD=xxx
GM=${1:-60}
SYSTEMID=138609

MYTMPDIR="$(mktemp -d)"
trap 'rm -rf -- "$MYTMPDIR"' EXIT

# login
http_response=$(curl 'https://myupway.com/LogIn' \
  -H 'Content-Type: application/x-www-form-urlencoded' \
  -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/99.0.4844.51 Safari/537.36' \
  -c $MYTMPDIR/cookies.txt \
  --data-raw "returnUrl=&Email=$USERNAME&Password=$PASSWORD" \
  --connect-timeout 2 --max-time 2 -sL -k -o /dev/null -w "%{http_code}" \
  --compressed)

if [ "$http_response" != "200" ]; then
    echo "Unable to log in"
    exit 1
fi

curl "https://myupway.com/System/$SYSTEMID/Manage/4.9.3" \
  -H 'Content-Type: application/x-www-form-urlencoded' \
  -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/99.0.4844.83 Safari/537.36' \
  -b /$MYTMPDIR/cookies.txt \
  --data-raw "43005=17&47206=$GM&48072=500&47209=100" \
  --connect-timeout 2 --max-time 2 -sL -k -o /dev/null -w "%{http_code}" \
  --compressed

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
