echo "Using Prod configuration and deploying to Prod environment"
mv terraform.tfstate terraform.tfstate.dev
mv _vars.tf _vars.tf.dev

mv terraform.tfstate.prod terraform.tfstate
mv _vars.tf.prod _vars.tf

terraform apply

# Revert current state back to dev
echo "Reverting to previous state"
mv terraform.tfstate terraform.tfstate.prod
mv _vars.tf _vars.tf.prod

mv terraform.tfstate.dev terraform.tfstate
mv _vars.tf.dev _vars.tf

echo "Deployment Complete"