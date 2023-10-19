FROM lsqtzj/openeuler:23.09 AS base

RUN yum -y install apr-devel apr-util-devel

WORKDIR /teamtalk
EXPOSE 8080 8008
FROM lsqtzj/teamtalk_develop_server AS builder


FROM base AS  runtime
COPY  --from=builder /develop/im-server-1.0.0/login_server /teamtalk/login_server
COPY  --from=builder /develop/im-server-1.0.0/daeml  /teamtalk/daeml
COPY ./server/run/monitor.sh  /teamtalk/login_server/monitor.sh
COPY ./server/run/restart.sh  /teamtalk/restart.sh
COPY ./docker/login_server/main.sh main.sh
RUN chmod +x /teamtalk/main.sh
ENTRYPOINT [ "/teamtalk/main.sh"]
CMD ["/bin/bash"]