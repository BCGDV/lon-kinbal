# Deploy Fargate namespace
cd ../../../lib
echo "Deploying Fargate namespace"
kubectl apply -f ../fargate-namespace.yaml
sleep 5