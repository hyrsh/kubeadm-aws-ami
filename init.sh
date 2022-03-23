#!/bin/bash

sed -i "s/#Port 22/Port 20234/g" /etc/ssh/sshd_config
systemctl restart sshd

ssh-keygen -t rsa -q -f /home/ec2-user/.ssh/id_rsa -N ""

chmod 0600 /home/ec2-user/.ssh/id_rsa*

cat /home/ec2-user/.ssh/id_rsa.pub >> /home/ec2-user/.ssh/authorized_keys

amazon-linux-extras install ansible2 -y

amazon-linux-extras install epel -y

yum update -y

echo "[local]" > /etc/ansible/hosts
echo "localhost ansible_ssh_private_key_file=/home/ec2-user/.ssh/id_rsa ansible_user=ec2-user ansible_port=20234" >> /etc/ansible/hosts

echo -e "\e[36;1m"
echo -e "For your overview:"
echo -e "------------------"
echo -e "[+] Adjusted SSH port to 20234"
echo -e "[+] Generated RSA ssh keypair only for internal ansible connections"
echo -e "[+] Changed required permissions of ssh keys"
echo -e "[+] Added public key to have authorized access"
echo -e "[+] Installed Ansible with amazon-extras"
echo -e "[+] Installed EPEL repository for amazon linux"
echo -e "[+] Updated YUM package repositories"
echo -e "[+] Adjusted Ansible hosts"
echo -e "\e[0;0m"
