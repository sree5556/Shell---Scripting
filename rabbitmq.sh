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
id=$roboshop
if [ $id -ne 0 ]; then
  useradd roboshop
else
  echo "already exits"
  status_check
fi

  Print "Erlang is a dependency which is needed for RabbitMQ"
  yum install https://packages.erlang-solutions.com/erlang/rpm/centos/7/x86_64/esl-erlang_22.2.1-1~centos~7_amd64.rpm -y
status_check
  Print " Setup YUM repositories for RabbitMQ "
  curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | sudo bash
status_check
  Print "Install the RabbitMQ"
  yum install rabbitmq-server -y
status_check
  Print"start the service"
  systemctl enable rabbitmq-server
  systemctl start rabbitmq-server
status_check
##RabbitMQ comes with a default username / password as guest/guest.
# But this user cannot be used to connect. Hence we need to create one user for the application.
  Print "Create application user"
  rabbitmqctl add_user roboshop roboshop123
  rabbitmqctl set_user_tags roboshop administrator
  rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"
status_check