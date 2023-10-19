#!/bin/bash

server_ip(){
        getent hosts $1  | awk '{print $1}'
}

sed -i "s/IpAddr1=.*/IpAddr1= $IPAdd1/g" /teamtalk/msg_server/msgserver.conf
sed -i "s/IpAddr2=.*/IpAddr2= $IPAdd2/g" /teamtalk/msg_server/msgserver.conf
sed -i "s/DBServerIP1=.*/DBServerIP1=$( server_ip "${DB_PROXY_SERVER}" )/g" /teamtalk/msg_server/msgserver.conf
sed -i "s/LoginServerIP1=.*/LoginServerIP1=$( server_ip "${LOGIN_SERVER}" )/g" /teamtalk/msg_server/msgserver.conf
sed -i "s/RouteServerIP1=.*/RouteServerIP1=$( server_ip "${ROUTE_SERVER}" )/g" /teamtalk/msg_server/msgserver.conf
sed -i "s/PushServerIP1=.*/PushServerIP1=$( server_ip "${PUSH_SERVER}" )/g" /teamtalk/msg_server/msgserver.conf
sed -i "s/FileServerIP1=.*/FileServerIP1=$( server_ip "${FILE_SERVER}" )/g" /teamtalk/msg_server/msgserver.conf

server=msg_server
echo -e "\033[32m $server ==> START ... \033[0m"
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