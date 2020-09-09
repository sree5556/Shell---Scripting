#!/bin/bash



user_id=$(id -u)
 case $user_id in
    0)
       echo "you are root user u can proceed with this command "
        ;;
      *)
        echo -e "\e[1;31;43m you should be root user to perform this\e[0m" #colors  for errors
        exit 1
        ;;
 esac
 if [ $ID -ne 0 ]; then
	       echo -e "\e[1;31;43m You are not the root user, you don't have permissions to run this \e["
	       exit 1
    else
	      echo "you are the root user"
 fi
 if [ $? -ne 0 ]; then       # here its checks the exit status weather its zero | one
	       echo -e "\e[1;31;43m failure \e["
	       exit 1
    else
	      echo  -e "\e[1;3;46m success \e["

 fi

 case $? in   # here its checks the exit status weather its zero | one
   0)
     echo "------sucess----"
   ;;
   *)
      echo"-----failure---"
    ;;
 esac

 case $1 in
    forntend)
            echo "installing the webserver"
                      yum install nginx -y  # to perform this you have to be root user
            echo "completed the webserver"
            ;;
    catalogue)
            echo "installing the catalogue"
            echo "completed  the catalogue"
            ;;
    cart)
            echo "installing the cart"
            echo "completed  the cart"
            ;;
    *)
            echo "invalid inputs please give the below listed servers"
            echo " servers: $0 forntend|catalogue|cart"   # $0--> is the display the script name
            ;;
 esac
