# Deploy Fargate namespace
echo "Deploying Fargate namespace"
kubectl apply -f ./fargate-namespace.yaml
sleep 5