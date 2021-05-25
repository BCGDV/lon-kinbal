# Deploy infrastructure
cd $(cd $(dirname "$1");pwd)/$(basename "$1")/src/infrastructure
echo "Provisioning EKS cluster"

read -r -d '' terraform_init_config <<EOF
-backend-config='region=${REGION}'
-backend-config='bucket=${CLUSTER_NAME}-tfstate'
-backend-config='key=${CLUSTER_NAME}-tfstate/${ENVIRONMENT}'
EOF

export TF_CLI_ARGS_init=$terraform_init_config
export TF_VAR_region=$REGION
export TF_VAR_cluster_name=$CLUSTER_NAME

terraform init
terraform apply -auto-approve

aws eks update-kubeconfig --name "${CLUSTER_NAME}-${ENVIRONMENT}"
