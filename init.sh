#!/bin/bash

sed -i "s/#Port 22/Port 20234/g" /etc/ssh/sshd_config
systemctl restart sshd
echo "Adjusted SSH port to 20234"

echo "Generate RSA ssh keypair only for internal ansible connections"
ssh-keygen -t rsa -q -f /home/ec2-user/.ssh/id_rsa -N ""

echo "Change required permissions"
chmod 0600 /home/ec2-user/.ssh/id_rsa*

echo "Add key to have authorized access"
cat /home/ec2-user/.ssh/id_rsa.pub >> /home/ec2-user/.ssh/authorized_keys

echo "Install Ansible with amazon-extras"
amazon-linux-extras install ansible2 -y

echo "Install EPEL repository for amazon linux"
amazon-linux-extras install epel -y

echo "Update YUM package repositories"
yum update -y

echo "[local]" > /etc/ansible/hosts
echo "localhost ansible_ssh_private_key_file=/home/ec2-user/.ssh/id_rsa ansible_user=ec2-user ansible_port=20234" >> /etc/ansible/hosts
echo "Adjusted Ansible hosts"
