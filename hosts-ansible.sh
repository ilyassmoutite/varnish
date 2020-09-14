echo "[ANSIBLE]" >> /etc/ansible/hosts
for line in $(cat /home/centos/varnish/ansible-ip); do echo "$line ansible_ssh_user=centos ansible_ssh_pass=centos">> /etc/ansible/hosts ; done
