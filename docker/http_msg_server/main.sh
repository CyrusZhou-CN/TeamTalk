#!/bin/bash
server_ip(){
        getent hosts $1  | awk '{print $1}'
}

sed -i "s/DBServerIP1=.*/DBServerIP1=$( server_ip "${DBServerIP1}" )/g" /teamtalk/http_msg_server/httpmsgserver.conf
sed -i "s/DBServerIP2=.*/#DBServerIP2=127.0.0.1/g" /teamtalk/http_msg_server/httpmsgserver.conf
sed -i "s/DBServerPort2.*/#DBServerPort2=10600/g" /teamtalk/http_msg_server/httpmsgserver.conf

sed -i "s/RouteServerIP1.*/RouteServerIP1=$( server_ip "${RouteServerIP1}" )/g" /teamtalk/http_msg_server/httpmsgserver.conf
sed -i "s/RouteServerPort1=.*/RouteServerPort1=8200/g" /teamtalk/http_msg_server/httpmsgserver.conf
server=http_msg_server
echo -e "\033[32m $server ==> START... \033[0m"
./restart.sh $server log
cd /teamtalk/$server
./monitor.sh  $server log
waitterm() {
        local PID
        # any process to block
        tail -f /dev/null &
        PID="$!"
        # setup trap, could do nothing, or just kill the blocker
        trap "kill -TERM ${PID}" TERM INT
        # wait for signal, ignore wait exit code
        wait "${PID}" || true
        # clear trap
        trap - TERM INT
        # wait blocker, ignore blocker exit code
        wait "${PID}" 2>/dev/null || true
}
waitterm
echo "==> STOP"
stop
echo "==> STOP SUCCESSFUL ..."