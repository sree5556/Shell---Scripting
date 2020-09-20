#!/bin/bash

user_id=$(id -u)
case $user_id in
         0)
           echo "your  allowed"
           ;;
         *)
           echo "your not authorized"
           exit 1
           ;;
esac

status_check()
{
  case $? in
         0)
           echo " *************your allowed***********"
         ;;
         *)
           echo "you are not allowed"
           exit 2
           ;;
  esac
}

Print()
{
  echo "***************************$1***************************"
}

         ##### moving to program of cart
         #####This service is responsible for Cart Service in RobotShop e-commerce portal.
         #####This service is written in NodeJS, Hence need to install NodeJS in the system.
         Print "Installing the node js"
         yum install nodejs make gcc-c++ -y
         status_check


         #######So to run the User service we choose to run as a normal user and that user name
         Print " Adding the user named roboshop "
         id roboshop
         if [ $? -ne 0 ]; then
           echo "user is not there so adding the user"
          useradd roboshop
          status_check
         fi

         ####### So let's switch to the roboshop user and run the following commands.
         Print "switching from root user to roboshop"
         cd /home/roboshop
         status_check

         Print "Downloading the schema"
         curl -s -L -o /tmp/cart.zip "https://dev.azure.com/DevOps-Batches/ce99914a-0f7d-4c46-9ccc-e4d025115ea9/_apis/git/repositories/ac4e5cc0-c297-4230-956c-ba8ebb00ce2d/items?path=%2F&versionDescriptor%5BversionOptions%5D=0&versionDescriptor%5BversionType%5D=0&versionDescriptor%5Bversion%5D=master&resolveLfs=true&%24format=zip&api-version=5.0&download=true"
         mkdir cart
         cd cart
         unzip -o /tmp/cart.zip
         status_check

         Print "Downloading the npm"
         npm --unsafe-perm install
         status_check
         chown roboshop:roboshop /home/roboshop -R
         status_check

         mv /home/roboshop/cart/systemd.service /etc/systemd/system/cart.service
#
#         Environment=REDIS_HOST=REDIS_ENDPOINT
#         Environment=CATALOGUE_HOST=CATALOGUE_ENDPOINT
         Print "Change the service files of cart to dns of catalogue and redis"
         if [ -e /etc/systemd/system/cart.service ]; then
           sed -i -e "s/REDIS_ENDPOINT/redis.helodevops.tech/" /etc/systemd/system/cart.service
          # sed -i -e  "s/CATALOGUE_ENDPOINT/catalogue.helodevops.tech/" /etc/systemd/system/cart.service
           status_check
         fi

         systemctl daemon-reload
         systemctl start cart
         systemctl enable cart
         status_check






