#!/bin/bash

# Make sure to always have the log files around
sudo -u brewpi mkdir -p /home/brewpi/logs
sudo -u brewpi touch /home/brewpi/logs/stderr.txt
sudo -u brewpi touch /home/brewpi/logs/stdout.txt

service nginx start
service php7.0-fpm start

# never exit
tail -f /dev/null