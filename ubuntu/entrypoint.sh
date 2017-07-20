#!/bin/bash

# check if persisted data already exists
if [ "$(ls -A /brewpi)" ]; then
  # if files already exist, remove the defaults.
  # We'll replace them with symlinks to persisted data
  echo "Persistent files already present"
  rm -rf /home/brewpi/settings
  rm -rf /home/brewpi/data
  rm -rf /home/brewpi/logs
  rm -rf /var/www/html/data
else
  echo "Setting up new persisted data directory outside of container"
  # if files don't exist, copy them to the persisted location outside the container
  mv /home/brewpi/settings /brewpi/settings
  mv /home/brewpi/data /brewpi/data
  mv /home/brewpi/logs /brewpi/logs
  mv /var/www/html/data /brewpi/html_data
fi

# create symlinks to persisted data outside of container
ln -s -b /brewpi/settings /home/brewpi/settings
ln -s -b /brewpi/data /home/brewpi/data
ln -s -b /brewpi/logs /home/brewpi/logs
ln -s -b /brewpi/html_data /var/www/html/data

# set ownership of files in persisted directory
chown -R brewpi:brewpi /brewpi/
chown -R brewpi:www-data /brewpi/html_data/

# Make sure to always have the log files around
sudo -u brewpi mkdir -p /home/brewpi/logs
sudo -u brewpi touch /home/brewpi/logs/stderr.txt
sudo -u brewpi touch /home/brewpi/logs/stdout.txt

service nginx start
service php7.0-fpm start

# run command if passed to the container, instead of running watcher.sh
exec $@
