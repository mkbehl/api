# hansen-pi-cognito-apigw

This Hansen-PI pipeline is to create terraform (aws cognito, apigw) and helm charts creation.
1. AWS Cognito, API Gateway etc.
2. Helm Charts (ALB Ingress Controller, Elastisearch, etc.)


## Pre-requisites:-

1. Gitlab-runner role append with new policies (cognito, elasticsearch, kms, efs, iam, apigateway, oidc etc.)
2. AWS LoadBalancer Controller role creation for IRSA Service Account Creation with policies.


## Automation Steps:-

### Stage-1 -->

1. OIDC Connect endpoint Creation for the EKS Clusters. (eksctl utils associate-iam-oidc-provider --region=$REGION --cluster=$EKS_CLUSTER_NAME --approve)

2. Enable a service-linked role to give Amazon ES permissions to access your VPC. (aws iam create-service-linked-role --aws-service-name es.amazonaws.com)


### Stage-2 -->
1. ALB LoadBalancer Controller deployment using Helm Chart Creation. (Update helm chart values.yaml with IRSA annotations and other specs.)


### Stage-3 -->
1. Terraform init, plan & apply for (Elasticsearch, Cognito, EFS, APIGW etc.)
