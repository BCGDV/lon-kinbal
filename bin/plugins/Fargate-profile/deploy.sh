# Deploy Fargate namespace
echo "Deploying Fargate namespace"
kubectl apply -f $(cd $(dirname "$1");pwd)/$(basename "$1")/bin/plugins/Fargate-profile/fargate-namespace.yaml
sleep 5