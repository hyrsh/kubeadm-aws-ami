#!/bin/bash

if [ -f ./group_vars/init_lock ]; then
  state=$(cat ./group_vars/init_lock | head -1)
else
  echo -e "\e[34;1mInitial run. Creating lock.\e[0;0m"
  echo "locked" > ./group_vars/init_lock
fi

if [ "$state" == "locked" ]; then
  echo "Init locked. Skipping."
else
  echo "Running instance initiation."

  asshp=$(grep "ansible_ssh_port:" ./group_vars/all.yml | awk -F: '{print $2}' | sed "s/ //g")

  sed -i "s/#Port 22/Port $asshp/g" /etc/ssh/sshd_config
  systemctl restart sshd

  ssh-keygen -t rsa -q -f /home/ec2-user/.ssh/id_rsa -N ""

  chmod 0600 /home/ec2-user/.ssh/id_rsa*

  cat /home/ec2-user/.ssh/id_rsa.pub >> /home/ec2-user/.ssh/authorized_keys

  amazon-linux-extras install ansible2 -y

  #yum lock cooldown
  sleep 2

  amazon-linux-extras install epel -y

  #yum lock cooldown
  sleep 2

  yum update -y

  echo "[local]" > /etc/ansible/hosts
  echo "localhost ansible_ssh_private_key_file=/home/ec2-user/.ssh/id_rsa ansible_user=ec2-user ansible_port=$asshp" >> /etc/ansible/hosts
  
  ansible-playbook sec-hardening.yml

  echo -e "\e[36;1m"
  echo -e "For your overview:"
  echo -e "------------------"
  echo -e "[+] Adjusted SSH port to $asshp"
  echo -e "[+] Generated RSA ssh keypair only for internal ansible connections"
  echo -e "[+] Changed required permissions of ssh keys"
  echo -e "[+] Added public key to have authorized access"
  echo -e "[+] Installed Ansible with amazon-extras"
  echo -e "[+] Installed EPEL repository for amazon linux"
  echo -e "[+] Updated YUM package repositories"
  echo -e "[+] Adjusted Ansible hosts"
  echo -e "[+] Installed fail2ban (+crontab and attacker count)"
  echo -e "\e[0;0m"

  echo "locked" > ./group_vars/init_lock
  echo "group_vars/init_lock" > .gitignore
fi

ansible-playbook install-kubeadm.yml
