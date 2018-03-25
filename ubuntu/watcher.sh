#!/bin/sh

while true
do
  if ! python /home/brewpi/brewpi.py --checkstartuponly --dontrunfile
    then python -u /home/brewpi/brewpi.py 1>/home/brewpi/logs/stdout.txt 2>>/home/brewpi/logs/stderr.txt
  fi
  sleep 10
done
