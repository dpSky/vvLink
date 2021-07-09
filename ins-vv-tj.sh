#!/bin/sh
echo '正在安装依赖'
if cat /etc/os-release | grep "centos" > /dev/null
    then
    yum update > /dev/null
    yum install unzip wget curl -y > /dev/null
    yum update curl -y
else
    apt update > /dev/null
    apt-get install unzip wget curl -y > /dev/null
    apt-get update curl -y
fi
timedatectl set-timezone Asia/Shanghai

api=$1
key=$2
nodeId=$3
license=$4
folder=$key-tj
if [[ "$5" -ne "" ]]
    then
    syncInterval=$5
else
    syncInterval=60
fi
#kill process and delete dir
kill -9 $(ps -ef | grep ${folder} | grep -v grep | grep -v bash | awk '{print $2}') 1 > /dev/null
kill -9 $(ps -ef | grep defunct | grep -v grep | awk '{print $2}') 1 > /dev/null
systemctl stop firewalld
systemctl disable firewalld
systemctl stop trojan-go.service
systemctl disable trojan-go.service
systemctl stop vvlink-tj.service
systemctl disable vvlink-tj.service
rm -f /etc/systemd/system/trojan-go.service
rm -f /etc/systemd/system/vvlink-tj.service
rm -rf $key
rm -rf $folder
rm -rf $license
echo '旧服务已移除'
sleep 3

#create dir, init files
mkdir $folder
cd $folder
#create ssl ceart
wget https://dpsky.cc/vvlink-a07wm6/vvlink.key
wget https://dpsky.cc/vvlink-a07wm6/vvlink.crt
mkdir /root/.cert
cp vvlink.crt /root/.cert/server.crt
cp vvlink.key /root/.cert/server.key
chmod 400 /root/.cert/server.*
wget https://github.com/tokumeikoi/tidalab-trojan/releases/latest/download/tidalab-trojan
wget https://github.com/p4gefau1t/trojan-go/releases/download/v0.10.4/trojan-go-linux-amd64.zip

unzip trojan-go-linux-amd64.zip
chmod 755 *

if ls /root/.cert | grep "key" > /dev/null
    then
    echo '证书存在'
else
    echo '请签发证书后在执行'
    exit
fi

#run server
nohup `pwd`/tidalab-trojan -api=$api -token=$key -node=$nodeId -license=$license -syncInterval=$syncInterval > tidalab.log 2>&1 &
echo '启动成功'
sleep 3
cat tidalab.log
if ls | grep "service.log"
	then
	cat service.log
else
	echo '启动失败'
fi

#create auto start
cat << EOF >> /etc/systemd/system/vvlink-tj.service
[Unit]
Description=vvLink-tj Service
After=network.target nss-lookup.target
Wants=network.target

[Service]
Type=simple
PIDFile=/run/vvlink-tj.pid
WorkingDirectory=`pwd`/
ExecStart=`pwd`/tidalab-trojan -api=$api -token=$key -node=$nodeId -license=$license -syncInterval=$syncInterval > tidalab.log 2>&1 &
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

systemctl enable vvlink-tj.service
systemctl daemon-reload
systemctl start vvlink-tj.service
echo '部署完成'
sleep 3
systemctl status vvlink-tj.service
