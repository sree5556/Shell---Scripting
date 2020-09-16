#!/bin/bash
#user status
user_id=$(id -u)
case $user_id in
0)
  echo "u are the root user"
  ;;
*)
  echo " u don't have access "
  exit 1
  ;;
esac

## if conditon
# if [$id ne -0]; then
#   echo "u don't have access"
#   else
#     echo" u have access"
# fi

#status of previous command weather its success or not
#if sucess ---> proccde else ----> failure

status_check() {
  case $? in
  0)
    echo "sucess"
    ;;
  *)
    echo "failure"
    exit 2
    ;;
  esac
}

# if condition
#status_check (){
#  if [$? -eq 0]; then
#    echo "sucess"
#    else
#      echo "failure"
#  fi
#}
Print() {
  echo "*******************$1************************"
}

## main program of shipping
## Shipping service is written in Java, Hence we need to install Java.
## Install Maven, This will install Java too
Print "install maven"
yum install maven -y
status_check
##we always run the applications as a normal user.
Print "application user"
create_user() {
  id roboshop
  if [ $? -ne 0 ]; then
    useradd roboshop
  else
    echo "already exits"
    status_check
  fi
}

#####his service is responsible for payments in RoboShop e-commerce app.
#
#This service is written on Python 3, So need it to run this app.
#
#CentOS 7 comes with Python 2 by default. So we need Python 3 to be installed.
#
#Install Python 3

Print "Install Python"
yum install python36 gcc python3-devel -y
status_check

Print "Create a user for running the application"
create_user
status_check

Print "Download the repo."
cd /home/roboshop
curl -L -s -o /tmp/payment.zip "https://dev.azure.com/DevOps-Batches/ce99914a-0f7d-4c46-9ccc-e4d025115ea9/_apis/git/repositories/02fde8af-1af6-44f3-8bc7-a47c74e95311/items?path=%2F&versionDescriptor%5BversionOptions%5D=0&versionDescriptor%5BversionType%5D=0&versionDescriptor%5Bversion%5D=master&resolveLfs=true&%24format=zip&api-version=5.0&download=true"
status_check
mkdir payment
cd payment
Print "extracting the zip"
unzip -o /tmp/payment.zip
status_check

Print "Install the dependencies"
cd /home/roboshop/payment
pip3 install -r requirements.txt
status_check

####Above command may fail with permission denied, So run as root user
#
#Update the roboshop user and group id in payment.ini file.

###uid = 1001
#  gid = 1001 ----> by default when user was created id will be 1001 and 1001 user id and group id will same

Print "Setup the service"
#mv /home/roboshop/payment/systemd.service /etc/systemd/system/payment.service
 if [ -e /etc/systemd/system/payment.service ]; then
   mv /home/roboshop/payment/systemd.service /etc/systemd/system/payment.service
   #Environment=CART_HOST=CARTHOST
   #Environment=USER_HOST=USERHOST
   #Environment=AMQP_HOST=AMQPHOST
   #Environment=AMQP_USER=roboshop
   #Environment=AMQP_PASS=roboshop123
   sed -i -e "s/CARTHOST/cart.helodevops.tech/" /etc/systemd/system/payment.service
   sed -i -e "s/USERHOST/user.helodevops.tech/" /etc/systemd/system/payment.service
   sed -i -e "s/AMQPHOST/rabbitmq.helodevops.tech/" /etc/systemd/system/payment.service
   #sed -i -e "s/CARTHOST/cart.${DNS_DOMAIN_NAME}/" -e "s/USERHOST/user.${DNS_DOMAIN_NAME}/" -e "s/AMQPHOST/rabbitmq.${DNS_DOMAIN_NAME}/" /etc/systemd/system/payment.service
   status_check
 fi
systemctl daemon-reload
systemctl enable payment
Print "start the service"
systemctl start payment
status_check

