echo "Configuring Helm ALB Chart"
helm repo add incubator http://storage.googleapis.com/kubernetes-charts-incubator
sleep 5
echo "Installing ALB Chart into EKS cluster"
helm install ingress incubator/aws-alb-ingress-controller --set autoDiscoverAwsRegion=true --set autoDiscoverAwsVpcID=true --set clusterName=my-cluster