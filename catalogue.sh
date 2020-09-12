#!/bin/bash

user_id=$(id -u)
 case $user_id in
    0)
    echo "your the root user"
    ;;
    *)
    echo "u dont have permission"
    ;;
 esac
 status_check()
 {
   case $? in
    0)
    echo "your allowed"
    ;;
    *)
    echo "sorry your not allowed"
    ;;
   esac
 }
 Print()
 {
    echo "************* $1*******************"
 }

# above program tested working fine

##### "Main Pro-Gram Starts"

case $1 in
       front)
         echo "starting of nginx"
         Print "installing the nginx"
         yum install nginx -y
         status_check
         Print "loading of nginx"
         systemctl enable nginx
         systemctl start nginx
         Print "loading the schema"
         curl -s -L -o /tmp/frontend.zip "https://dev.azure.com/DevOps-Batches/ce99914a-0f7d-4c46-9ccc-e4d025115ea9/_apis/git/repositories/db389ddc-b576-4fd9-be14-b373d943d6ee/items?path=%2F&versionDescriptor%5BversionOptions%5D=0&versionDescriptor%5BversionType%5D=0&versionDescriptor%5Bversion%5D=master&resolveLfs=true&%24format=zip&api-version=5.0&download=true"
         status_check
         Print "schema success"
         Print "*****Configuration Start******"
          cd /usr/share/nginx/html
          rm -rf *
          status_check
          Print "Extracting the zip file"
          unzip -o /tmp/frontend.zip
          mv static/* .
          rm -rf static README.md
          mv localhost.conf /etc/nginx/nginx.conf
         Print "*****Configuration completed******"
         systemctl restart nginx
         systemctl enable nginx
         systemctl start nginx
         ;;
       *)
         echo "program invalid"



esac

