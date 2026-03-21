#!/bin/bash

# ---------------------------------------------------- #

apt-get update
apt-get upgrade -y
apt-get install -y gnupg build-essential sudo htop nload screen nano debian-goodies unzip zip curl git fail2ban rsync cifs-utils age zsh zsh-autosuggestions

# ---------------------------------------------------- #

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

timedatectl set-timezone "Europe/Berlin"

# ---------------------------------------------------- #

if [ ! -f ~/.ssh/id_ed25519 ]; then
    ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519 -q -N ""
fi


echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPC3xKgDpl5+3wEpqCGoJssyZHB9VI9/nqJNQhm9MVMd" >> /root/.ssh/authorized_keys

# ---------------------------------------------------- #

curl -fsSL https://raw.githubusercontent.com/mxve/server/main/.zshrc > /etc/zsh/zshrc
chsh -s /bin/zsh
zsh && exit
