## How to deploy
1. Open `/lib/AmazonAPIGWHelmChart/amazon-apigateway-ingress-controller/templates/statefulset.yaml`
2. Rename the `spec.template.metadata.annotations.iam.amazonaws.com/role` to `<CLUSTER-NAME>-kube2iam-ingress-role`
3. Deploy by running `/bin/plugins/API-Gateway-Ingress-Controller/deploy.sh`

## Architecture
![Kinbal%20973f0a3ede1d4f78918c0c478b33951d/Kinbal_(1).png](https://d2908q01vomqb2.cloudfront.net/fe2ef495a1152561572949784c16bf23abb28057/2020/02/20/api_ingress_controller_overview.png "Architecture")

## Explanation
- The API Gateway Ingress Controller watches for Ingress events from the API server. When it finds Ingress resources that satisfy its requirements, it begins the creation of AWS resources.
- API Gateway API is created, and the specified API Gateway stages outlined in Ingress annotations are created.
- A Private Network Load Balancer is created for the Ingress resource, and Listeners are created for every port specified in paths configuration.
- For the API Gateway to communicate to the Private Network Load Balancer, a Private API Gateway VPC Link is created.
- A TargetGroup is created for the reverse proxies specified in the Ingress resource.
- The API Gateway Ingress Controller deploys NGINX as the reverse proxy, and the reverse proxy Rules are created for each path specified in the Ingress resource. This ensures that traffic to a specific path is routed to the correct pod.