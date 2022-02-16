#!/bin/bash
source functions.sh
clear

function install_applications {
    titre "Installation des paquets"
    sudo nano ~/packages.sh
    continuer
    sudo pacman -Syy - < ~/packages.sh
}

function install_yay {
    titre "Installation de Yay (en utilisateur)"
    sudo pacman -Syy git fakeroot binutils make gcc
    echo "Installaton dans /opt"
    cd /opt 
    sudo git clone https://aur.archlinux.org/yay-git.git
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
    /usr/bin/mysql_install_db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
    mysql_secure_installation
    sudo systemctl enable --now httpd
    sudo systemctl enable --now mariadb
    cd ~
    sudo rm -rf build_eliarch
}

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
    cp -r ~/build_eliarch/eliarch/files/schema.kksrc ~/
    cd ~
    sudo rm -rf build_eliarch 
}

function main {
    break_loop=0
    while [[ $break_loop == 0 ]]
        do titre "Menu principal pour la configuration du systeme"
        echo """
        1) Installation des paquets (en utilisateur)
        2) Installation de Yay (en utilisateur)
        3) Installation de zsh (en utilisateur)
        4) Configuration et installation de LAMP (en utilisateur)
        5) Configuration des applications (en utilisateur)
        q) Exit
        """
        read -p "Entrez une selection : " choice
        case $choice in 
            q) exit;;
            1) install_applications;sleep 3;;
            2) install_yay;sleep 3;; 
            3) install_zsh;sleep 3;;
            4) config_apache;sleep 3;;
            5) config_files;sleep 3;;
            *) echo "Choix non valide veuillez recommencer :";sleep 1;;
        esac     
    done
}

main