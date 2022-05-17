FROM ubuntu:16.04
LABEL org.opencontainers.image.authors="dev@christopher-luna.com"

ENV DEBIAN_FRONTEND noninteractive
ENV LC_ALL C.UTF-8
ENV APP_NAME="my.imouto"
ENV SERVER_HOST="127.0.0.1:3000"
ENV URL_BASE="http://127.0.0.1:3000"
ENV MYSQL_SERVER="172.17.0.1"
ENV MYSQL_PORT="3306"
ENV MYSQL_DATABASE="myimouto"
ENV MYSQL_USERNAME="root"
ENV MYSQL_PASSWORD="mysqlpassword"
ENV ADMIN_USERNAME="admin"
ENV ADMIN_PASSWORD="password"
ENV TZ="UTC"
ENV MAX_FILESIZE="50M"
ENV POST_MAX_SIZE="250M"
ENV DISPLAY_ERRORS="On"

RUN apt-get update && \
  apt-get -y install \
    imagemagick \
    mysql-client-5.7 \
    nginx \
    php-curl \
    php-fpm \
    php-imagick \
    php-mysql \
    php-xml \
    unzip && \
    apt -y autoremove && \
    apt-get -y clean

RUN sed -i "59 s/$/\n\tclient_max_body_size 50M;/" /etc/nginx/nginx.conf
WORKDIR /root/

RUN mkdir -p /srv
RUN mkdir -p /config
WORKDIR /srv
RUN apt-get -y install git && \
    git clone https://github.com/chris-l/myimouto.git --depth 1 && \
    apt-get -y remove git && \
    apt -y autoremove && \
    apt-get -y clean
RUN mkdir /install
RUN mv /srv/myimouto/install.php /install/
COPY config.php /install/
COPY set-admin-pass.php /srv/myimouto/
COPY remove-rename.diff /srv/myimouto/
WORKDIR /srv/myimouto
RUN apt-get -y install patch && \
    patch -p0 -i remove-rename.diff && \
    apt-get -y remove patch && \
    apt -y autoremove && \
    apt-get -y clean
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
    php composer-setup.php && \
    php -r "unlink('composer-setup.php');" && \
    mv composer.phar /usr/local/bin/composer && \
    composer install && \
    rm /usr/local/bin/composer
RUN mkdir -p /srv/myimouto/public/data/
RUN mkdir -p /srv/myimouto/log
RUN mkdir -p /srv/myimouto/tmp

RUN chown -R www-data:www-data /srv/myimouto/public/data
RUN chown -R www-data:www-data /srv/myimouto/log
RUN chown -R www-data:www-data /srv/myimouto/tmp

COPY nginx /etc/nginx/sites-enabled/default
RUN mkdir -p /run/php/

RUN update-rc.d php7.0-fpm defaults
COPY run-httpd /usr/local/bin/
RUN chmod 755 /usr/local/bin/run-httpd

VOLUME /srv/myimouto/public/data /config
EXPOSE 3000
CMD ["/usr/local/bin/run-httpd"]

