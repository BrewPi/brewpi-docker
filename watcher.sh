#!/bin/bash

while [ true ]
do
  sudo -u brewpi python /home/brewpi/brewpi.py --checkstartuponly --dontrunfile; [ $? != 0 ] && \
  sudo -u brewpi python -u /home/brewpi/brewpi.py 1>/home/brewpi/logs/stdout.txt 2>>/home/brewpi/logs/stderr.txt
  sleep 10
done
