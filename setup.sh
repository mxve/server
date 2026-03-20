#!/bin/bash

apt-get update
apt-get upgrade -y
apt-get install -y gnupg build-essential sudo htop nload screen nano debian-goodies unzip zip curl git fail2ban rsync cifs-utils age zsh zsh-autosuggestions

mkdir /etc/zsh
curl -fsSL https://raw.githubusercontent.com/mxve/server/main/.zshrc > /etc/zsh/zshrc

curl -fsSL https://raw.githubusercontent.com/mxve/server/main/sshd_config > /etc/ssh/sshd_config
curl -fsSL https://raw.githubusercontent.com/mxve/server/main/issue.net > /etc/issue.net
systemctl restart sshd

echo "" > /etc/motd

CUR_TIMEZONE=$(cat /etc/timezone)
if [ "$CUR_TIMEZONE" != "Europe/Berlin" ]; then
    echo "Europe/Berlin" > /etc/timezone
    unlink /etc/localtime
    dpkg-reconfigure -f noninteractive tzdata
fi

if [ ! -f ~/.ssh/id_ed25519 ]; then
    ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519 -q -N ""
fi

chsh -s /bin/zsh

echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPC3xKgDpl5+3wEpqCGoJssyZHB9VI9/nqJNQhm9MVMd" >> /root/.ssh/authorized_keys
