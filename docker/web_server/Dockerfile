FROM lsqtzj/openeuler_nginx:php5.6
EXPOSE 80
WORKDIR /opt
RUN rm -Rf /www/wwwroot/default/*
COPY ./php /www/wwwroot/default
RUN chown -R www:www /www
COPY ./docker/web_server/setupweb.sh /opt/setupweb.sh
RUN chmod +x /opt/setupweb.sh

ENTRYPOINT [ "/opt/setupweb.sh"]
CMD ["/bin/bash"]