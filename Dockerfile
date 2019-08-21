FROM ubuntu:18.04
LABEL author="xjx"
ARG FILE_PATH=/var/
WORKDIR ${FILE_PATH}
ADD docker-entrypoint.sh /bin/
RUN cp /etc/apt/sources.list /etc/apt/sources_init.list && \
    sed -i 's/archive.ubuntu.com/mirrors.tuna.tsinghua.edu.cn/g' /etc/apt/sources.list && \
    apt update && \
    apt-get update -y && \
    apt-get upgrade -y && \
    apt-get install -y vim && \
    apt-get install -y curl
RUN export DEBIAN_FRONTEND=noninteractive && \
    apt-get install -y tzdata && \
    ln -fs /usr/share/zoneinfo/Europe/Stockholm /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata
RUN apt-get install -y software-properties-common && \
    add-apt-repository ppa:ondrej/php && \ 
    apt-get update -y
RUN apt-get -y install php7.2 && \
    apt-get install -y php7.2-fpm && \
    apt-get install -y php7.2-gd && \
    apt-get install -y php7.2-intl && \
    apt-get install -y php7.2-xsl && \
    apt-get install -y  php7.2-curl && \
    apt-get install -y  php7.2-mysql && \
    apt-get install -y  php7.2-json && \
    apt-get install -y  php7.2-mbstring && \
    apt-get install -y  php7.2-mysqlnd && \
    apt-get install -y  php7.2-xml && \
    apt-get install -y  php7.2-xmlrpc && \
    apt-get install -y  php7.2-opcache && \
    apt-get install -y  php7.2-sqlite3 && \
    apt-get install -y  php7.2-soap && \
    apt-get install -y  php7.2-gmp   && \
    apt-get install -y php7.2-odbc      && \
    apt-get install -y php7.2-pspell    && \
    apt-get install -y php7.2-bcmath  && \
    apt-get install -y php7.2-enchant   && \
    apt-get install -y php7.2-imap      && \
    apt-get install -y php7.2-ldap      && \
    apt-get install -y php7.2-opcache  && \
    apt-get install -y php7.2-readline  && \
    apt-get install -y php7.2-xmlrpc && \
    apt-get install -y php7.2-bz2 && \
    apt-get install -y php7.2-interbase   && \
    apt-get install -y php7.2-pgsql     && \
    apt-get install -y php7.2-recode    && \
    apt-get install -y php7.2-sybase  && \  
    apt-get install -y php7.2-cgi && \       
    apt-get install -y php7.2-dba && \
    apt-get install -y php7.2-phpdbg && \   
    apt-get install -y php7.2-snmp && \     
    apt-get install -y php7.2-tidy && \     
    apt-get install -y php7.2-zip 
RUN apt-get install -y git && \
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
#    chmod 777 ${FILE_PATH}avbook/ && \
    cd avbook && \
    composer install && \
    apt-get install -y  nginx

EXPOSE 80
WORKDIR ${FILE_PATH}avbook/
CMD [ "php","artisan","serve"]
ENTRYPOINT ["sh","/bin/docker-entrypoint.sh"]
