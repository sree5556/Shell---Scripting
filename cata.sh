#!/bin/bash

user_id=$(id -u)
case $user_id in
     0)
       echo "user has root access"
       ;;
     *)
       echo "user is restricted"
       exit 1
       ;;

esac

status_check()
{
      case $? in
            0)
              echo "************your allowed********************"
              ;;
            *)
              echo "************your not authorized*************"
              exit 2
              ;;

      esac
}

Print()
{
   echo "*******************$1********************"
}

#### This service is written in NodeJS, Hence need to install NodeJS in the system
Print "Installing the nodejs"
yum install nodejs make gcc-c++ -y
status_check


#######So to run the User service we choose to run as a normal user and that user name
Print " Adding the user named roboshop "
useradd roboshop
status_check


####### So let's switch to the roboshop user and run the following commands.
Print "switching from root user to roboshop"
cd /home/roboshop
status_check

Print "Downloading the schema"
curl -s -L -o /tmp/catalogue.zip "https://dev.azure.com/DevOps-Batches/ce99914a-0f7d-4c46-9ccc-e4d025115ea9/_apis/git/repositories/558568c8-174a-4076-af6c-51bf129e93bb/items?path=%2F&versionDescriptor%5BversionOptions%5D=0&versionDescriptor%5BversionType%5D=0&versionDescriptor%5Bversion%5D=master&resolveLfs=true&%24format=zip&api-version=5.0&download=true"
mkdir catalogue
cd catalogue
unzip -o /tmp/catalogue.zip
status_check
Print "Downloading the npm"
npm install
status_check

cd
mv /home/roboshop/catalogue/systemd.service /etc/systemd/system/catalogue.service
systemctl daemon-reload
systemctl start catalogue
systemctl enable catalogue
status_check