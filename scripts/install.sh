#!/bin/bash

. functions.sh 

clear
loadkeys fr-pc

function wifi {
    titre "Wi-Fi"
    echo """
    [iwd]# device list
    [iwd]# station wlan0 scan
    [iwd]# station wlan0 get-networks
    [iwd]# station wlan0 connect network_name
    [iwd]# exit
    """
    iwctl
    ping google.com
}

function fuseau {
    titre "Fuseau horraire"
    timedatectl set-timezone Europe/Paris
    timedatectl set-ntp true
    timedatectl status
}

function part_disk {
    titre "Partition du disque avec cfdisk"
    echo -e """
    3 partitions :
    512M  \t Linux filesystem
    4096M \t Linux SWAP
    ALL   \t Linux filesystem
    """ 
    continuer
    cfdisk
    titre "Partition du disque avec cfdisk"
    lsblk
}

function format_part {
    titre "Formatage des partitions"
    read -p "Emplacement du Boot (/dev/sda1) : " boot
    mkfs.vfat -F32 $boot
    read -p "Emplacement du SWAP (/dev/sda2) : " swap
    mkswap $swap
    read -p "Emplacement de la Racine (/dev/sda3) : " root
    mkfs.ext4 $root
}

function mount_part {
    titre "Montage des partitions"
    read -p "Emplacement de la Racine (/dev/sda3) : " root
    mount $root /mnt
    read -p "Emplacement du Boot (/dev/sda1) : " boot
    mkdir -p /mnt/boot/efi
    mount -t vfat $boot /mnt/boot/efi
    read -p "Emplacement du SWAP (/dev/sda2) : " swap
    swapon $swap
}

function tri_reflector {
    titre "Tri des paquets avec Reflector"
    pacman -Syy
    reflector --verbose --country France -l 5 -p https --save /etc/pacman.d/mirrorlist
}

function install_pacstrap {
    titre "Installation de Linux ATTENTION !"
    echo """
    Sur /mnt :
    base linux linux-firmware nano networkmanager network-manager-applet
    """
    continuer
    pacstrap /mnt base linux linux-firmware nano networkmanager network-manager-applet
    genfstab -U /mnt >> /mnt/etc/fstab
    cat /mnt/etc/fstab
}

function chroot_system {
    titre "Pour continuer utilisez chroot-install"
    cp -r /root/chroot-install.sh /mnt/bin
    cp -r /root/config-system.sh /mnt/bin
    arch-chroot /mnt
}

function main {
    break_loop=0
    while [[ $break_loop == 0 ]]
        do titre "Menu principal pour l'installation du systeme"
        echo """
        1) Wi-Fi
        2) Fuseau horraire
        3) Partition du disque avec cfdisk
        4) Formatage des partitions
        5) Montage des partitions
        6) Tri des paquets avec Reflector
        7) Installation de Linux ATTENTION !
        8) Fin de l'installation, utilisez chroot-install
        q) Exit
        """
        
        read -p "Entrez une selection : " choice

        case $choice in 
            1) wifi;sleep 3;;
            2) fuseau;sleep 3;;
            3) part_disk;sleep 3;; 
            4) format_part;sleep 3;; 
            5) mount_part;sleep 3;;
            6) tri_reflector;sleep 3;;
            7) install_pacstrap;sleep 3;;
            8) chroot_system;sleep 3;;
            q) exit;
            *) echo "Choix non valide veuillez recommencer :";sleep 1;;
        esac 
        
    done
}

main