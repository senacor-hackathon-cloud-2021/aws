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

# Logging
- Download via Web UI per environment
- Can be configured to stream logs to cloudwatch