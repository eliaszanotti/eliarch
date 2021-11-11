#!/bin/bash

function titre {
    clear
    echo -e "\e[0;101m\e[1m - $1 \e[0m\n"
}

function continuer {
    read -p "Entrer pour continuer"
}
