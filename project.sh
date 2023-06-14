cd eks_infra
terraform init
terraform apply -auto-approve

if [ $? -ne 0 ]
then
  echo "Failed to build the infrastructure!"
else
  echo "Infrastructure has built successfully"
fi

cd ..


if [ -f eks_infra/cluster_output.txt ];
then
  bastion_public_ip=$(awk -F: '{if($1=="bastion_public_ip") {print $2;exit}}' eks_infra/cluster_output.txt)
	cluster_name=$(awk -F: '{if($1=="cluster_name") {print $2;exit}}' eks_infra/cluster_output.txt)
else
  echo "cluster_output file does not exist"
fi


cat > jenkins_deployment/inventory <<-EOF
[bastion]
$bastion_public_ip
EOF

sleep 10

echo "Starting jenkins deployment"

ansible-playbook jenkins_deployment/playbook.yml -e "cluster_name=${cluster_name}" --ask-vault-pass
