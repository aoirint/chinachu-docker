#!/bin/bash

./chinachu-operator.sh start
./chinachu-wui.sh start

# tail -f /usr/local/chinachu/log/wui &
# tail -f /usr/local/chinachu/log/operator &

exec "$@"
