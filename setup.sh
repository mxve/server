#!/bin/bash

SSH_PUBKEY="ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPC3xKgDpl5+3wEpqCGoJssyZHB9VI9/nqJNQhm9MVMd"
AGE_PUBKEY="age1newh0hf8y9jhwkc2e0w30053zhy8u97vl0ly3y6jy5ktgtzfrawqjw0655"

# ---------------------------------------------------- #
# apt deez

apt-get update
apt-get upgrade -y
apt-get install -y gnupg build-essential sudo htop nload screen nano debian-goodies unzip zip curl git fail2ban rsync cifs-utils age zsh zsh-autosuggestions

# ---------------------------------------------------- #
# sshd hardening and whimsyfication

curl -fsSL https://raw.githubusercontent.com/mxve/server/main/sshd_config > /etc/ssh/sshd_config

list=$(curl -fsSL https://raw.githubusercontent.com/mxve/server/main/issue.net/list.txt)
mkdir -p /opt/issue.net
echo "$list" | while IFS= read -r issue; do
  [ -z "$issue" ] && continue
  echo "downloading $issue..."
  curl -fsSL "https://raw.githubusercontent.com/mxve/server/main/issue.net/$issue" -o "/opt/issue.net/$issue"
done
curl -fsSL https://raw.githubusercontent.com/mxve/server/main/issue.net/rotate.sh > /opt/issue.net/rotate.sh
chmod +x /opt/issue.net/rotate.sh
echo "bash /opt/issue.net/rotate.sh" >> /etc/ssh/sshrc
echo "" > /etc/motd

systemctl restart sshd

# ---------------------------------------------------- #
# timezone

timedatectl set-timezone "Europe/Berlin"

# ---------------------------------------------------- #
# generate ssh key

if [ ! -f ~/.ssh/id_ed25519 ]; then
    ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519 -q -N ""
fi

grep -qxF "$SSH_PUBKEY" /root/.ssh/authorized_keys 2>/dev/null || echo "$SSH_PUBKEY" >> /root/.ssh/authorized_keys

# ---------------------------------------------------- #
# setup new age identity

if [ ! -d ~/.age ]; then
    mkdir -p ~/.age
fi

if [ ! -f ~/.age/id ]; then
    age-keygen -o ~/.age/id
fi

if [ ! -f ~/.age/id.pub ]; then
    age-keygen -y -o ~/.age/id.pub ~/.age/id
fi

if [ ! -f ~/.age/trusted ]; then
    cp ~/.age/id.pub ~/.age/trusted
fi

grep -qxF "$AGE_PUBKEY" ~/.age/trusted 2>/dev/null || echo "$AGE_PUBKEY" >> ~/.age/trusted

# ---------------------------------------------------- #
# setup zsh and switch shell

curl -fsSL https://raw.githubusercontent.com/mxve/server/main/.zshrc > /etc/zsh/zshrc
chsh -s /bin/zsh
zsh && exit
