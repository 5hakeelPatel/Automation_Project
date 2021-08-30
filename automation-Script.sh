#!/usr/bin/bash

sudo apt update -y

user=shakeelpatel   #enter the name here
s3_bucket="s3://upgrad-$user"
timestamp=$(date '+%d%m%Y-%H%M%S')

temp=$( dpkg --get-selections | grep -w -c 'apache2' )

if [[ $tmpe == 0 || $tmpe == "" ]]
	then
		echo "appache is not installed"
		echo "Installing Appache"
		sudo apt update
		sudo apt install -qq -y apache2
fi

 
#	echo "appache is  available"	

status_apache=$( service apache2 status | grep -w -c "Active: active" )
# echo $status_apache
if [[ $status_apache == 1 ]]
   then echo " Server is Up and running "

else
    echo "Starting Apache2 server"
    service apache2 start 
fi
	
	#Log 
tar -cvf /tmp/$user-httpd-logs-$timestamp.tar  /var/log/apache2/*.log 
             #backing up log all files
aws s3 cp /tmp/ $s3_bucket  --recursive --exclude "*" --include "*.tar"

#Bookkeeping
if [ -e /var/www/html/inventory.html ]
then
echo "<br>httpd-logs &nbsp;&nbsp;&nbsp; ${timestamp} &nbsp;&nbsp;&nbsp; tar &nbsp;&nbsp;&nbsp; ${size}" >> /var/www/html/inventory.html
else
echo "<b>Log Type &nbsp;&nbsp;&nbsp;&nbsp; Date Created &nbsp;&nbsp;&nbsp;&nbsp; Type &nbsp;&nbsp;&nbsp;&nbsp; Size</b><br>" > /var/www/html/inventory.html
echo "<br>httpd-logs &nbsp;&nbsp;&nbsp; ${timestamp} &nbsp;&nbsp;&nbsp; tar &nbsp;&nbsp;&nbsp; ${size}" >> /var/www/html/inventory.html
fi

