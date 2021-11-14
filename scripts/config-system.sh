#!/bin/bash
source functions.sh
clear

function activate_networkmanager {
    titre "Activation de networkmanager"
    systemctl enable --now NetworkManager
}

function install_applications {
    titre "Installation des paquets"
    nano packages.txt
    continuer
    pacman -Syy - < packages.txt
}

function install_yay {
    titre "Installation de Yay"
    pacman -Syy git fakeroot binutils make gcc
    echo "Installaton dans /opt"
    cd /opt 
    git clone https://aur.archlinux.org/yay-git.git
    chown -R $USER:wheel ./yay-git
    cd yay-git
    echo "Executer 'makepkg -si' en utilisateur :"
    su $USER
    echo "Syncronisation des paquets et test de yay"
    yay -Syy
}

function install_zsh {
    titre "Installation de zsh"
    pacman -Syy zsh
    zsh --version
    echo "Changement de shell par defaut pour zsh"
    chsh -s /bin/zsh
}

function config_files {
    titre "Configuration des applications"
    pacman -Syy git
    cd /home/$USER/
    rm -rf eliarch
    git clone https://github.com/eliaszanotti/eliarch
    cp -r /home/$USER/eliarch/files/* /home/$USER/.config/
}

function config_apache {
    titre "Configuration et installation de LAMP (YAY requis)"
    pacman -Syy apache php php-apache
    yay -Syy mysql git
    cd /home/$USER/
    git clone https://github.com/eliaszanotti/eliarch
    cp -r /home/$USER/eliarch/php.ini /etc/php/php.ini
    cp -r /home/$USER/eliarch/httpd.conf /etc/httpd/conf/httpd.conf
    systemctl enable --now httpd
    systemctl enable --now mysqld
    echo "Configuration de mysql"
    continuer 
    mysql_secure_installation
}

function main {
    break_loop=0
    while [[ $break_loop == 0 ]]
        do titre "Menu principal pour la configuration du systeme"
        echo """
        1) Activation de networkmanager
        2) Installation des paquets
        3) Installation de Yay
        4) Installation de zsh
        5) Configuration des applications
        6) Configuration et installation de LAMP (YAY requis)
        q) Exit
        """
        read -p "Entrez une selection : " choice
        case $choice in 
            q) exit;;
            1) activate_networkmanager;sleep 3;;
            2) install_applications;sleep 3;;
            3) install_yay;sleep 3;; 
            4) install_zsh;sleep 3;;
            5) config_files;sleep 3;;
            6) config_apache;sleep 3;;
            *) echo "Choix non valide veuillez recommencer :";sleep 1;;
        esac     
    done
}

main