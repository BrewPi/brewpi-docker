#!/bin/sh

# check if persisted data already exists
if [ "$(ls -A /data)" ]; then
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
  mv /home/brewpi/settings /data/settings
  mv /home/brewpi/data /data/data
  mv /home/brewpi/logs /data/logs
  mv /var/www/html/data /data/html_data
fi

# create symlinks to persisted data outside of container
ln -s -b /data/settings /home/brewpi/settings
ln -s -b /data/data /home/brewpi/data
ln -s -b /data/logs /home/brewpi/logs
ln -s -b /data/html_data /var/www/html/data

# set ownership of files in persisted directory
chown -R brewpi:brewpi /data
chown -R brewpi:www-data /data/html_data

# Make sure to always have the log files around
sudo -u brewpi mkdir -p /home/brewpi/logs
sudo -u brewpi touch /home/brewpi/logs/stderr.txt
sudo -u brewpi touch /home/brewpi/logs/stdout.txt

# setup default password for port 81 if the password file doesn't exist
if ! [ -f /data/settings/brewpi.htpasswd ]; then
  htpasswd -bc /data/settings/brewpi.htpasswd brewer brewpi
fi

# make sure a config.cfg file exist, so it is easier for users to edit it
if ! [ -f /data/settings/config.cfg ]; then
  sudo -u brewpi cp /data/settings/config.cfg.example /data/settings/config.cfg
fi

service nginx start
service php7.0-fpm start

# run command if passed to the container, instead of running watcher.sh
exec "$@"
