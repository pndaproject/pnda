#!/bin/sh
mkdir /home/cloud-user/.ssh
cat /tmp/key_name.pem.pub >> /home/cloud-user/.ssh/authorized_keys
rm /tmp/key_name.pem.pub