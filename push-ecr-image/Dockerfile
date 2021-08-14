FROM alpine:3.11
RUN apk add docker-cli bash
RUN apk add --update \
    python \
    python-dev \
    py-pip \
    build-base \
    && pip install awscli==1.18.52 --upgrade --user --no-warn-script-location \
    && apk --purge -v del py-pip \
    && rm -rf /var/cache/apk/*
RUN ln -s /root/.local/bin/aws /usr/bin/aws
RUN mkdir /data
COPY ./docker-push.sh /docker-push.sh
VOLUME [ "/var/run/docker.sock", "/data" ]
ENTRYPOINT [ "/docker-push.sh" ]