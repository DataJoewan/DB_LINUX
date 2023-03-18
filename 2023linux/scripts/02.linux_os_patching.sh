#!/bin/bash
# Applicable for rhel/centos/oralinux7,8

# step1 , take the backup of current env

mkdir /var/tmp/serverpre-patching`date +%Y%m%d` -p 
cd /var/tmp/serverpre-patching`date +%Y%m%d` 

df -hTP > _disk_df
uptime | tee _uptime_before
cat /etc/fstab > _fstab
pvs > _pvs
vgs > _vgs
lvs > _lvs
ls -lhR /boot >_boot
lsblk > _lsblk
ps -efH > _ps_ef 
netstat -nr > _routing_ip
top -b1 -n1 >_top 
cat /etc/grub2.cfg >_grub
systemctl list-unit-files --type=service --state=enabled > _system_services 
yum check-update > _willupdate

# step2 , upgrade the kernel and packages
yum update -y 
