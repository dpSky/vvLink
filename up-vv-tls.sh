#!/bin/bash
#Change SSL
cd /tmp
wget https://dpsky.cc/vvlink-a07wm6/vvlink.key
wget https://dpsky.cc/vvlink-a07wm6/vvlink.crt
rm -rf /root/.cert/server.*
cp vvlink.crt /root/.cert/server.crt
cp vvlink.key /root/.cert/server.key
chmod 400 /root/.cert/server.*
echo '部署完成'
sleep 3
reboot
