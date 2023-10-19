FROM lsqtzj/openeuler:23.09  AS base

RUN yum -y install apr-devel apr-util-devel

WORKDIR /teamtalk
EXPOSE 8200
FROM lsqtzj/teamtalk_develop_server AS builder


FROM base AS  runtime
COPY  --from=builder /develop/im-server-1.0.0/route_server /teamtalk/route_server
COPY  --from=builder /develop/im-server-1.0.0/daeml  /teamtalk/daeml
COPY ./server/run/monitor.sh  /teamtalk/route_server/monitor.sh
COPY ./server/run/restart.sh  /teamtalk/restart.sh
COPY ./docker/route_server/main.sh main.sh
RUN chmod +x /teamtalk/main.sh
ENTRYPOINT [ "/teamtalk/main.sh"]
CMD ["/bin/bash"]