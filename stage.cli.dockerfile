FROM BASEIMAGE
COPY rootfs /

RUN chmod +x /usr/local/bin/docker-entrypoint.sh \
             /usr/local/bin/detect-external-ip.sh \
 && ln -s /usr/local/bin/detect-external-ip.sh \
          /usr/local/bin/detect-external-ip


EXPOSE 3478 3478/udp

VOLUME ["/var/lib/coturn"]

ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["--log-file=stdout", "--external-ip=$(detect-external-ip)"]