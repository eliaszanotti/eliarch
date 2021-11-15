#!/bin/bash

# source functions.sh

# titre "elas"


# function ok {
#     echo -e """elias
#     Elais le sang \t
#     ok ok 
    
#     """
# }

# ok

echo $PWD

echo $USER

touch pkglist.txt
pacman -Qqen > pkglist.txt

pacman 