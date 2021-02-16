echo "Configuring Helm ALB Chart"
helm repo add eks https://aws.github.io/eks-charts
sleep 5
echo "Installing ALB Chart into EKS cluster"
helm install ingress incubator/aws-alb-ingress-controller --set autoDiscoverAwsRegion=true --set autoDiscoverAwsVpcID=true --set clusterName=my-cluster