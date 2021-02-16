# Deploy infrastructure
cd $(cd $(dirname "$1");pwd)/$(basename "$1")/src/infrastructure
echo "Provisioning EKS cluster"
echo terraform init
echo terraform apply -auto-approve