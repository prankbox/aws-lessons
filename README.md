# aws-lessons

Create AWS infra as well as wordpress site.

1. Don't forget your AWS credentials are used. I recommend aws-vault.
2. Place your ssh key to variable.tf.

Now you are good to go.

```
terraform init
terraform validate
terraform plan
terraform apply
```

The output will give you the dns name of your wordpress site.
