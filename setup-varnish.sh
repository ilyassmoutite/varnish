rm /etc/ansible/hosts
touch /etc/ansible/hosts
cd /home/centos
pip install awscli
touch script.sh
echo "aws configure set aws_access_key_id AKIAIYJ2G527GS7UYHIQ" >> script.sh
echo "aws configure set aws_secret_access_key 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" >> script.sh
chmod 777 script.sh
sh script.sh
touch varnish-ip
touch magento-ip

echo $(aws ec2 describe-instances --region eu-west-1 --query 'Reservations[*].Instances[*].[PublicIpAddress]' --filters \
"Name=instance-state-name,Values=running"  'Name=tag:Name,Values=VarnishProduction' --output text ) >> varnish-ip

echo $(aws ec2 describe-instances --region eu-west-1 --query 'Reservations[*].Instances[*].[PublicIpAddress]' --filters \
"Name=instance-state-name,Values=running"  'Name=tag:Name,Values=HelloWorld' --output text ) >> magento-ip
chmod 777 varnish-ip
chmod 777 magento-ip
cd varnish
export ANSIBLE_HOST_KEY_CHECKING=False
aws s3 cp s3://key-ilyass/magentokey_eu_west_1.pem key.pem
chmod 400 key.pem
sh hosts.sh
ansible app -m ping --private-key=key.pem >> output
ansible varnish -m ping --private-key=key.pem >> output
ansible-playbook playbook_varnish.yml --private-key=key.pem >> output
