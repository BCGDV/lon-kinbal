# Deploy infrastructure
cd ../infrastructure
tput setaf 4; echo "Provisioning EKS cluster"
terraform init
terraform apply -auto-approve
aws eks update-kubeconfig --name microenterprise-dev