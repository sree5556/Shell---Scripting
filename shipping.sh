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
id roboshop
if [ $? -ne 0 ]; then
  useradd roboshop
else
  echo "already exits"
  status_check
fi
cd /home/roboshop
curl -s -L -o /tmp/shipping.zip "https://dev.azure.com/DevOps-Batches/ce99914a-0f7d-4c46-9ccc-e4d025115ea9/_apis/git/repositories/e13afea5-9e0d-4698-b2f9-ed853c78ccc7/items?path=%2F&versionDescriptor%5BversionOptions%5D=0&versionDescriptor%5BversionType%5D=0&versionDescriptor%5Bversion%5D=master&resolveLfs=true&%24format=zip&api-version=5.0&download=true"
status_check
mkdir shipping
cd shipping
Print "extracting the zip"
unzip -o /tmp/shipping.zip
status_check
Print"installing the dependencies"
mvn clean package
mv target/*dependencies.jar shipping.jar
status_check
## Copy the service file and start the service.
Print "copy the service file"
#mv /home/roboshop/shipping/systemd.service /etc/systemd/system/shipping.service
if [ -e /etc/systemd/system/shipping.service ]; then
   mv /home/roboshop/shipping/systemd.service /etc/systemd/system/shipping.service
      #Environment=CART_ENDPOINT=CARTENDPOINT:8000
      #Environment=DB_HOST=DBHOST
      sed -i -e "/s/CARTENDPOINT=cart.helodevops.tech:8000/"  /etc/systemd/system/shipping.service
      sed -i -e "/s/DBHOST=mysql.helodevops.tech/" /etc/systemd/system/shipping.service
  status_check
fi
Print "copied the file"

systemctl daemon-reload
systemctl enable shipping
Print "start the service"
systemctl start shipping
status_check
