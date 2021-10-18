> Requires Terraform, Ansible and az cli on your local system. Also you need to have an active azure subscription to setup the vm into. 

## Setup

1) Run `az login`
2) Run `init.sh`
3) Copy  `variables.tfvars.example` to variables.tfvars and adjust
4) Run `terraforn apply terraform`
5) Copy `ansible/hosts.template` to `hosts.ini` and adjust
6) Run ansible-playbook  -i ansible/hosts.ini ansible/main.yml 
