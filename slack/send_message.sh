#!/bin/sh

MSG_DATA='{"text":"Hello, World!"}'
WEBHOOK=$SLACK_WEBHOOK_NETDATA

curl -X POST -H 'Content-type: application/json' --data "${MSG_DATA}" $WEBHOOK