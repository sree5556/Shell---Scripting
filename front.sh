#!/bin/bash

#echo "starting nginx server"

function errorcheck()
{
 if [ $? eq 0 ];
   then
    echo "the command is success"
    else
    echo "command is  failure"
  fi
}


select item in servers;
 do
    $ echo " Enter the server
         1. frontend
         2. catalogue
         3. cart "
        read n;
done


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
 echo "installing frontend"   # just print in the terminal
 echo "installing catalogue"  #
 echo "installing cart"       #

              #yum install nginx -y   #to install  frontend --nginx command




