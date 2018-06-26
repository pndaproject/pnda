#!/bin/bash

sudo rm /etc/sysconfig/network-scripts/ifcfg-ens*
sudo sed -i 's/GRUB_CMDLINE_LINUX=\"\(.*\)\"/GRUB_CMDLINE_LINUX=\"\1 net.ifnames=0 biosdevname=0\"/' /etc/default/grub
sudo grub2-mkconfig -o /boot/grub2/grub.cfg
sudo sed -i 's/ens[0-9]/eth0/' /etc/udev/rules.d/70-persistent-net.rules