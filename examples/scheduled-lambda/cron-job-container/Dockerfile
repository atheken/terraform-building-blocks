FROM alpine:3.16.2 AS base
RUN apk add curl bash
ENV LAMBDA_RUNTIME_DIR=/var/runtime
ENV LAMBDA_TASK_ROOT=/var/task
RUN mkdir -p ${LAMBDA_RUNTIME_DIR}
RUN mkdir -p ${LAMBDA_TASK_ROOT}
WORKDIR ${LAMBDA_TASK_ROOT}

# https://github.com/aws/aws-lambda-runtime-interface-emulator - we are building for arm64 here.
RUN curl https://github.com/aws/aws-lambda-runtime-interface-emulator/releases/latest/download/aws-lambda-rie-arm64 > /usr/local/bin/aws-lambda-rie
COPY ./lambda-entrypoint.sh /
COPY ./bootstrap.sh  ${LAMBDA_RUNTIME_DIR}/bootstrap
ENTRYPOINT [ "/lambda-entrypoint.sh" ]

# This will use the base image we just built and place our custom script in it.
FROM base
COPY ./job.sh ${LAMBDA_TASK_ROOT}/