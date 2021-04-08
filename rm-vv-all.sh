#!/bin/bash

echo '开始移除旧服务'

key=$1
v2=$key-v2
tj=$key-tj

#kill&remove old servers
echo '关闭进程'
kill -9 $(ps -ef | grep ${v2} | grep -v grep | grep -v bash | awk '{print $1}') 1 > /dev/null
kill -9 $(ps -ef | grep defunct | grep -v grep | awk '{print $1}') 1 > /dev/null
kill -9 $(ps -ef | grep ${tj} | grep -v grep | grep -v bash | awk '{print $1}') 1 > /dev/null
kill -9 $(ps -ef | grep defunct | grep -v grep | awk '{print $1}') 1 > /dev/null
echo '移除服务'
systemctl stop trojan-go.service
systemctl disable trojan-go.service
systemctl stop vvlink-tj.service
systemctl disable vvlink-tj.service
systemctl stop v2ray.service
systemctl disable v2ray.service
systemctl stop vvlink.service
systemctl disable vvlink.service
systemctl stop vvlink-v2.service
systemctl disable vvlink-v2.service
rm -f /etc/systemd/system/v2ray.service
rm -f /etc/systemd/system/vvlink.service
rm -f /etc/systemd/system/vvlink-v2.service
rm -f /etc/systemd/system/trojan-go.service
rm -f /etc/systemd/system/vvlink-tj.service
echo '删除程序'
rm -rf $v2
rm -rf $tj

echo '旧服务已移除'
sleep 3

#remove ssl ceart
rm -rf /root/.cert
echo '成功移除证书'
