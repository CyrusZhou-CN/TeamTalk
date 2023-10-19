
FROM lsqtzj/teamtalk_develop_server AS builder

FROM lsqtzj/openeuler_nginx:php5.6

COPY --from=builder /usr/local/bin/btop /usr/local/bin/btop
COPY --from=builder /usr/local/share/btop /usr/local/share/btop
COPY --from=builder /usr/local/share/applications/btop.desktop /usr/local/share/applications/btop.desktop
COPY --from=builder /usr/local/share/icons/hicolor/48x48/apps/btop.png /usr/local/share/icons/hicolor/48x48/apps/btop.png
COPY --from=builder /usr/local/share/icons/hicolor/scalable/apps/btop.svg /usr/local/share/icons/hicolor/scalable/apps/btop.svg

EXPOSE 80
WORKDIR /opt
RUN rm -Rf /www/wwwroot/default/*
COPY ./php /www/wwwroot/default
RUN chown -R www:www /www
COPY ./docker/web_server/setupweb.sh /opt/setupweb.sh
RUN chmod +x /opt/setupweb.sh
ENV LC_ALL=en_US.UTF-8
ENV LANG=en_US.UTF-8
ENTRYPOINT [ "/opt/setupweb.sh"]
CMD ["/bin/bash"]