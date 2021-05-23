FROM php:7.1-apache

RUN chmod +x -R /usr/local/bin


RUN apt-get update && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng-dev \
    && docker-php-ext-configure gd --with-gd --with-jpeg-dir \
    --with-png-dir --with-zlib-dir --with-freetype-dir \
    && docker-php-ext-install -j$(nproc) gd


ADD php.ini /usr/local/etc/php/php.ini

# remove default site setup
RUN rm /etc/apache2/sites-enabled/000-default.conf
# add setup for vhost
ADD apache-vhost.conf /etc/apache2/sites-enabled/000-apachevhost.conf
# add setup for config options
ADD apache.conf /etc/apache2/conf-enabled/000-apache.conf

# try to remove html folder - DOESN'T FUCKING WORK
RUN rm -d /var/www/html

# add mod_rewrite support
RUN a2enmod rewrite
# RUN ln -s /etc/apache2/mods-available/rewrite.load /etc/apache2/mods-enabled/rewrite.load
