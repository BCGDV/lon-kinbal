# Deploy infrastructure
cd ./infrastructure
terraform init
terraform apply -auto-approve
aws eks update-kubeconfig --name microenterprise-dev

# Attach policies to kub2iam-ingress-role - used by API Gateway Ingress Controller to create AWS resources
aws iam attach-role-policy --role-name kube2iam-ingress-role --policy-arn arn:aws:iam::aws:policy/AutoScalingFullAccess  
aws iam attach-role-policy --role-name kube2iam-ingress-role --policy-arn arn:aws:iam::aws:policy/AmazonAPIGatewayAdministrator
aws iam attach-role-policy --role-name kube2iam-ingress-role --policy-arn arn:aws:iam::aws:policy/AmazonVPCFullAccess 
aws iam attach-role-policy --role-name kube2iam-ingress-role --policy-arn arn:aws:iam::aws:policy/AWSCloudFormationFullAccess 
aws iam attach-role-policy --role-name kube2iam-ingress-role --policy-arn arn:aws:iam::aws:policy/ElasticLoadBalancingFullAccess

# Configure helm access with RBAC
cd ../support
kubectl apply -f helm-rbac.yaml
helm init --service-account tiller
sleep 5

# Deploy kube2iam chart
helm install --set rbac.create=true --set host.iptables=true --set host.interface=eni+ --set=extraArgs.auto-discover-base-arn= stable/kube2iam
sleep 5

# Deploy API Gateway Ingress Controller Chart
cd ./AmazonAPIGWHelmChart
helm install --debug ./amazon-apigateway-ingress-controller --set image.repository="karthikk296d/aws-apigw-ingress-controller"
sleep 5

# Deploy Fargate namespace
kubectl apply -f ./fargate-namespace.yaml

# Deploy microservices
cd ../../microservices
cd service-1/kubernetes-config/
kubectl apply -f ./deployment.yaml && kubectl apply -f ./service.yaml && kubectl apply -f ./api_ingress.yaml
cd ../service-2/kubernetes-config/
kubectl apply -f ./deployment.yaml && kubectl apply -f ./service.yaml && kubectl apply -f ./api_ingress.yaml
cd ../service-3/kubernetes-config/
kubectl apply -f ./deployment.yaml && kubectl apply -f ./service.yaml && kubectl apply -f ./api_ingress.yaml

# Create persistence layer
aws rds create-db-instance --db-name service1db --db-instance-identifier microenterprise-service-1 --db-instance-class db.t2.micro --engine postgres --allocated-storage 20 --storage-type gp2 --master-username microenterpriseadmin --master-user-password microenterpriseadminpassword --publicly-accessible
aws rds create-db-instance --db-name service2db --db-instance-identifier microenterprise-service-2 --db-instance-class db.t2.micro --engine postgres --allocated-storage 20 --storage-type gp2 --master-username microenterpriseadmin --master-user-password microenterpriseadminpassword --publicly-accessible
aws rds create-db-instance --db-name service3db --db-instance-identifier microenterprise-service-3 --db-instance-class db.t2.micro --engine postgres --allocated-storage 20 --storage-type gp2 --master-username microenterpriseadmin --master-user-password microenterpriseadminpassword --publicly-accessible

# Deploy dashboard
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/download/v0.3.7/components.yaml
kubectl get deployment metrics-server -n kube-system
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.5/aio/deploy/recommended.yaml
kubectl apply -f ./support/eks-admin-service-account.yaml
kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep eks-admin | awk '{print $1}')
kubectl proxy
tput setaf 4; echo "Please open" 'http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/#!/login'

kubectl describe ingress -A