# kubeadm installer with ansible

This will install kubeadm on a single node with docker as container runtime engine.

I wanted to give CRI-O a shot, but AWS and their AMI Linux do not support the current "container-selinux" package (which is required).

## How to use

Spawn a fresh AWS Linux VM (aka EC2 instance) and set a security group to allow port 20234 and 22 on incoming TCP connections.

To avoid SSH crawler/bots we change our SSH port to 20234 (port 22 is just for initial connections).

Step-by-step:
- ssh into your ec2 instance (from your local machine or whatever)
- sudo -i
- yum install git -y
- mkdir git-repos
- cd git-repos
- git clone https://github.com/hyrsh/kubeadm-aws-ami.git
- cd kubeadm-aws-ami
- ./init.sh
- ansible-playbook sec-hardening.yml
- ansible-playbook install-kubeadm.yml

