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

# Custom Domain
- [Possible after starting the application](https://docs.aws.amazon.com/apprunner/latest/dg/manage-custom-domains.html)
- CNAME and certificate validation records are provided
- Traceroute shows routing via decix2.amazon.com

# Scalability

```bash
wrk -t24 -c500 -d3m https://spring.apprunner.prenoob.codes/persons
Running 3m test @ https://spring.apprunner.prenoob.codes/persons
  24 threads and 500 connections
  Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency   261.77ms  223.48ms   2.00s    83.64%
    Req/Sec    78.32     50.59   323.00     68.61%
  330398 requests in 3.00m, 282.77MB read
  Socket errors: connect 0, read 0, write 0, timeout 198
  Non-2xx or 3xx responses: 46
Requests/sec:   1834.66
Transfer/sec:      1.57MB
```

# VPC Magic and Connecting to other AWS services
- [No private VPCs possible](https://docs.aws.amazon.com/apprunner/latest/dg/security-data-protection-vpce.html)
