#!/bin/bash

source functions.sh

clear

function activate_networkmanager {
    titre "Activation de networkmanager"
    systemctl enable --now NetworkManager
}

function install_applications {
    titre "Installation des paquets"
    echo "xorg, plasma, sddm, spectacle, print-manager, kontrast, kcolorchooser, kate, elisa, dolphin, dolphin-plugins, ark, firefox, gparted, terminator, vlc, mixxx, inkscape, vscode, gwenview"
    # continuer
    pacman -Syy xorg plasma sddm spectacle print-manager kontrast kcolorchooser kate elisa dolphin dolphin-plugins ark firefox gparted terminator vlc mixxx inkscape vscode gwenview    

}

function sudo_user {
    titre "Creation d'un utilisateur sudo"
    pacman -Syy sudo
    read -p "Nom de l'utilisateur : " user
    useradd -k /etc/skel -G wheel -m $user
    passwd $user 
    echo "Ajout de l'utilisateur dans le groupe wheel"
    continue
    nano /etc/sudoers
    cd /home/$user
    echo "Affichage des dossiers dans le dossier utilisateur :"
    ls -l
}

function install_yay {
    titre "Installation de Yay"
    pacman -Syy git fakeroot binutils make gcc
    echo "Installaton dans /opt"
    cd /opt 
    git clone https://aur.archlinux.org/yay-git.git
    read -p "Nom de l'utitilisateur a utiliser pour installer yay : " user 
    chown -R $user:wheel ./yay-git
    cd yay-git
    echo "Executer 'makepkg -si' en utilisateur :"
    su $user
    echo "Syncronisation des paquets et test de yay"
    continuer
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
    read -p "Nom de l'utitilisateur : " user
    cd /home/$user/
    rm -rf eliarch
    git clone https://github.com/eliaszanotti/eliarch
    cp -r /home/$user/eliarch/files/* /home/$user/.config/
}

function config_apache {
    titre "Configuration et installation de LAMP (YAY requis)"
    pacman -Syy apache php php-apache
    yay -Syy mysql git
    read -p "Nom de l'utitilisateur : " user
    cd /home/$user/
    git clone https://github.com/eliaszanotti/eliarch
    cp -r /home/$user/eliarch/php.ini /etc/php/php.ini
    cp -r /home/$user/eliarch/httpd.conf /etc/httpd/conf/httpd.conf
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
        echo "1) Activation de networkmanager"
        echo "2) Installation des paquets"
        echo "3) Creation d'un utilisateur sudo"
        echo "4) Installation de Yay"
        echo "5) Installation de zsh"
        echo "6) Configuration des applications"
        echo "7) Configuration et installation de LAMP (YAY requis)"
        
        read -p "Entrez une selection : " choice

        case $choice in 
            1) activate_networkmanager;sleep 3;;
            2) install_applications;sleep 3;;
            3) sudo_user;sleep 3;; 
            4) install_yay;sleep 3;; 
            5) install_zsh;sleep 3;;
            6) config_files;sleep 3;;
            7) config_apache;sleep 3;;
            *) echo "Choix non valide veuillez recommencer :";sleep 1;;
        esac     
    done
}

main