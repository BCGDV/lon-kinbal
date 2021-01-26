# Deploy infrastructure
cd ./infrastructure
terraform init
terraform apply
aws eks update-kubeconfig --name microenterprise

# Deploy dashboard
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/download/v0.3.7/components.yaml
sleep 5s
kubectl get deployment metrics-server -n kube-system
sleep 5s
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.5/aio/deploy/recommended.yaml
sleep 5s
kubectl apply -f ./eks-admin-service-account.yaml
sleep 5s
kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep eks-admin | awk '{print $1}')
kubectl proxy
sleep 5s
open 'http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/#!/login'

# Deploy microservices
cd ..
cd microservices/service-1
kubectl apply -f ./deployment.yaml
cd ../service-2
kubectl apply -f ./deployment.yaml
cd ../service-3
kubectl apply -f ./deployment.yaml

kubectl describe ingress -A