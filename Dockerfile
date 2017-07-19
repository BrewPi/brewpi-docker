FROM ubuntu:16.04
MAINTAINER BrewPi / Elco Jacobs <elco@brewpi.com>

# expose port 80, the default web server port
EXPOSE 80

# install apt dependencies
RUN apt-get update && apt-get install -y \
  build-essential \
  python-dev \
  python-pip \
  git \
  php-fpm \
  php7.0-mbstring \
  php7.0-xml \
  nginx \
  tzdata \
  sudo
  
# upgrade pip
RUN pip install -U pip

# install pip dependencies
RUN pip install pyserial psutil simplejson configobj gitpython --upgrade

# create users and add them to the right group
RUN useradd -G www-data,dialout brewpi
# set default password to brewpi:brewpi
RUN bash -c "echo -e \"brewpi\nbrewpi\"|passwd brewpi"

# remove existing content in web server root
RUN rm -rf /var/www/html

# clone brewpi repositories
RUN git clone --depth 1 https://github.com/BrewPi/brewpi-script /home/brewpi
RUN git clone --depth 1 https://github.com/BrewPi/brewpi-www /var/www/html

# just to be sure, also run the fixPermissions script
RUN /home/brewpi/utils/fixPermissions.sh

# copy nginx conf to nginx default
RUN mv /etc/nginx/sites-available/default /etc/nginx/sites-available/default.bak
COPY nginx-conf.txt /etc/nginx/sites-available/default

# Copy entrypoint script
ADD entrypoint.sh /root
RUN chmod +x /root/entrypoint.sh

# Copy script that periodically checks the script status
ADD watcher.sh /root
RUN chmod +x /root/watcher.sh

WORKDIR /home/brewpi/

ENTRYPOINT "/root/entrypoint.sh"

CMD "/root/watcher.sh"