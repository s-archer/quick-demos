This deployment uses an IAM role attached to the BIG-IP which allows AS3 to query the AWS API to discover the NGINX instances automatically (service discovery).

To use this repo, clone to your local machine and then:

- terraform init
- terraform plan
- terraform apply
- ...
- use
- ...
- terraform destroy