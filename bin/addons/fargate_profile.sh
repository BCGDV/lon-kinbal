# Deploy Fargate namespace
cd ../support
tput setaf 4; echo "Deploying Fargate namespace"
kubectl apply -f ../fargate-namespace.yaml
sleep 5