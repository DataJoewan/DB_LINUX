


**Replace the default repository for centos8**
```
yum install -y https://mirrors.aliyun.com/epel/epel-release-latest-8.noarch.rpm

sed -e 's|^mirrorlist=|#mirrorlist=|g' \
      -e 's|^#baseurl=http://mirror.centos.org/$contentdir|baseurl=https://mirrors.tuna.tsinghua.edu.cn/centos|g' \
      -i.bak \
      /etc/yum.repos.d/CentOS-*.repo

sed -e 's|^#baseurl=https://download.example/pub|baseurl=https://mirrors.aliyun.com|' /etc/yum.repos.d/epel* -i.bak

sed -e 's|^metalink|#metalink|' /etc/yum.repos.d/epel*  -i.bak    
```


**Replace the default repository for Oracle linux8 **
```
```

**Replace the default repository for Rocky linux8 **
```
```
