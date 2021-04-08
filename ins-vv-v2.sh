#!/bin/sh
echo '正在安装依赖'
if cat /etc/os-release | grep "centos" > /dev/null
    then
    yum install unzip wget -y > /dev/null
    yum update curl -y
else
    apt-get install unzip wget -y > /dev/null
    apt-get update curl -y
fi
timedatectl set-timezone Asia/Shanghai

api=$1
key=$2
nodeId=$3
license=$4
folder=$key-v2
if [[ "$6" -ne "" ]]
    then
    syncInterval=$6
else
    syncInterval=60
fi
#kill&remove old servers
kill -9 $(ps -ef | grep ${folder} | grep -v grep | grep -v bash | awk '{print $2}') 1 > /dev/null
kill -9 $(ps -ef | grep defunct | grep -v grep | awk '{print $2}') 1 > /dev/null
systemctl stop firewalld
systemctl disable firewalld
systemctl stop v2ray.service
systemctl disable v2ray.service
systemctl stop vvlink.service
systemctl disable vvlink.service
systemctl stop vvlink-v2.service
systemctl disable vvlink-v2.service
rm -f /etc/systemd/system/v2ray.service
rm -f /etc/systemd/system/vvlink.service
rm -f /etc/systemd/system/vvlink-v2.service
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
echo '证书部署成功'
wget https://github.com/tokumeikoi/aurora/releases/latest/download/aurora
wget https://github.com/v2fly/v2ray-core/releases/latest/download/v2ray-linux-64.zip

unzip v2ray-linux-64.zip
chmod 755 *
#run server
nohup `pwd`/aurora -api=$api -token=$key -node=$nodeId -license=$license -syncInterval=$syncInterval > aurora.log 2>&1 &
echo '启动成功'
sleep 3
cat aurora.log
if ls | grep "service.log"
	then
	cat service.log
else
	echo '启动失败'
fi

#create auto start
cat << EOF >> /etc/systemd/system/vvlink-v2.service
[Unit]
Description=vvLink-v2 Service
After=network.target nss-lookup.target
Wants=network.target

[Service]
Type=simple
PIDFile=/run/vvlink-v2.pid
WorkingDirectory=`pwd`/
ExecStart=`pwd`/aurora -api=$api -token=$key -node=$nodeId -license=$license -syncInterval=$syncInterval > aurora.log 2>&1 &
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

systemctl enable vvlink-v2.service
systemctl daemon-reload
systemctl start vvlink-v2.service
echo '部署完成'
sleep 3
systemctl status vvlink-v2.service
