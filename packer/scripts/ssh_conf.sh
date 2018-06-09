#!/bin/sh
adduser cloud-user
passwd -d cloud-user
echo cloud-user ALL=NOPASSWD: ALL >> /etc/sudoers