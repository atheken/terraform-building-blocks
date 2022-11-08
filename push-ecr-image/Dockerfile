FROM alpine:3.11
RUN apk add bash docker-cli
RUN mkdir /data
COPY ./docker-push.sh /docker-push.sh
VOLUME [ "/var/run/docker.sock", "/data" ]
ENTRYPOINT [ "/docker-push.sh" ]