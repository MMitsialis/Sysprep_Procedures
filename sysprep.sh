#! /usr/bin/bash

# Stop logging services.
echo " ====== Stoppping Logging ======= "
systemctl stop rsyslog.service
service  auditd  stop

#Clean yum, remove Katello, detach from Satellite
echo " ====== Cleaning yum and Subscription Manager  ======= "
p=$(sudo rpm -qa | grep -i katello) && sudo rpm -e ${p}
sudo /usr/bin/yum clean all
sudo subscription-manager clean all



# Force the logs to rotate & remove old logs we don’t need.
echo " ====== Cleaning logs   ======= "
logrotate -f /etc/logrotate.conf
# rm -f /var/log/*-????????
rm --one-file-system --force -v -r  /var/log/*-*
rm --one-file-system --force -v /var/log/dnf.*
rm --one-file-system --force -v -r -d /var/log/vmware-*
rm --one-file-system --force -v /var/log/dmesg.old
rm --one-file-system --force -r -v /var/log/sudo.log
rm --one-file-system --force -r -v /var/log/anaconda
rm --one-file-system --force -r -v /var/log/xymon/*
rm --one-file-system --force -r -v /var/log/VRTSpbx/*
rm --one-file-system --force -r -v /var/log/sa/*
rm --one-file-system --force -r -v /var/log/rhsm/*
rm --one-file-system --force -r -v /var/log/audit/audit.log.*



# Truncate the audit logs (and other logs we want to keep placeholders for)
cat /dev/null > /var/log/audit/audit.log
cat /dev/null > /var/log/wtmp
cat /dev/null > /var/log/lastlog
cat /dev/null > /var/log/grubby

# Remove the udev persistent device rules.
echo " ====== Cleaning UDEV rules    ======= "
rm --force -v  /etc/udev/rules.d/70*

# Remove the traces of the template MAC address and UUIDs.
echo " ====== Cleaning network-scripts and NIC Scripts ======= "
sudo sed -i '/^(HWADDR|UUID)=/d' /etc/sysconfig/network-scripts/ifcfg-*
rm  -i /etc/sysconfig/network-scripts/ifcfg-en*
rm  -i /etc/sysconfig/network-scripts/ifcfg-et*

ip --brief addr
ip --brief link show

for i in $( ip --brief show |cut -f 1 -d ' ' ) ; do ip link set dev down ; done

ip --brief addr
ip --brief link show

echo -e " =====    Remove all NIc configuration ===== "

nmtui


# Clean /tmp
echo " ====== Cleaning '/tmp' ======= "

/bin/rm --one-file-system -r  -d --force -v /tmp/*
/bin/rm --one-file-system -r  -d --force -v /var/tmp/*

# Remove SSH Keys
echo " ====== Cleaning SSH Host Keys  ======= "
rm --force -v /etc/ssh/*key*

# Clean the root users home folder and history
echo " ====== Cleaning root user home directory  ======= "
unset HISTFILE
rm --force -v /root/.bash_history
rm -d --force -v /root/*

rm --force -v /root/.ssh/known_hosts
rm --force -v /root/.ssh/authorized_keys


# Clean svc_ansible directory
echo " ====== Cleaning svc_snible user home directory  ======= "
rm -dr --force -v /home/svc_ansible/*
rm -dr --force -v /home/svc_ansible/.bash_history
rm --force -v /home/svc_ansible/.ssh/known_hosts


# PowerOff
echo -e " =======   All Done ===== "

echo -e " ----- Please remove the ifcfg-en* and ifcfg-eth* files form /etc/sysconfig/network-scripts/ ---"
echo -e " ----- Check and remove incomplete edits using vim. e.g.: '.ifcfg-en*' or '.ifcfg-en*.swp'  "
echo -e " You may now remove this sysprep.sh file"
echo -e " "
echo -e " ***Note that if you power on again after this step, start at Step 1 again….*** "
