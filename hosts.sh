echo "[varnish]" >> /etc/ansible/hosts
for line in $(cat text); do echo "$line ansible_ssh_user=centos ansible_ssh_pass=centos">> /etc/ansible/hosts ; done 

echo "[app]" >> /etc/ansible/hosts
for line in $(cat text); do echo "$line ansible_ssh_user=centos ansible_ssh_pass=centos">> /etc/ansible/hosts ; done
