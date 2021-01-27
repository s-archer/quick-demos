To run, your AWS credentials need to be provided for teh AS3 declaration for autodiscovery.  The values can be populated from a separate creds.tfvars file, stored
outside of your repo folder. 

Use the following flag when applying config to use the values from your creds.tfvars file.

terraform apply -var-file=../creds/creds.tfvars   

The creds.tfvars file must contain two variables defined like this (but not commented out):

aws_access_key = "blahBlahBlah"
aws_secret_key = "blahBlahBlahblahBlahBlah"