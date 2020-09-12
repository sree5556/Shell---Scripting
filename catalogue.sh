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
       mongod)
         status_check
         Print "  Starting of Mongod "
         Print "settinng of repos"
         echo '[mongodb-org-4.2]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/redhat/$releasever/mongodb-org/4.2/x86_64/
gpgcheck=1
enabled=1
gpgkey=https://www.mongodb.org/static/pgp/server-4.2.asc' >/etc/yum.repos.d/mongodb.repo
         status_check
         #### still above code is okay
         ## now im going to next steps
         Print "mongod starting"
         Print "Downloading the mongod"
         yum install -y mongodb-org
         status_check
         systemctl enable mongod
         systemctl start mongod
         Print " *****configuration starts ******"
         Print " bindIp: 127.0.0.1  # Enter 0.0.0.0 "
         Print " <file_nmae : vim /etc/mongod.conf> "
         sed -i 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf
         Print "Bind ip- changed"
         status_check
         systemctl restart mongod
         Print"Downloading the schema"
         curl -s -L -o /tmp/mongodb.zip "https://dev.azure.com/DevOps-Batches/ce99914a-0f7d-4c46-9ccc-e4d025115ea9/_apis/git/repositories/e9218aed-a297-4945-9ddc-94156bd81427/items?path=%2F&versionDescriptor%5BversionOptions%5D=0&versionDescriptor%5BversionType%5D=0&versionDescriptor%5Bversion%5D=master&resolveLfs=true&%24format=zip&api-version=5.0&download=true"
         status_check
         cd /tmp
         Print "Extracting the unzip file"
         unzip -o mongodb.zip
         status_check
         ;;
       *)
         echo "program invalid"

         ;;



esac

