FROM lsqtzj/openeuler_mariadb:11.3.0 AS mariadb_runtime

FROM lsqtzj/openeuler_develop_base AS runtime

COPY --from=mariadb_runtime /usr/local/mysql /usr/local/mysql
VOLUME ["/develop"]

WORKDIR /develop
COPY ./server server
COPY ./pb pb
ENV PATH=$PATH:/usr/local/protobuf/bin
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/protobuf/lib
ENV CPLUS_INCLUDE_PATH=$CPLUS_INCLUDE_PATH:/usr/local/protobuf/include

RUN cd server/src && /bin/cp -rf /usr/local/log4cxx/include slog/ &&\
    mkdir -p slog/lib/ &&\
    /bin/cp -f /usr/local/log4cxx/lib64/liblog4cxx.so* slog/lib/

RUN cd server/src && mkdir -p base/pb/lib/linux/ &&\
    /bin/cp -rf /usr/local/protobuf/lib/libprotobuf-lite.a base/pb/lib/linux/ &&\
    /bin/cp -rf /usr/local/protobuf/include/* base/pb/

RUN /bin/cp -a /usr/local/hiredis/* server/src/db_proxy_server

RUN cd pb && ./create.sh && ./sync.sh

# 编译服务端
RUN if [ -f server/im-server-1.0.0.tar.gz ]; then rm -Rf server/im-server-1.0.0.tar.gz; fi && cd server/src && sh build.sh version 1.0.0

# 复制开机运行sh
COPY ./docker/develop_server/main.sh /opt/main.sh
RUN chmod +x /opt/main.sh
RUN if [ -d im-server-1.0.0 ]; then rm -Rf im-server-1.0.0; fi  && tar -zxvf server/im-server-1.0.0.tar.gz
RUN cd im-server-1.0.0 && ./sync_lib_for_zip.sh
# 证书生成测试
# RUN openssl genpkey -algorithm RSA -aes256 -out apns-dev-key.pem -pass pass:tt@mogujie
# RUN openssl req -new -key apns-dev-key.pem -out apns-dev-csr.pem -passin pass:tt@mogujie -subj "/C=US/ST=YourState/L=YourCity/O=YourOrganization/OU=YourOrganizationalUnit/CN=YourCommonName"
# RUN openssl x509 -req -in apns-dev-csr.pem -signkey apns-dev-key.pem -out apns-dev-cert.pem -passin pass:tt@mogujie
VOLUME [ "/develop" ]
ENTRYPOINT [ "/opt/main.sh"]
CMD ["/bin/bash"]