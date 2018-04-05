FROM ubuntu:latest
MAINTAINER Sean Roger <arceseanroger@gmail.com>

# Install apache, PHP, and supplimentary programs. curl, and lynx-cur are for debugging the container.
RUN apt-get update && apt-get -y upgrade && DEBIAN_FRONTEND=noninteractive
RUN apt-get -y install imagemagick
RUN apt-get -y install vim apache2 php libapache2-mod-php php-mcrypt php-curl php-cli php-common php-json php-mysql php-readline php-mbstring php-xml php-imagick php-zip curl php-intl lynx-cur php-soap poppler-utils

# Enable apache mods.
RUN a2enmod php7.1
RUN a2enmod rewrite

# Update the PHP.ini file
RUN sed -i "s/memory_limit = 128M/memory_limit = 500M/" /etc/php/7.1/apache2/php.ini
RUN sed -i "s/post_max_size = 8M/post_max_size = 25M/" /etc/php/7.1/apache2/php.ini
RUN sed -i "s/upload_max_filesize = 2M/upload_max_filesize = 25M/" /etc/php/7.1/apache2/php.ini

# Manually set up the apache environment variables
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_PID_FILE /var/run/apache2.pid

# Expose apache.
EXPOSE 80

# Update the default apache site with the config we created.
ADD apache-config.conf /etc/apache2/sites-enabled/000-default.conf

# By default start up apache in the foreground
CMD /usr/sbin/apache2ctl -D FOREGROUND
