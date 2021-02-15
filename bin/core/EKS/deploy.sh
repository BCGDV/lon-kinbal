# Deploy infrastructure
cd ../../../src/infrastructure
echo "Provisioning EKS cluster"
terraform init
terraform apply -auto-approve