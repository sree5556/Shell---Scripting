#!/bin/bash


#DNS_DOMAIN_NAME="helodevops.tech"
user_id=$(id -u)
 case $user_id in
    0)
    echo "your the root user"
    ;;
    *)
    echo "u don't have permission"
    exit 2
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
    exit 3
    ;;
   esac
 }
 Print()
 {
    echo "************************* $1*************************************"
 }

# above program tested working fine

#nodejs_setup()
#{
#  ## java installation and repeated 3 times so making function
#  Print "Installing Node JS"
#  yum install nodejs make gcc-c++ -y
#  status_check
#  Print "Downloading completed"
#  Print "*************User add**************"
#  id roboshop
#  case $? in
#      1)
#        Print "Add the Application user"
#        useradd roboshop
#        status_check
#      ;;
#  esac
#  Print "user switched from to roboshop "
#  Print "Download the schema"
#  curl -s -L -o /tmp/$1.zip "$2"
#  status_check
#  cd /home/roboshop
#  mkdir $1
#  cd $1
#  Print "Extracting the zip file"
#  unzip -o /tmp/$1.zip
#  status_check
#  #####
#  npm --unsafe-perm install
#  status_check
#  chown roboshop:roboshop /home/roboshop -R
#  Print "Setup $1 Service"
#  mv /home/roboshop/$1/systemd.service /etc/systemd/system/$1.service
#
#  ### manually we will give ip add ,but here route53--dns server
#
#  sed -i -e "s/MONGO_ENDPOINT/mongodb.${DNS_DOMAIN_NAME}/" /etc/systemd/system/$1.service
#  sed -i -e "s/REDIS_ENDPOINT/redis.${DNS_DOMAIN_NAME}/" /etc/systemd/system/$1.service
#  sed -i -e "s/CATALOGUE_ENDPOINT/catalogue.${DNS_DOMAIN_NAME}/" /etc/systemd/system/$1.service
#  status_check
#  Print "Start $1 Service"
#  systemctl daemon-reload
#  systemctl enable $1
#  systemctl start $1
#  status_check
# # npm install
#}


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



#          export CATALOGUE=catalogue.${DNS_DOMAIN_NAME}
#          export CART=cart.${DNS_DOMAIN_NAME}
#          export USER=user.${DNS_DOMAIN_NAME}
#          export SHIPPING=shipping.${DNS_DOMAIN_NAME}
#          export PAYMENT=payment.${DNS_DOMAIN_NAME}
#
#          envsubst < template.conf > /etc/nginx/nginx.conf

         Print "*****Configuration completed******"
         systemctl restart nginx
         systemctl enable nginx
         systemctl start nginx
         ;;
       mongod)
         status_check
         Print "  Starting of Mongod "
         Print "setting of repos"
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
         Print " <file_name: vim /etc/mongod.conf> "
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
         ############# above program was fine
         mongo < catalogue.js
         mongo < users.js
         systemctl restart mongod
         systemctl enable mongod
         systemctl start mongod
         ;;
#       catalogue)
#         Print "starting of catalogue"
#         ## $1--- "catalogue" $2--- "url"
#         nodejs_setup "catalogue" "https://dev.azure.com/DevOps-Batches/ce99914a-0f7d-4c46-9ccc-e4d025115ea9/_apis/git/repositories/558568c8-174a-4076-af6c-51bf129e93bb/items?path=%2F&versionDescriptor%5BversionOptions%5D=0&versionDescriptor%5BversionType%5D=0&versionDescriptor%5Bversion%5D=master&resolveLfs=true&%24format=zip&api-version=5.0&download=true"
#
#         ;;
#       cart)
#           Print "starting of catalogue"
#           ## $1--- "cart" $2--- "url"
#           nodejs_setup "cart" "https://dev.azure.com/DevOps-Batches/ce99914a-0f7d-4c46-9ccc-e4d025115ea9/_apis/git/repositories/ac4e5cc0-c297-4230-956c-ba8ebb00ce2d/items?path=%2F&versionDescriptor%5BversionOptions%5D=0&versionDescriptor%5BversionType%5D=0&versionDescriptor%5Bversion%5D=master&resolveLfs=true&%24format=zip&api-version=5.0&download=true"
#
#         ;;
#       user)
#           Print "starting of catalogue"
#           ## $1--- "user" $2--- "url"
#           nodejs_setup "users" "https://dev.azure.com/DevOps-Batches/ce99914a-0f7d-4c46-9ccc-e4d025115ea9/_apis/git/repositories/e911c2cd-340f-4dc6-a688-5368e654397c/items?path=%2F&versionDescriptor%5BversionOptions%5D=0&versionDescriptor%5BversionType%5D=0&versionDescriptor%5Bversion%5D=master&resolveLfs=true&%24format=zip&api-version=5.0&download=true"
#         ;;
       *)

         echo "Invalid Input, Following inputs are only accepted"
         ##### $0 is other than the current shell script file ######
         echo "Usage: $0 front|catalogue|cart|mongod|user|redis|mysql|rabbitmq|shipping|payment"
         exit 2
         ;;

esac

