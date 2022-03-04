#! /usr/bin/bash

clear
cd /boot/

TODAY=$( date --iso-8601=date )
TARGET_DIR="/boot/$TODAY/"
# Create destination folder if not present
if [ ! -d "$TARGET_DIR" ] ;
    then
        mkdir -p "$TARGET_DIR"   ;
fi

for i in initramfs-*.img  ; do
    cp  ${i} ${TARGET_DIR}
    # echo "${i%.*}"
    # echo ${i} | cut -f 1 -d '.'
    IMAGE_FILE=$( echo ${i} | rev | cut -f 2- -d '.' | rev )
    echo "Image File= ${IMAGE_FILE}"
    # IMAGE_KERNEL=$( echo ${IMAGE_FILE} | rev | cut -f 2- -d '-' | rev )
    IMAGE_KERNEL=$( echo $IMAGE_FILE | sed 's/initramfs-//'  )
    echo "Image Kernel = ${IMAGE_KERNEL}"
    dracut -v -f ${IMAGE_FILE} ${IMAGE_KERNEL}
    lsinitrd  ${IMAGE_FILE}  | grep ld.so.conf.d | grep kernel

done;

grep initrd /boot/loader/entries/*

grub2-mkconfig -o /boot/grub2/grub.cfg


