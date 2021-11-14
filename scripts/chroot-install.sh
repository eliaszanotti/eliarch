#!/bin/bash

source functions.sh

clear

function chroot_system {
    titre "Chroot du systeme et fuseau horraire"
    ln -sf /usr/share/zoneinfo/Europe/Paris /etc/localtime
    hwclock --systohc
    nano /etc/locale.gen
    continuer
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
    titre "Grub efi"
    pacman -S grub efibootmgr
    echo "Installer grub ATTENTION!"
    continuer
    grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=arch_grub --recheck
    grub-mkconfig -o /boot/grub/grub.cfg
}

function fin_install {
    titre "Merci d'avoir utilisé EliArch Installer"
    exit
}

function main {
    break_loop=0
    while [[ $break_loop == 0 ]]
        do titre "Menu principal pour l'installation du systeme"
        echo "1) Chroot du systeme et fuseau horraire"
        echo "2) Hostname du systeme"
        echo "3) Hosts du systeme"
        echo "4) Mot de passe root du systeme"
        echo "5) Grub efi"
        echo "6) Fin de l'installation"
        
        read -p "Entrez une selection : " choice

        case $choice in 
            1) chroot_system;sleep 3;;
            2) hostname_systeme;sleep 3;;
            3) hosts_systeme;sleep 3;; 
            4) passwd_root;sleep 3;; 
            5) grub_efi_install;sleep 3;;
            6) fin_install;sleep 3;;
            *) echo "Choix non valide veuillez recommencer :";sleep 1;;
        esac 
    done
}

main