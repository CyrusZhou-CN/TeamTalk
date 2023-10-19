#!/bin/bash

server_ip(){
        getent hosts $1  | awk '{print $1}'
}

sed -i "s/msfs=.*/msfs=http:\/\/$( server_ip "${MsfsServer}" )\//g" /teamtalk/login_server/loginserver.conf
sed -i "s/discovery=http.*/discovery=http:\/\/$( server_ip "${WebServer}" )\/api\/discovery/g" /teamtalk/login_server/loginserver.conf
server=login_server
echo -e "\033[32m $server ==> START ... \033[0m"
./restart.sh $server log
cd /teamtalk/$server
./monitor.sh  $server log
echo -e "\033[32m ==> START SUCCESSFUL \033[0m"
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