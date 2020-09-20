#!/bin/bash
### now we will check the status  weather its was sucess are not
### weather root user or not
status_check()
{
  if [ $? -ne 0 ]; then
    echo "*******************success******************"
    else
    echo "*******************failure****************"
    exit 1
 fi
}

# user_id=$(id -u)
# if [ $user_id -ne 0 ]; then
#   echo "u r root user"
#   else
#     echo "u don't have access"
#    exit 2
# fi
case $USER_ID in
  0)
    echo "Starting Installation"
  ;;
  *)
    echo -e "\e[1;31mYou should be a root user to perform this script\e[0m"
    exit 1
    ;;
esac
Print(){
  echo "********************$1********************"
}

#main program for reids

Print "Downloding the redis"
yum install epel-release yum-utils -y
status_check
Print "remi release"
yum install http://rpms.remirepo.net/enterprise/remi-release-7.rpm -y
yum-config-manager --enable remi
status_check
Print "Installing redis"
yum install redis -y
status_check

Print "now change the bindip"
##Update the BindIP from 127.0.0.1 to 0.0.0.0 in config file /etc/redis.conf

##  -e returns true if the target exists. Doesn't matter if it's a file, pipe, special device, whatever.
##   The only condition where something may exist, and -e will return false is in the case of a broken symlink.

if [ -e /etc/redis.conf ]; then
  ## sed -i -e "s/bind 127.0.0.1/0.0.0.0/"/etc/redis.conf-----> that ip add are there for 2times ---> we particualrlly change the one so by using [^(starting of)bind]
   sed -i -e "/^bind 127.0.0.1/ c 0.0.0.0" /etc/redis.conf   # bash -c copy
fi
status_check
Print "start the redis"
systemctl enable redis
systemctl start redis
