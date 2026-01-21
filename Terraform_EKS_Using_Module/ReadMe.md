terraform init 
terraform init -upgrade

terraform plan --var-file=dev.tfvars 

terraform apply --auto-approve --var-file=dev.tfvars

// terraform destroy

kubectl config get-contexts

aws eks update-kubeconfig --name=superstore-eks-cluster-dev --region=eu-west-2

