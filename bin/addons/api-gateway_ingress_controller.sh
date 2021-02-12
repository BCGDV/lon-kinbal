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