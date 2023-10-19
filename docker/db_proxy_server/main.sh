#!/bin/bash
server_ip(){
        getent hosts $1  | awk '{print $1}'
}

sed -i "s/ListenIP=127.0.0.1/ListenIP=0.0.0.0/g" /teamtalk/db_proxy_server/dbproxyserver.conf
sed -i "s/teamtalk_master_host.*/teamtalk_master_host=$( server_ip "${MARIADB_SERVER_MASTER}" )/g" /teamtalk/db_proxy_server/dbproxyserver.conf
sed -i "s/teamtalk_master_dbname.*/teamtalk_master_dbname= $MARIADB_DATABASE/g" /teamtalk/db_proxy_server/dbproxyserver.conf
sed -i "s/teamtalk_master_username.*/teamtalk_master_username= $MARIADB_USER/g" /teamtalk/db_proxy_server/dbproxyserver.conf
sed -i "s/teamtalk_master_password.*/teamtalk_master_password= $MARIADB_PASSWORD/g" /teamtalk/db_proxy_server/dbproxyserver.conf

sed -i "s/teamtalk_slave_host.*/teamtalk_slave_host=$( server_ip "${MARIADB_SERVER_SLAVE}" )/g" /teamtalk/db_proxy_server/dbproxyserver.conf
sed -i "s/teamtalk_slave_dbname.*/teamtalk_slave_dbname= $MARIADB_DATABASE/g" /teamtalk/db_proxy_server/dbproxyserver.conf
sed -i "s/teamtalk_slave_username.*/teamtalk_slave_username= $MARIADB_USER/g" /teamtalk/db_proxy_server/dbproxyserver.conf
sed -i "s/teamtalk_slave_password.*/teamtalk_slave_password= $MARIADB_PASSWORD/g" /teamtalk/db_proxy_server/dbproxyserver.conf

sed -i "s/unread_host=.*/unread_host= $( server_ip "${UNREAD_HOST}" )/g" /teamtalk/db_proxy_server/dbproxyserver.conf
sed -i "s/unread_port=.*/unread_port= 6379/g" /teamtalk/db_proxy_server/dbproxyserver.conf
sed -i "s/unread_db=.*/unread_db= 1/g" /teamtalk/db_proxy_server/dbproxyserver.conf
sed -i "s/unread_db_maxconncnt=.*/unread_maxconncnt= 16/g" /teamtalk/db_proxy_server/dbproxyserver.conf

sed -i "s/group_set_host=.*/group_set_host= $( server_ip "${GROUP_SET_HOST}" )/g" /teamtalk/db_proxy_server/dbproxyserver.conf
sed -i "s/group_set_port=.*/group_set_port= 6379/g" /teamtalk/db_proxy_server/dbproxyserver.conf
sed -i "s/group_set_db=.*/group_set_db=2/g" /teamtalk/db_proxy_server/dbproxyserver.conf
sed -i "s/group_set_maxconncnt=.*/group_set_maxconncnt=16/g" /teamtalk/db_proxy_server/dbproxyserver.conf

sed -i "s/sync_host=.*/sync_host= $( server_ip "${SYNC_HOST}" )/g" /teamtalk/db_proxy_server/dbproxyserver.conf
sed -i "s/sync_port=.*/sync_port= 6379/g" /teamtalk/db_proxy_server/dbproxyserver.conf
sed -i "s/sync_db=.*/sync_db=3/g" /teamtalk/db_proxy_server/dbproxyserver.conf
sed -i "s/sync_maxconncnt=.*/sync_maxconncnt=1/g" /teamtalk/db_proxy_server/dbproxyserver.conf

sed -i "s/token_host=.*/token_host= $( server_ip "${TOKEN_HOST}" )/g" /teamtalk/db_proxy_server/dbproxyserver.conf
sed -i "s/token_port=.*/token_port= 6379/g" /teamtalk/db_proxy_server/dbproxyserver.conf
sed -i "s/token_db=.*/token_db=4/g" /teamtalk/db_proxy_server/dbproxyserver.conf
sed -i "s/token_maxconncnt=.*/token_maxconncnt=16/g" /teamtalk/db_proxy_server/dbproxyserver.conf

sed -i "s/group_member_host=.*/group_member_host=$( server_ip "${GROUP_MEMBER_HOST}" )/g" /teamtalk/db_proxy_server/dbproxyserver.conf
sed -i "s/group_member_port=.*/group_member_port= 6379/g" /teamtalk/db_proxy_server/dbproxyserver.conf
sed -i "s/group_member_db=.*/group_member_db=5/g" /teamtalk/db_proxy_server/dbproxyserver.conf
sed -i "s/group_member_maxconncnt=.*/group_member_maxconncnt=48/g" /teamtalk/db_proxy_server/dbproxyserver.conf

server=db_proxy_server
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
echo "waitterm"
waitterm
echo "==> STOP"
stop
echo "==> STOP SUCCESSFUL ..."