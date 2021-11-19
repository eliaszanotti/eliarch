#!/bin/bash
source functions.sh
clear

function fuseau_system {
    titre "Fuseau horraire"
    ln -sf /usr/share/zoneinfo/Europe/Paris /etc/localtime
    hwclock --systohc
    nano /etc/locale.gen
    locale-gen
    rm -f /etc/locale.conf
    touch /etc/locale.conf
    echo "LANG=fr_FR.UTF-8" >> /etc/locale.conf
    echo "Contenu de locale.conf :"
    cat /etc/locale.conf
    rm -f /etc/vconsole.conf
    touch /etc/vconsole.conf
    echo "KEYMAP=fr-latin9" >> /etc/vconsole.conf
    echo "Contenu de vconsole.conf :"
    cat /etc/vconsole.conf
}

function hostname_systeme {
    titre "Hostname du systeme"
    nano /etc/hostname
}

function hosts_systeme {
    titre "Hosts du systeme"
    touch /etc/hosts
    echo -e "127.0.0.1       localhost" >> /etc/hosts
    echo -e "::1             localhost" >> /etc/hosts
    nano /etc/hosts
}

function passwd_root {
    titre "Mot de passe root du systeme"
    passwd
}

function grub_efi_install {
    titre "Installation de Grub efi"
    pacman -S grub efibootmgr
    echo "Installer grub ATTENTION!"
    continuer
    grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=arch_grub --recheck
    grub-mkconfig -o /boot/grub/grub.cfg
}

function sudo_user {
    titre "Creation d'un utilisateur sudo"
    pacman -Syy sudo
    read -p "Nom de l'utilisateur : " user
    useradd -k /etc/skel -G wheel -m $user
    passwd $user 
    echo "Ajout de l'utilisateur dans le groupe wheel"
    nano /etc/sudoers
    cd /home/$user
}

function activate_networkmanager {
    titre "Activation de networkmanager"
    systemctl enable --now NetworkManager
}

function main {
    break_loop=0
    while [[ $break_loop == 0 ]]
        do titre "Menu principal pour l'installation du systeme"
        echo """
        1) Fuseau horraire
        2) Hostname du systeme
        3) Hosts du systeme
        4) Mot de passe root du systeme
        5) Installation de Grub efi
        6) Creation d'un utilisateur sudo
        7) Activation de networkmanager
        q) Exit
        """
        read -p "Entrez une selection : " choice
        case $choice in 
            q) exit;;
            1) fuseau_system;sleep 3;;
            2) hostname_systeme;sleep 3;;
            3) hosts_systeme;sleep 3;; 
            4) passwd_root;sleep 3;; 
            5) grub_efi_install;sleep 3;;
            6) sudo_user;sleep 3;;
            7) activate_networkmanager;sleep 3;;
            *) echo "Choix non valide veuillez recommencer :";sleep 1;;
        esac 
    done
}

main