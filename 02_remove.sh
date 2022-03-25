#!/bin/bash

ansible-playbook remove-kubeadm.yml

echo "free" > ./group_vars/init_lock
echo "Unlocked instance."
