
rm /etc/ansible/hosts /home/centos/varnish/varnish-ip /home/centos/varnish/magento-ip script.sh
touch /home/centos/varnish-ip
touch /home/centos/magento-ip

touch /etc/ansible/hosts
echo $(aws ec2 describe-instances --region eu-west-1 --query 'Reservations[*].Instances[*].[PublicIpAddress]' --filters \
"Name=instance-state-name,Values=running"  'Name=tag:Name,Values=VarnishProduction' --output text ) >> /home/centos/varnish/varnish-ip

echo $(aws ec2 describe-instances --region eu-west-1 --query 'Reservations[*].Instances[*].[PublicIpAddress]' --filters \
"Name=instance-state-name,Values=running"  'Name=tag:Name,Values=HelloWorld' --output text ) >> /home/centos/varnish/magento-ip
chmod 777 /home/centos/varnish/varnish-ip
chmod 777 /home/centos/varnish/magento-ip
cd varnish
export ANSIBLE_HOST_KEY_CHECKING=False
aws s3 cp s3://key-ilyass/magentokey_eu_west_1.pem key.pem
chmod 400 key.pem
sh /home/centos/varnish/hosts.sh
ansible app -m ping --private-key=key.pem >> output
ansible varnish -m ping --private-key=key.pem >> output
ansible-playbook playbook_varnish.yml --private-key=key.pem >> output
