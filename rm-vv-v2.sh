#!/bin/bash

echo '开始移除旧服务'

key=$1
folder=$key-v2

#kill&remove old servers
kill -9 $(ps -ef | grep ${folder} | grep -v grep | grep -v bash | awk '{print $1}') 1 > /dev/null
kill -9 $(ps -ef | grep defunct | grep -v grep | awk '{print $1}') 1 > /dev/null
systemctl stop v2ray.service
systemctl disable v2ray.service
systemctl stop vvlink.service
systemctl disable vvlink.service
systemctl stop vvlink-v2.service
systemctl disable vvlink-v2.service
rm -f /etc/systemd/system/v2ray.service
rm -f /etc/systemd/system/vvlink.service
rm -f /etc/systemd/system/vvlink-v2.service
rm -rf $folder

echo '旧服务已移除'
sleep 3

#remove ssl ceart
rm -rf /root/.cert
echo '成功移除证书'
