#!/bin/bash

systemctl stop docker

lvstatus=$(/sbin/lvdisplay | grep lv_data)


if [ $? -eq 0 ]; then
    cp /tmp/docker.service /usr/lib/systemd/system/docker.service
    #cp /tmp/docker.service.without_lv /usr/lib/systemd/system/docker.service
#else
#    cp /tmp/docker.service /usr/lib/systemd/system/docker.service
fi

vgstatus=$(/sbin/lvdisplay | grep vg_data)

if [ $? -eq 0 ]; then
    cp /tmp/docker.service_vg /usr/lib/systemd/system/docker.service
    #cp /tmp/docker.service.without_lv /usr/lib/systemd/system/docker.service
#else
#    cp /tmp/docker.service_vg /usr/lib/systemd/system/docker.service
fi

reststatus=$(/sbin/lvdisplay | grep _metadata)

if [ $? -ne 0 ]; then
    cp /tmp/docker.service.without_lv /usr/lib/systemd/system/docker.service
fi

cp /tmp/docker.socket /usr/lib/systemd/system/docker.socket

if [ -d /etc/systemd/system/docker.service.d/ ]; then
    mv /etc/systemd/system/docker.service.d/ /root
fi

systemctl daemon-reload

systemctl start docker

docker start cadvisor

