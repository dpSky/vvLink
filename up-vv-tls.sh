#!/bin/bash
#Change SSL
cd /tmp
wget https://dpsky.cc/vvlink-a07wm6/vvlink.key
wget https://dpsky.cc/vvlink-a07wm6/vvlink.crt
rm -rf /root/.cert/server.*
cp vvlink.crt /root/.cert/server.crt
cp vvlink.key /root/.cert/server.key
chmod 600 /root/.cert/server.*
echo '证书更新完成 等待重启'
sleep 3
reboot
