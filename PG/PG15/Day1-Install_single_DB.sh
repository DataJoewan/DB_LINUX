#!/bin/bash
# https://github.com/joe-wan-cn/IT-infra/blob/main/Vagrant/Day1-create_single_boxes.md 
# simple script for vagrant to call this script to setup the PG15 single DB  <<< applicable for vagrant environment only
# https://doc.castsoftware.com/display/STORAGE/PostgreSQL+10+or+above+deployment+on+Linux 
# Put the commands inside here
# run with root only 

#update the timezone 
#timedatectl set-timezone Asia/Shanghai	
cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime


# update the passwd for root
echo redhat | passwd root --stdin


# Replce the default centos  (optional 1)
sed -e 's|^mirrorlist=|#mirrorlist=|g' \
      -e 's|^#baseurl=http://mirror.centos.org/$contentdir|baseurl=https://mirrors.tuna.tsinghua.edu.cn/centos|g' \
      -i.bak \
      /etc/yum.repos.d/CentOS-*.repo

# dnf makecache

# dnf upgrade

# Install the repository RPM:
dnf install -y https://download.postgresql.org/pub/repos/yum/reporpms/EL-8-x86_64/pgdg-redhat-repo-latest.noarch.rpm

# Disable the built-in PostgreSQL module:
dnf -qy module disable postgresql

# Install PostgreSQL:
dnf install -y postgresql15-server

# Change the location for postgres
mkdir /home/postgres
chmod 700 /home/postgres
chown postgres:postgres /home/postgres
usermod postgres -d /home/postgres

# Place the data into special folder but not the default one 
mkdir -p /pgsql/15/{data,dump,dba,backup}
chown -R postgres:postgres /pgsql
chmod -R 700 /pgsql 
echo "export PATH=/usr/pgsql-15/bin:$PATH">> /etc/profile
 
echo "export PGHOME=/pgsql/15" >> /home/postgres/.bash_profile
echo "export PGDATA=/pgsql/15/data " >> /home/postgres/.bash_profile
echo "export PGDUMP=/pgsql/15/dump  " >> /home/postgres/.bash_profile
echo "export PGBACKUP=/pgsql/15/backup " >> /home/postgres/.bash_profile


sed -e 's|Environment=PGDATA=/var/lib/pgsql/15/data/|Environment=PGDATA=/pgsql/15/data/|g' -i.bak /usr/lib/systemd/system/postgresql-15.service


# initialize the database and enable automatic start:
# add the customize encoding for db

#must be run with root meanwhile ensure **/pgsql/15/data/** the is empty 

PGSETUP_INITDB_OPTIONS="-E UTF-8  --no-locale" /usr/pgsql-15/bin/postgresql-15-setup initdb
# or as a workaround with 
# export PGSETUP_INITDB_OPTIONS="-E 'UTF-8' --no-locale"
# /usr/pgsql-<name>/bin/postgresql-<name>-setup initdb

#sed -e 's|#unix_socket_directories|unix_socket_directories|g' -i.bak /pgsql/15/data/postgresql.conf

systemctl enable postgresql-15
systemctl start postgresql-15



