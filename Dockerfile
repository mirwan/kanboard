FROM ubuntu:14.04
MAINTAINER Frederic Guillot <fred@kanboard.net>

RUN apt-get update && apt-get install -y apache2 php5 php5-sqlite php5-gd php5-ldap git curl && apt-get clean
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf
RUN curl -sS https://getcomposer.org/installer | php -- --filename=/usr/local/bin/composer
RUN cd /var/www && git clone -b dockerfile_depenencies https://github.com/mirwan/kanboard.git
RUN cd /var/www/kanboard && composer install
RUN rm -rf /var/www/html && mv /var/www/kanboard /var/www/html
RUN chown -R www-data:www-data /var/www/html/data

EXPOSE 80

ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_PID_FILE /var/run/apache2.pid

CMD /usr/sbin/apache2ctl -D FOREGROUND
