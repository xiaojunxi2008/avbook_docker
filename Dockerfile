FROM php:7.2-cli
LABEL author="xjx"
ARG FILE_PATH=/var/
WORKDIR ${FILE_PATH}
ADD docker-entrypoint.sh /bin/
RUN cp /etc/apt/sources.list /etc/apt/sources_init.list && \
    sed -i 's/archive.ubuntu.com/mirrors.tuna.tsinghua.edu.cn/g' /etc/apt/sources.list && \
    apt-get update -y && \
    apt-get upgrade -y && \
    apt-get install -y git  && \
    cd ${FILE_PATH} && \
#    git config --global http.sslVerify false && \
#    git config --global http.postBuffer 1048576000 && \
    git clone --depth=1 https://github.com/xiaojunxi2008/avbook.git && \
    apt-get install -y wget && \
    apt-get install zip unzip && \
    wget https://getcomposer.org/composer.phar && \
    mv composer.phar composer && \
#    groupadd -r avbook && \
#    useradd -r -g avbook avbook && \
#    su avbook && \
    chmod +x composer && \
    mv composer /usr/local/bin && \
    cd avbook && \
    composer install

WORKDIR ${FILE_PATH}avbook/
CMD [ "php","artisan","serve"]
ENTRYPOINT ["sh","/bin/docker-entrypoint.sh"]
