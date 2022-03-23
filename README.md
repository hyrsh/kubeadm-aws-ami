# kubeadm installer with ansible

This will install kubeadm on a single node with docker as container runtime engine.

I wanted to give CRI-O a shot, but AWS and their AMI Linux do not support the current "container-selinux" package (which is required and I could not manage to install the CentOS repositories without some hacky tricks (it is possible but dirty)).

## How to install

Spawn a fresh AWS Linux (AMI) VM (aka EC2 instance) and set a security group to allow port 20234 and 22 on incoming TCP connections.

To avoid SSH crawler/bots we change our SSH port to 20234 (port 22 is just for our initial connection).

Step-by-step:
- ssh into your ec2 instance (from your local machine or whatever)
- sudo -i
- yum install git -y
- mkdir git-repos && cd git-repos
- git clone https://github.com/hyrsh/kubeadm-aws-ami.git && cd kubeadm-aws-ami
- ./01\_install.sh

## How to check

After installation you can check if everything is working with:
- kubectl get nodes (your node should become ready within ~5min)

You can now use your single-node cluster of Kubernetes.

You can also use docker on your machine.

## Please note

The fact that we change our ssh port to 20234 means that you CANNOT ssh to your EC2 instance on port 22 anymore; use port 20234.

Since this is meant to be a disposable development environment, we do not have a high-available setup and I did not implement any Kubernetes security. You can join more worker nodes if you really want to do this, but then you may ask yourself "why don't I use EKS instead". If you want to add K8S security, you must do it yourself.

tl;dr: It is NOT HA or secure but it is a fully functional Kubernetes cluster.
