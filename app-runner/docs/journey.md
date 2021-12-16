# Deployment
- [Region not supported](https://console.aws.amazon.com/apprunner/home?region=eu-central-1#). Let's go to Ireland!
- [Pricing](https://eu-west-1.console.aws.amazon.com/apprunner/home?region=eu-west-1#/welcome)
- [Interesting Features](https://aws.amazon.com/apprunner/features/)
    - Logging & Monitoring (Standard CloudWatch)
    - LB & Scaling
    - Cert Management

- [Same use case as every solution](https://eu-west-1.console.aws.amazon.com/apprunner/home?region=eu-west-1#/welcome)
- GitHub Access for Code needed
- Guide says you need [AdministratorAccess Policy](https://docs.aws.amazon.com/apprunner/latest/dg/setting-up.html)
- Other docs say you need [AWSAppRunnerFullAccess ](https://docs.aws.amazon.com/apprunner/latest/dg/security_iam_id-based-policy-examples.html)
which does not exist?
- Deployment took around 4-5 minutes.
Services can be seen [here](https://eu-west-1.console.aws.amazon.com/apprunner/home?region=eu-west-1#/services)

# Logging
- Cloudwatch [log groups](https://eu-west-1.console.aws.amazon.com/cloudwatch/home?region=eu-west-1#logsV2:log-groups): one for app logs, one for service/infra logs
    - [Can be exported using S3 and a specific task](https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/S3ExportTasks.html)

# TLS/Certs 
- Default a wildcard cert for \<region>.apprunner