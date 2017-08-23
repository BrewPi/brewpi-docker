#!/bin/sh

while true
do
  if ! sudo -u brewpi python /home/brewpi/brewpi.py --checkstartuponly --dontrunfile
    then sudo -u brewpi python -u /home/brewpi/brewpi.py 1>/home/brewpi/logs/stdout.txt 2>>/home/brewpi/logs/stderr.txt
  fi
  sleep 30
done
