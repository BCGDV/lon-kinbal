## How to deploy
1. Open `/lib/AmazonAPIGWHelmChart/amazon-apigateway-ingress-controller/templates/statefulset.yaml`
2. Rename the `spec.template.metadata.annotations.iam.amazonaws.com/role` to `<CLUSTER-NAME>-kube2iam-ingress-role`
3. Deploy by running `/bin/plugins/API-Gateway-Ingress-Controller/deploy.sh`