#!/bin/bash

#echo "starting nginx server"

echo "installing frontend"   # just print in the terminal
echo "installing catalogue"  #
echo "installing cart"       #

yum install nginx -y   #to install  frontend --nginx command


command return_value()  # using function to check weather previous command was success/failure (0/1-255)
{
  if [$? eq 0]
  then
    echo"the command is success full"
    else
    echo"command is  failure"
  fi
}
$ echo"Enter the server
          1. forntend
          2. catalogue
          3. cart"
          read n;

 case $n in

       echo " enter the 1 server"


 esac

