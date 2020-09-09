#!/bin/bash

case $1 in
    forntend)
            echo "installing the webserver"
            echo "completed the webserver"
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
            echo " servers : $0 forntend|catalogue|cart"
            ;;
esac
