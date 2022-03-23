#!/bin/bash

ansible-playbook ./playbooks/remove-kubeadm.yml

echo "free" > ./group_vars/init_lock
echo "Unlocked instance."
