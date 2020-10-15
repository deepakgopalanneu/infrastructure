# Build your AWS infrastructure with Terraform

### Install Terraform on Ubuntu
Run the following commands on your terminal
- TER_VER=`curl -s https://api.github.com/repos/hashicorp/terraform/releases/latest | grep tag_name | cut -d: -f2 | tr -d \"\,\v | awk '{$1=$1};1'`

- `wget https://releases.hashicorp.com/terraform/${TER_VER}/terraform_${TER_VER}_linux_amd64.zip`

- `unzip terraform_${VER}_linux_amd64.zip`

- `sudo mv terraform /usr/local/bin/`

- confirm installation : `terraform -v`

### Clone the Repo
 `git clone git@github.com:gopaland-fall2020/infrastructure.git`

#### Navigate to the cloned Repository and enter the following commands in the terminal

- Initialize terraform :
    `terraform init`
- Preview the resource creation plan :
    `terraform plan`
- Run terraform to create resources :
    `terraform apply`
- Destroy resources : 
    `terraform destroy`