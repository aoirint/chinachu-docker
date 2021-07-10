#!/bin/bash

rm -f /var/run/chinachu-operator.pid > /dev/null 2>&1
rm -f /var/run/chinachu-wui.pid > /dev/null 2>&1

./chinachu-operator.sh start
./chinachu-wui.sh start

tail -f /usr/local/chinachu/log/wui &
tail -f /usr/local/chinachu/log/operator &

exec "$@"
