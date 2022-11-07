FROM amazon/aws-cli:2.8.9
ENV AWS_SDK_LOAD_CONFIG=true
ENV AWS_PAGER=''
RUN yum install -y bash jq
RUN amazon-linux-extras install -y docker=18.09.9
RUN ln -s /root/.local/bin/aws /usr/bin/aws
RUN mkdir /data
COPY ./docker-push.sh /docker-push.sh
VOLUME [ "/var/run/docker.sock", "/data" ]
ENTRYPOINT [ "/docker-push.sh" ]