#! /usr/bin/bash

clear


CURRENT_KERNEL=$(uname -r)
TODAY=$( date --iso-8601=date )
TARGET_DIR="/boot/$TODAY/rescue/"
# Create destination folder if not present
if [ ! -d "$TARGET_DIR" ] ;
    then
        mkdir -p "$TARGET_DIR"   ;
fi


# Backup the current rescue image

cp  /boot/initramfs-0-rescue-* ${TARGET_DIR}
cp  /boot/vmlinuz-0-rescue-* ${TARGET_DIR}

# Generate new Rescue image
/etc/kernel/postinst.d/51-dracut-rescue-postinst.sh $(uname -r) /boot/vmlinuz-$(uname -r)

# Checks
echo "====== running Kernel is :   ${CURRENT_KERNEL} ==== "

RESCUE_IMAGE=$(ls /boot/initramfs-0-rescue-* )

lsinitrd $RESCUE_IMAGE  | grep ld.so.conf.d | grep kernel

