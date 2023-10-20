#!/bin/sh

#############################################################
# monitor server running                                    #
# restart server if detect it is not running                #
# monitor.sh must be in the same directory with the server    #
#############################################################
function sendSMS() {
#HTTP_HOST="http://api.transformer.mogujie.org/sms/mandao"
    HTTP_HOST="http://api.transformer.mogujie.org/sms/channel1"
    AppKey='82785972c1939448'
    InterFaceKey='mandao'
#UserId="1,2,3,4,5"
    UserId="1"
#子烨、蓝狐、罗宁
    Phone=("18806535140" "18657139120" "18668072662")
    HostName=`uname -n`
    DirName=${PWD##*/}
    Content='[TeamTalk] '$HostName' '$DirName' crash 【蘑菇街】'
    CreateTime=`date +%s`000
    for i in ${Phone[@]}
    do
        curl $HTTP_HOST -d "appKey=$AppKey&interfaceKey=$InterFaceKey&userId=$UserId&phone=$i&msg=$Content&submitTime=$CreateTime" > /dev/null 2>&1
    done
}

function monitor() {
    if [ ! -e *.conf ]
    then
        echo "no config file"
        return
    fi
    echo $$ > monitor.pid
    local dot="."
    while true
    do
        if [ -e server.pid ]; then
            echo -e "\033[32m $1 ==> START SUCCESSFUL ... \033[0m"
            while true
            do
                if [ -e server.pid ]; then
                    pid=`cat server.pid`  # get pid
                    process_count=`ps aux|grep $1|grep $pid|wc -l`
                    if [ $process_count == 0 ]
                    then
                        # send a SMS
                        sendSMS
                        # add log
                        date >> restart.log
                        echo "server stopped, pid=$pid, process_cnt=$process_count" >> restart.log
                        # restart server
                        if [ "$2" == "log" ]; then
                            ./$1
                        else
                            ../daeml ./$1
                        fi
                    fi                    
                    sleep 15
                else
                    break
                fi
            done
        else          
            printf "%s %s\r" "$1=>Wait for start" "$dot"
            dot+="."
        fi
        sleep 1
    done
    echo "$1=>Quit"
}

case $1 in
    login_server)
        monitor $1 $2
        ;;
    msg_server)
        monitor $1 $2
        ;;
    route_server)
        monitor $1 $2
        ;;
    http_msg_server)
        monitor $1 $2
        ;;
    db_proxy_server)
        monitor $1 $2
        ;;
    file_server)
        monitor $1 $2
        ;;
    push_server)
        monitor $1 $2
        ;;
    msfs)
        monitor $1 $2
        ;;
    test)
        sendSMS
        ;;
    *)
        echo "Usage: "
        echo "  ./monitor.sh (login_server|msg_server|route_server|http_msg_server|db_proxy_server|file_server|push_server|msfs|test ) [log]"
        ;;
esac
