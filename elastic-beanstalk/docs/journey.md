# Deployment
- Old but gold? [BMW case study](https://aws.amazon.com/solutions/case-studies/bmw/) from 2015
- [Getting Started Page](https://eu-central-1.console.aws.amazon.com/elasticbeanstalk/home?region=eu-central-1#/gettingStarted) not loading?
- Policy [AdministratorAccess-AWSElasticBeanstalk](https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/AWSHowTo.iam.managed-policies.html) needed
- Amazon Elastic Beanstalk npm cant find package.json. [SO to the rescue](https://stackoverflow.com/questions/35387822/amazon-elastic-beanstalk-npm-cant-find-package-json)
- Can run Docker, but not prebuild images
- Download of environment logs
- [Procfile needed](https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/nodejs-configuration-procfile.html)
- EC2 instance can be found via name, same for Elastic IP addresses and Security Groups
    - Network interfaces can be found via EIP
- Deletion is clunky

# Logging & Monitoring
- Download via Web UI per environment
- Can be configured to stream logs to cloudwatch
- [AWS X-Ray](https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/environment-configuration-debugging.html) for debugging?

# TLS/Certs 
- [No https by default/ only for custom domains](https://aws.amazon.com/premiumsupport/knowledge-center/elastic-beanstalk-https-configuration/)
>If you purchased and configured a custom domain name for your Elastic Beanstalk environment, you can use HTTPS to allow users to connect to your website securely. If you don't own a domain name, you can still use HTTPS with a self-signed certificate for development and testing purposes.
- Termination at loadbalancer possible [via secure listener](https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/https-singleinstance-java.html) if not single instance
    - Migration can be done afterwards, but replaces all instances.
    - LB can be seen elsewhere, but changes to it (e.g. removing the http listenener) had no effect.
- Termination in instance is [basically configuring the containers nginx](https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/https-singleinstance-java.html)

# Custom Domain
- Simply via CNAME entry
- AWS Certificate Manager can provide valid cert

# Scalability
- Easy and quick scaling up and down
```bash
wrk -t12 -c400 -d10m https://node-eb.prenoob.codes/test
Running 10m test @ https://node-eb.prenoob.codes/test
  12 threads and 400 connections
^C  Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency   362.89ms  305.63ms   1.86s    86.41%
    Req/Sec   103.62     29.22   290.00     70.47%
  288883 requests in 3.89m, 64.47MB read
  Socket errors: connect 0, read 0, write 0, timeout 1530
Requests/sec:   1236.38
Transfer/sec:    282.53KB
```

# VPC Magic and Connecting to other AWS services
- VPCs can be specified during setup
- Big issue: Deleting LB in LoadBalancer UI didnt show any issues, only after reconfiguring/redeploying the env, the missing LB was noticed