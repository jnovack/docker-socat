FROM alpine:3.7

ARG version=1.0.0
ARG build_date=unknown
ARG commit_hash=unknown
ARG vcs_url=unknown
ARG vcs_branch=unknown

LABEL org.label-schema.vendor='Softonic' \
    org.label-schema.name='Socat' \
    org.label-schema.description='Exposes a TCP INPUT endpoint to a defined OUTPUT port.' \
    org.label-schema.usage='README.md' \
    org.label-schema.url='https://github.com/jnovack/docker-socat/blob/master/README.md' \
    org.label-schema.vcs-url=$vcs_url \
    org.label-schema.vcs-branch=$vcs_branch \
    org.label-schema.vcs-ref=$commit_hash \
    org.label-schema.version=$version \
    org.label-schema.schema-version='1.0' \
    org.label-schema.docker.cmd.devel='' \
    org.label-schema.docker.params='IN=Input,OUT=Output' \
    org.label-schema.build-date=$build_date

ENV IN=172.18.0.1:9393 \
    OUT=9393

RUN apk add --no-cache socat

ENTRYPOINT socat -d -d TCP-L:$OUT,fork TCP:$IN
