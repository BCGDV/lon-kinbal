# Deploy infrastructure
cd ./infrastructure
tput setaf 4; echo "Provisioning EKS cluster"
terraform init
terraform apply -auto-approve
aws eks update-kubeconfig --name microenterprise-dev

# Configure helm access with RBAC
tput setaf 4; echo "Configuring Helm"
cd ../support
kubectl apply -f helm-rbac.yaml
sleep 5
helm init --service-account tiller
sleep 10

# Deploy kube2iam chart
tput setaf 4; echo "Deploying kube2iam chart"
helm install --set rbac.create=true --set host.iptables=true --set host.interface=eni+ --set=extraArgs.auto-discover-base-arn= stable/kube2iam
sleep 5

# Deploy API Gateway Ingress Controller Chart
cd ./AmazonAPIGWHelmChart
tput setaf 4; echo "Deploying API Gateway Ingress Controller Chart"
helm install --debug ./amazon-apigateway-ingress-controller --set image.repository="karthikk296d/aws-apigw-ingress-controller"
sleep 5

# Deploy Fargate namespace
tput setaf 4; echo "Deploying Fargate namespace"
kubectl apply -f ../fargate-namespace.yaml
sleep 5

# Deploy microservices
cd ../../microservices
tput setaf 4; echo "Deploying Microservices"
cd service-1/kubernetes-config/
kubectl apply -f ./deployment.yaml && kubectl apply -f ./service.yaml && kubectl apply -f ./api_ingress.yaml
sleep 5
cd ../service-2/kubernetes-config/
sleep 5
kubectl apply -f ./deployment.yaml && kubectl apply -f ./service.yaml && kubectl apply -f ./api_ingress.yaml
sleep 5
cd ../service-3/kubernetes-config/
kubectl apply -f ./deployment.yaml && kubectl apply -f ./service.yaml && kubectl apply -f ./api_ingress.yaml

Deploy dashboard
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/download/v0.3.7/components.yaml
kubectl get deployment metrics-server -n kube-system
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.5/aio/deploy/recommended.yaml
kubectl apply -f ./support/eks-admin-service-account.yaml
kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep eks-admin | awk '{print $1}')
tput setaf 4; echo "Please open" 'http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/#!/login'
kubectl proxy

kubectl describe ingress -A