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
# if [ $ID -ne 0 ]; then
#	       echo -e "\e[1;31;43m You are not the root user, you don't have permissions to run this \e["
#	       exit 1
#    else
#	      echo "you are the root user"
# fi
 if [ $? -ne 0 ]; then       # here its checks the exit status weather its zero | one
	       echo -e "\e[1;31;43m failure \e["
	       exit 1
    else
	      echo  -e "\e[1;3;46m success \e["

 fi
Print(){
  echo -e "\e[1;32;46m----------------------- $1  ---------\e[0m"
}
satus_check(){
  case $? in   # here its checks the exit status weather its zero | one
   0)
     echo "------success----"
   ;;
   *)
      echo"-----failure---"
    ;;
 esac
}

######### main program ##
 case $1 in
    frontend)
      Print "Installing Nginx"
            echo "installing the webserver"
                      yum install nginx -y  # to perform this you have to be root user
              satus_check
      Print "Curl schema"
          curl -s -L -o /tmp/frontend.zip "https://dev.azure.com/DevOps-Batches/ce99914a-0f7d-4c46-9ccc-e4d025115ea9/_apis/git/repositories/db389ddc-b576-4fd9-be14-b373d943d6ee/items?path=%2F&versionDescriptor%5BversionOptions%5D=0&versionDescriptor%5BversionType%5D=0&versionDescriptor%5Bversion%5D=master&resolveLfs=true&%24format=zip&api-version=5.0&download=true"
          satus_check
          cd /usr/share/nginx/html
          rm -rf *
          unzip -o /tmp/frontend.zip # unzip -o --overwrite the download each time
          mv static/* .
          rm -rf static README.md
          mv localhost.conf /etc/nginx/nginx.conf
          systemctl restart nginx
          systemctl enable nginx
          systemctl start nginx

            echo "completed the webserver"

            ;;
       mongod)
             Print "starting the mongod"
                   echo '[mongodb-org-4.2]
                          name=MongoDB Repository
                          baseurl=https://repo.mongodb.org/yum/redhat/$releasever/mongodb-org/4.2/x86_64/
                          gpgcheck=1
                          enabled=1
                          gpgkey=https://www.mongodb.org/static/pgp/server-4.2.asc' >/etc/yum.repos.d/mongodb.repo
             Print"Installing MongoDB"
              yum install -y mongodb-org
              satus_check
                          #cd /etc/mongod.conf

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
            echo " servers: $0 frontend|catalogue|cart|mongod"   # $0--> is the display the script name
            ;;
 esac
