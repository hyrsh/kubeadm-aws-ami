#!/bin/bash

yum update -y

yum install ansible -y

echo "[local]" > /etc/ansible/hosts
echo "localhost ansible_ssh_private_key_file=/home/ec2-user/.ssh/id_rsa ansible_user=ec2-user" >> /etc/ansible/hosts
