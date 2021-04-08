#!/bin/bash
#Change SSL
cd /tmp
wget https://dpsky.cc/vvlink-a07wm6/vvlink.key
wget https://dpsky.cc/vvlink-a07wm6/vvlink.crt
rm -rf /root/.cert/server.*
cp vvlink.crt /root/.cert/server.crt
cp vvlink.key /root/.cert/server.key
chmod 400 /root/.cert/server.*
sleep 3
systemctl restart vvlink-tj.service
sleep 3
systemctl restart vvlink-v2.service
echo '证书更新完成'
