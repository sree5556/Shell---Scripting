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

## to install mysql first we will check sql is there are not in list

yum list installed | grep mysql-community-server
if [ $? -ne 0 ]; then
  Print "my sql is not there"
  Print "download the sql"
  curl -L -o /tmp/mysql-5.7.28-1.el7.x86_64.rpm-bundle.tar https://downloads.mysql.com/archives/get/p/23/file/mysql-5.7.28-1.el7.x86_64.rpm-bundle.tar
  status_check
fi
cd /tmp
Print "extracting the tar"
tar -xf mysql-5.7.28-1.el7.x86_64.rpm-bundle.tar
status_check

Print "Install MySQL"
yum remove mariadb-libs -y
status_check
yum install mysql-community-client-5.7.28-1.el7.x86_64.rpm \
  mysql-community-common-5.7.28-1.el7.x86_64.rpm \
  mysql-community-libs-5.7.28-1.el7.x86_64.rpm \
  mysql-community-server-5.7.28-1.el7.x86_64.rpm -y
status_check

Print "Start MySQL"
systemctl enable mysqld
systemctl start mysqld
status_check

Print "Now a default root password will be generated and given in the log file."

   #grep temp /var/log/mysqld.log
   #Now a default root password will be generated and given in the log file.
   # grep temp /var/log/mysqld.log
   #Next, We need to change the default root password in order to start using the database service.
   # mysql_secure_installation
   #You can check the new password working or not using the following command.
   # mysql -u root -p
   #Run the following SQL commands to remove the password policy.
   #> uninstall plugin validate_password;
   #> ALTER USER 'root'@'localhost' IDENTIFIED BY 'password';

echo 'show databases;' | mysql -uroot -ppassword
if [ $? -ne 0 ]; then
  echo -e "ALTER USER 'root'@'localhost' IDENTIFIED BY 'Password@1';\nuninstall plugin validate_password;\nALTER USER 'root'@'localhost' IDENTIFIED BY 'password';" >/tmp/reset-password.sql
  ROOT_PASSWORD=$(grep 'A temporary password' /var/log/mysqld.log | awk '{print $NF}')
  Print "Reset MySQL Password"
  mysql -uroot -p"${ROOT_PASSWORD}" </tmp/reset-password.sql
  Status_Check
fi
Print "Download Schema"
curl -s -L -o /tmp/mysql.zip "https://dev.azure.com/DevOps-Batches/ce99914a-0f7d-4c46-9ccc-e4d025115ea9/_apis/git/repositories/af9ec0c1-9056-4c0e-8ea3-76a83aa36324/items?path=%2F&versionDescriptor%5BversionOptions%5D=0&versionDescriptor%5BversionType%5D=0&versionDescriptor%5Bversion%5D=master&resolveLfs=true&%24format=zip&api-version=5.0&download=true"
Status_Check
Print "Extract Schema"
cd /tmp
unzip -o mysql.zip
Status_Check
Print "Load Schema"
mysql -u root -ppassword <shipping.sql
Status_Check
