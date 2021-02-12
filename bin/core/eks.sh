# Deploy infrastructure
cd ../../src/infrastructure
tput setaf 4; echo "Provisioning EKS cluster"
terraform init
read -p "Enter Cluster Name: " clustername
terraform apply -var="cluster_name=$clustername" -auto-approve
aws eks update-kubeconfig --name $clustername