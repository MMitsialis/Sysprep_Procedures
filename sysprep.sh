#! /usr/bin/bash 

# Stop logging services.
systemctl stop rsyslog.service
service  auditd  stop 


# Force the logs to rotate & remove old logs we don’t need.
logrotate -f /etc/logrotate.conf
# rm -f /var/log/*-????????
rm --force -v -r -i /var/log/*-*
rm --force /var/log/dnf.log

rm -d -r --force /var/log/vmware-*
rm --force /var/log/dmesg.old
rm -r --force /var/log/sudo.log
rm -r --force /var/log/anaconda
rm -r --force /var/log/xymon/*
rm -r --force /var/log/VRTSpbx/*
rm -r --force /var/log/sa/*
rm -r --force /var/log/rhsm/*
rm -r --force /var/log/audit/audit.log.*



# Truncate the audit logs (and other logs we want to keep placeholders for)
cat /dev/null > /var/log/audit/audit.log
cat /dev/null > /var/log/wtmp
cat /dev/null > /var/log/lastlog
cat /dev/null > /var/log/grubby

# Remove the udev persistent device rules.
rm --force -v  /etc/udev/rules.d/70*

# Remove the traces of the template MAC address and UUIDs.
sudo sed -i '/^(HWADDR|UUID)=/d' /etc/sysconfig/network-scripts/ifcfg-*

# Clean /tmp

/bin/rm -r -d --force -v -i /tmp/*
/bin/rm -r -d --force -v -i /var/tmp/*

# Remove SSH Keys
rm --force -v -i  /etc/ssh/*key*

# Clean the root users home folder and history
unset HISTFILE
rm --force -v /root/.bash_history
rm -d --force -v /root/*

rm -r --force -v /root/.ssh/known_hosts
rm -r --force -v /root/.ssh/authorized_keys


# Clean svc_ansible directory
rm -dr --force -v /home/svc_ansible/*
rm -dr --force -v /home/svc_ansible/.bash_history


# PowerOff
echo -e " =======   All Done ===== "

echo -e " ----- Please remove the ifcfg-en* and ifcfg-eth* files form /etc/sysconfig/network-scripts/ ---"
echo -e " ----- Check and remove incomplete edits using vim. e.g.: '.ifcfg-en*' or '.ifcfg-en*.swp'  "
echo -e " You may now remove this sysprep.sh file"
echo -e " " 
echo -e " ***Note that if you power on again after this step, start at Step 1 again….*** "
