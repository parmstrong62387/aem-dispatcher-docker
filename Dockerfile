FROM ubuntu:bionic

RUN apt-get update && apt-get install -y apache2

ADD mod_dispatcher.so /usr/lib/apache2/modules/mod_dispatcher.so
RUN chmod 644 /usr/lib/apache2/modules/mod_dispatcher.so

ADD dispatcher.any /etc/apache2/conf-enabled/dispatcher.any
ADD farm_agents.any /etc/apache2/conf-enabled/farm_agents.any
ADD dispatcher.conf /etc/apache2/conf-available/dispatcher.conf
ADD agents.conf /etc/apache2/conf-available/agents.conf
ADD conf.d /etc/apache2/conf.d
RUN a2enmod headers
RUN a2enmod expires
RUN a2enconf dispatcher

RUN mkdir -p /var/www/html/agents
RUN chown -R www-data /var/www/html

CMD apachectl start && tail -F /var/log/apache2/error.log | sed 's/^/error.log: /' & tail -F /var/log/apache2/dispatcher.log | sed 's/^/dispatcher.log: /'
