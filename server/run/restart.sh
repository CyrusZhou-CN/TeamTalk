#/bin/sh
#start or stop the im-server


function restart() {
    cd $1
    if [ ! -e *.conf  ]
    then
        echo "no config file"
        return
    fi

    if [ -e server.pid  ]; then
        pid=`cat server.pid`
        echo "kill pid=$pid"
        kill $pid
        while true
        do
            oldpid=`ps -ef|grep $1|grep $pid`;
            if [ $oldpid" " == $pid" " ]; then
                echo $oldpid" "$pid
                sleep 1
            else
                break
            fi
        done
        if [ "$2" == "log" ]; then
            ./$1
        else
            ../daeml ./$1
        fi
    else 
        if [ "$2" == "log" ]; then
            ./$1
        else
            ../daeml ./$1
        fi
    fi
}

case $1 in
    login_server)
        restart $1 $2
        ;;
    msg_server)
        restart $1 $2
        ;;
    route_server)
        restart $1 $2
        ;;
    http_msg_server)
        restart $1 $2
        ;;
    file_server)
        restart $1 $2
        ;;
    push_server)
        restart $1 $2
        ;;
    db_proxy_server)
        restart $1 $2
        ;;
    msfs)
        restart $1 $2
        ;;
    *)
        echo "Usage: "
        echo "  ./restart.sh (login_server|msg_server|route_server|http_msg_server|db_proxy_server|file_server|push_server|msfs) [log]"
        ;;
esac
