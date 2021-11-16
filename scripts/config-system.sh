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
    titre "Installation de Yay (en utilisateur)"
    sudo pacman -Syy git fakeroot binutils make gcc
    echo "Installaton dans /opt"
    cd /opt 
    git clone https://aur.archlinux.org/yay-git.git
    sudo chown -R $USER:wheel /opt/yay-git
    cd yay-git
    echo "Execution 'makepkg -si' en utilisateur"
    makepkg -si
    echo "Syncronisation des paquets et test de yay"
    yay -Syy
}

function install_zsh {
    titre "Installation de zsh (en utilisateur)"
    sudo pacman -Syy zsh
    zsh --version
    echo "Changement de shell par defaut pour zsh"
    chsh -s /bin/zsh
}

function config_apache {
    titre "Configuration et installation de LAMP (en utilisateur)"
    sudo pacman -Syy apache php php-apache git mariadb
    cd ~
    sudo rm -rf build_eliarch
    mkdir -p build_eliarch
    cd ~/build_eliarch
    git clone https://github.com/eliaszanotti/eliarch
    sudo cp -r ~/build_eliarch/eliarch/files/php.ini /etc/php/php.ini
    sudo cp -r ~/build_eliarch/eliarch/files/httpd.conf /etc/httpd/conf/httpd.conf
    echo "Configuration de mysql"
    mysql_secure_installation
    sudo systemctl enable --now httpd
    sudo systemctl enable --now mariadb
}

# function rename_xdg {
#     titre "Renommage des dossiers (en utilisateur)"
#     sudo xdg-user-dirs-update --force --set
# }

function config_files {
    titre "Configuration des applications (en utilisateur)"
    sudo pacman -Syy git
    cd ~
    sudo rm -rf build_eliarch
    mkdir -p build_eliarch
    cd ~/build_eliarch
    git clone https://github.com/eliaszanotti/eliarch
    cp -r ~/build_eliarch/eliarch/config/* ~/.config/
    cp -r ~/build_eliarch/eliarch/files/.zshrc ~/
}

function main {
    break_loop=0
    while [[ $break_loop == 0 ]]
        do titre "Menu principal pour la configuration du systeme"
        echo """
        1) Activation de networkmanager
        2) Installation des paquets
        3) Installation de Yay (en utilisateur)
        4) Installation de zsh (en utilisateur)
        5) Configuration et installation de LAMP (en utilisateur)
        6) Configuration des applications (en utilisateur)
        q) Exit
        """
        read -p "Entrez une selection : " choice
        case $choice in 
            q) exit;;
            1) activate_networkmanager;sleep 3;;
            2) install_applications;sleep 3;;
            3) install_yay;sleep 3;; 
            4) install_zsh;sleep 3;;
            5) config_apache;sleep 3;;
            6) config_files;sleep 3;;
            *) echo "Choix non valide veuillez recommencer :";sleep 1;;
        esac     
    done
}

main