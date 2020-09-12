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
    echo "your allowed"
    ;;
    *)
    echo "sorry your not allowed"
    ;;
   esac
 }
status_check

