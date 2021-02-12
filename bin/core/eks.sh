# Deploy infrastructure
cd ../../src/infrastructure
tput setaf 4; echo "Provisioning EKS cluster"
terraform init
terraform apply -auto-approve