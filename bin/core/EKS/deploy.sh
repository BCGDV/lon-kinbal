# Deploy infrastructure
cd $(cd $(dirname "$1");pwd)/$(basename "$1")/src/infrastructure
echo "Provisioning EKS cluster"
terraform init
terraform apply -auto-approve