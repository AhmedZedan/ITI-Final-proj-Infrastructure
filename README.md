# ITI-Final-proj-Infrastructure

This repo contain the infrastructure as code of a private Elastic Kubernetes Service (EKS) and all its dependencies on AWS using Terraform and the jenkins deployment files and we will deploy it using our own helm chart benefits and we will automate this deployment and all it needs using Ansible.

## let's go and see how can we run our work 
the first thing we need to build our infrastructure of our kubernetes cluster and the first thing we need to say is that we use the remote backend for terraform to store its state files on s3 bucket and with that we need to have a lock to deny more than one person to run their code in the same time so we need first create s3 bucket and dynamodb table and replace your values in this block in **remote-backend.tf** file.
```
terraform {
  backend "s3" {
    bucket         = <your bucket name>
    dynamodb_table = <your table name>
    key            = <your key name that you nees>
    region         = <your region>
    encrypt        = true
  }
}
```

After that we can run our infrastructure code without any problem, First we need to go to our code directory **eks_infra** and run our code with this lines

``` sh
$ cd eks_infra
$ terraform init
$ terraform apply
```

### Now after our code ran successfully we have our infrastructure that we need to deploy our application and we wil go through deploy our jekins.
We created bastion server with infrastructure and put it in public subnet so we can access our private cluser through it, so we need to do some things to be able to run our ansible code on it

* get your bastion's public ip address and put it in inventory file in **jenkins_deployment** directory
```
[bastion]
<your bastion's public ip>
```
* update inventory file and private key file (that will be used to access bastion server) path to yours in **ansible.cfg** file.
```
[defaults]
inventory = <inventory path>
private_key_file = <private key path>
remote_user = ubuntu
host_key_checking = false

[privilege_escalation]
become = true
```
* update aws_access_key_id and aws_secret_access_key in variables in **jenkins_deployment/roles/bastion_config/vars/main.yml** so you can configure aws with your account credentials
you can create yours i advice you using 'Ansible Vault' feature using this command

``` sh
$ ansible-vault encrypt_string 'aws_access_key_id' --name 'my_access_key'
$ ansible-vault encrypt_string 'aws_secret_access_key' --name 'my_access_key'
```
> **Note**
> It will make you create password for your vault you need to remember or save it, becasue it will ask you about it when you run the ansible command 

Now we can run our ansible code on our bastion server by this command

``` sh
$ ansible-playbook jenkins_deployment/playbook.yml -e "cluster_name=${cluster_name}" --ask-vault-pass
```
## What does the ansible code do?
*There is two roles in our ansible code:*
### 1- bastion_config
In this role we prepare our bastion server with the tools that we need to our work, and this is what it did
* Install AWS CLI
* Install kubectl
* Install Helm 
* AWS configuration (with our account)
* update Kubeconfig (with our cluster)

### 2-jenkins_deployment
In this role we deploy jenkins and its slave on our cluster using our bastion server.
* Copy our jenkins deployment helm chart
* Deploy jenkins and jenkins slave using helm
### what this helm chart did
* create namespace called jenkins
* create Persistent Volume to save our work
* Persistent Volume Claim to claim our pv in jenkins pod
* Deploy jenkins and its service
* Deploy jenkins slave and its service

After our ansible code done we can check what it did with this command
``` sh
$ kubectl get all -n jenkins
```

* when you see jenkins-service you will find its type is **LoadBalancer** and have an **EXTERNAL IP** you will find it as a url
  - something like this ```ae5429bea1f44900ce551770-63270.us-east-1.elb.amazonaws.com```
* you can access your jenkins server with this url and the **port 8080**
  - ```ae5429bea1f44900ce551770-63270.us-east-1.elb.amazonaws.com:8080```

* when you put this in your browser congratulation you are now on your jenkins interface and you can do your pipeline with the configuration you want.
