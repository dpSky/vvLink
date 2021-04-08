#!/bin/bash

echo '开始移除旧服务'

folder=$1

#kill&remove old servers
kill -9 $(ps -ef | grep ${folder}-tj | grep -v grep | grep -v bash | awk '{print $1}') 1 > /dev/null
kill -9 $(ps -ef | grep defunct | grep -v grep | awk '{print $1}') 1 > /dev/null
systemctl stop trojan-go.service
systemctl disable trojan-go.service
systemctl stop vvlink-tj.service
systemctl disable vvlink-tj.service
rm -f /etc/systemd/system/trojan-go.service
rm -f /etc/systemd/system/vvlink-tj.service
rm -rf $folder-tj

echo '旧服务已移除'
sleep 3

#remove ssl ceart
rm -rf /root/.cert
echo '成功移除证书'
