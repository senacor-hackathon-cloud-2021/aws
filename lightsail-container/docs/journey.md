# Deployment
- Obvi perms/policies are missing, when going [there](https://lightsail.aws.amazon.com/ls/webapp/home). But nice guide on how to enable and create them.
- [Offered services seem kind of redundant/alias](https://lightsail.aws.amazon.com/ls/webapp/home)?
- Yes, FFM in Good old Germany available
- Apparently you configure how many nodes you want to have and how big they should be
- Multiple container as one deployment (one as public EP)
- Can deploy images from DockerHub or GHCR
- But also a [separate way of pushing images](https://lightsail.aws.amazon.com/ls/docs/en_us/articles/amazon-lightsail-pushing-container-images) (no ECR?)
- Although deployment marked as ready, no route set to public EP, only a few minutes later

# Logging
- Simple logging where application logs and infra logs are mixed either via webconsole or cli
- Not found a native way to export them (e.g. to Cloudwatch)

# TLS/Certs 
- Default a wildcard cert for \<random_uuid>.\<region>.apprunner