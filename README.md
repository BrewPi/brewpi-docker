# brewpi-docker: docker images to run a BrewPi server

This docker container runs the web interface and python scripts for BrewPi.

We have an image based on Ubuntu 16.04 and an image based on raspbian.

To deploy a brewpi container, take these steps:

For a raspberry pi (running hypriot)
------------------------------------
Get the latest raspbian based image image 
```
docker pull brewpi/brewpi-raspbian
```
Deploy a new container. Modify the command below to to your liking, especially the port and the data location on the host (default is `~/brewpi-data`).
``` bash
docker run -d --name brewpi -p 80:80 -v ~/brewpi-data:/data -v /etc/timezone:/etc/timezone -v /etc/localtime:/etc/localtime --restart always brewpi/brewpi-raspbian
```


For x64/x86 based systems
-------------------------

Get the latest ubuntu based image image 
```
docker pull brewpi/brewpi-ubuntu
```
Deploy a new container. Modify the command below to to your liking, especially the port and the data location on the host (default is `~/brewpi-data`).
``` bash
docker run -d --name brewpi -p 80:80 -v ~/brewpi-data:/data -v /etc/timezone:/etc/timezone -v /etc/localtime:/etc/localtime --restart always brewpi/brewpi-ubuntu
```



Let's break that down to explain each part.


| Parameter               | Explanation                                                                                                               |
|-------------------------|---------------------------------------------------------------------------------------------------------------------------|
| -d                      | After starting the container, run it as daemon in the background.                                                         |
| --name brewpi           | Name the new container brewpi, modify this you are running multiple brewpi containers.                                    |
| -p 80:80                | Map port 80 of the container to port 80 of the host. <br> If port 80 is in use, use a differnt port, for example 8000:80. |
| -v ~/brewpi-data:/data  | Store data and settings in ~/brewpi-data on the host.                                                                     |
|-v /etc/timezone:/etc/timezone <br> -v /etc/localtime:/etc/localtime | Use timezone from the host.                                                   |
| --restart always        | Start on boot and always restart the container when it stops.                                                             |
| brewpi/brewpi-raspbian  | The image that is used. Use`brewpi/brewpi-raspbian` for the raspberry pi, `brewpi/brewpi-ubuntu` for x64/x86 systems.     |

