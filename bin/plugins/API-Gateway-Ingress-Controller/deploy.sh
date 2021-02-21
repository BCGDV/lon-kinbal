# Configure helm access with RBAC
echo "Configuring Helm"
kubectl apply -f $(cd $(dirname "$1");pwd)/$(basename "$1")/bin/plugins/API-Gateway-Ingress-Controller/helm-rbac.yaml
sleep 5
helm init --service-account tiller
sleep 10

# Deploy kube2iam chart
echo "Deploying kube2iam chart"
helm install --set rbac.create=true --set host.iptables=true --set host.interface=eni+ --set=extraArgs.auto-discover-base-arn= stable/kube2iam
sleep 5

# Deploy API Gateway Ingress Controller Chart
echo "Deploying API Gateway Ingress Controller Chart"
helm install --debug $(cd $(dirname "$1");pwd)/$(basename "$1")/bin/plugins/API-Gateway-Ingress-Controller/AmazonAPIGWHelmChart/amazon-apigateway-ingress-controller --set image.repository="karthikk296d/aws-apigw-ingress-controller"
sleep 5