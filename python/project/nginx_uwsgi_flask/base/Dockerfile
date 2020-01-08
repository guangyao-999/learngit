FROM alpine:3.8

LABEL author='suguangyao' email='xxx@qq.com' purpose='nginx+uwsgi+python3基础镜像'

RUN set -ex \
    && echo "https://mirror.tuna.tsinghua.edu.cn/alpine/v3.8/main/" > /etc/apk/repositories \
    && apk add --update --upgrade \
    && apk add --no-cache nginx python3 uwsgi uwsgi-python3 \
    && pip3 install --no-cache-dir --upgrade pip \
    && ln -s /usr/bin/python3 /usr/bin/python \
