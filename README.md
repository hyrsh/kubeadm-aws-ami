# kubeadm installer with ansible

This will install kubeadm on a single node with docker as container runtime engine.

I wanted to give CRI-O a shot, but AWS and their AMI Linux do not support the current "container-selinux" package (which is required and I could not manage to install the CentOS repositories without some hacky tricks (it is possible but dirty)).

## How to install

Spawn a fresh AWS Linux (AMI) VM (aka EC2 instance) and set a security group to allow port 20234 and 22 on incoming TCP connections.

To avoid SSH crawler/bots we change our SSH port to 20234 (port 22 is just for our initial connection).

You can change this port in group\_vars/all.yml

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

## Plugins

Ingress Controller:
- create the ingress and class with
-- kubectl apply -f plugins/ingress-controller

Ingress Generator:
- create a custom ingress object with
-- ./create-ing-object.sh mynamespace myurl k8s-service k8s-service-port

Kubernetes Dashboard (your URL is https://k8s-dashboard.aws.io, if you want to access it via Ingress):
- create the kubernetes dashboard
-- kubectl apply -f plugins/k8s-dashboard
-- kubectl apply -f plugins/metrics-server

Secret Generator:
- create a service account token as secret (important from v1.24+) with infinite validity (be aware of that; you can change it any time)
-- ./create-api-secret.sh mynamespace myserviceaccount

## How to reset

At any point in time you can reset your installation by running 02\_remove.sh

It does reset all saved docker images and all kubeadm installations.

It does not reset your fail2ban or SSH settings.

## Please note

The fact that we change our ssh port to 20234 means that you CANNOT ssh to your EC2 instance on port 22 anymore; use port 20234.

Since this is meant to be a disposable development environment, we do not have a high-available setup and I did not implement any Kubernetes security. You can join more worker nodes if you really want to do this, but then you may ask yourself "why don't I use EKS instead". If you want to add K8S security, you must do it yourself.

tl;dr: It is NOT HA or secure but it is a fully functional Kubernetes cluster.
