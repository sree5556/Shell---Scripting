#!/bin/bash

#echo "starting nginx server"

 echo "installing frontend"   # just print in the terminal
 echo "installing catalogue"  #
 echo "installing cart"       #

              #yum install nginx -y   #to install  frontend --nginx command
command return_value ()
{
  if [$? eq 0]
  then
    echo "the command is success full"
    else
    echo "command is  failure"
  fi
}
return_value

$ echo " Enter the server
         1. forntend
         2. catalogue
         3. cart "
        read n;

 case $n in
      frontend)
             echo " enter the 1 server" ;;
      catalogue)
             echo "enter the 2 server" ;;
      cart)
             echo "enter the 3 server" ;;
      *)
        echo "enter the above servers list" ;;

 esac