FROM lsqtzj/openeuler:23.09  AS base
EXPOSE 8700	
RUN yum -y install apr-devel apr-util-devel

WORKDIR /teamtalk
EXPOSE 8700
FROM lsqtzj/teamtalk_develop_server AS builder


FROM base AS  runtime
COPY  --from=builder /develop/im-server-1.0.0/msfs /teamtalk/msfs
COPY  --from=builder /develop/im-server-1.0.0/daeml  /teamtalk/daeml
COPY ./server/run/monitor.sh  /teamtalk/msfs/monitor.sh
COPY ./server/run/restart.sh  /teamtalk/restart.sh
COPY ./auto_setup/im_server/conf/msfs.conf /teamtalk/msfs/msfs.conf

COPY ./docker/msfs_server/main.sh main.sh
RUN chmod +x /teamtalk/main.sh
ENTRYPOINT [ "/teamtalk/main.sh"]
CMD ["/bin/bash"]