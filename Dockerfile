FROM wordpress:6.6.2-php8.3-apache

ENV DEBIAN_FRONTEND noninteractive

ENV TZ=UTC

RUN apt-get update && apt-get upgrade -y \
    && apt-get install build-essential git libv8-dev -y \
    && curl -sLS https://getcomposer.org/installer | php -- --install-dir=/usr/bin/ --filename=composer

WORKDIR /tmp

RUN git clone https://github.com/phpv8/v8js.git \
    && cd v8js \
    && phpize \
    && ./configure \
    && make \
    && make install \
    && sh -c 'echo "extension=v8js.so" > $PHP_INI_DIR/conf.d/20-v8js.ini'

RUN apt-get -y autoremove \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


WORKDIR /var/www/html/

EXPOSE 80

ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["apache2-foreground"]
