FROM lsqtzj/openeuler:23.09  AS base

RUN yum -y install apr-devel apr-util-devel

WORKDIR /teamtalk
EXPOSE 10600	
FROM lsqtzj/teamtalk_develop_server AS builder


FROM base AS  runtime
COPY --from=builder /develop/im-server-1.0.0/db_proxy_server /teamtalk/db_proxy_server
COPY --from=builder /usr/local/mysql /usr/local/mysql
COPY --from=builder /develop/im-server-1.0.0/daeml  /teamtalk/daeml

COPY --from=builder /usr/local/bin/btop /usr/local/bin/btop
COPY --from=builder /usr/local/share/btop /usr/local/share/btop
COPY --from=builder /usr/local/share/applications/btop.desktop /usr/local/share/applications/btop.desktop
COPY --from=builder /usr/local/share/icons/hicolor/48x48/apps/btop.png /usr/local/share/icons/hicolor/48x48/apps/btop.png
COPY --from=builder /usr/local/share/icons/hicolor/scalable/apps/btop.svg /usr/local/share/icons/hicolor/scalable/apps/btop.svg

COPY ./server/run/monitor.sh  /teamtalk/db_proxy_server/monitor.sh
COPY ./server/run/restart.sh  /teamtalk/restart.sh
COPY ./docker/db_proxy_server/main.sh main.sh
RUN chmod +x /teamtalk/main.sh
ENV PATH=$PATH:/usr/local/mysql/bin/

ENV LC_ALL=en_US.UTF-8
ENV LANG=en_US.UTF-8

ENTRYPOINT [ "/teamtalk/main.sh"]
CMD ["/bin/bash"]