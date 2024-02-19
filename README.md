# AWS EKS Terraform module

Terraform module which creates AWS EKS (Kubernetes) resources


### External Documentation

Please note that we strive to provide a comprehensive suite of documentation for __*configuring and utilizing the module(s)*__ defined here, and that documentation regarding EKS (including EKS managed node group, self managed node group, and Fargate profile) and/or Kubernetes features, usage, etc. are better left up to their respective sources:
- [AWS EKS Documentation](https://docs.aws.amazon.com/eks/latest/userguide/getting-started.html)
- [Kubernetes Documentation](https://kubernetes.io/docs/home/)

#### Reference Architecture

The examples provided under `examples/` provide a comprehensive suite of configurations that demonstrate nearly all of the possible different configurations and settings that can be used with this module. However, these examples are not representative of clusters that you would normally find in use for production workloads. For reference architectures that utilize this module, please see the following:

- [EKS Reference Architecture](https://github.com/clowdhaus/eks-reference-architecture)

## Available Features

- AWS EKS Cluster Addons
- AWS EKS Identity Provider Configuration
- [AWS EKS on Outposts support](https://aws.amazon.com/blogs/aws/deploy-your-amazon-eks-clusters-locally-on-aws-outposts/)
- All [node types](https://docs.aws.amazon.com/eks/latest/userguide/eks-compute.html) are supported:
  - [EKS Managed Node Group](https://docs.aws.amazon.com/eks/latest/userguide/managed-node-groups.html)
  - [Self Managed Node Group](https://docs.aws.amazon.com/eks/latest/userguide/worker.html)
  - [Fargate Profile](https://docs.aws.amazon.com/eks/latest/userguide/fargate.html)
- Support for creating Karpenter related AWS infrastructure resources (e.g. IAM roles, SQS queue, EventBridge rules, etc.)
- Support for custom AMI, custom launch template, and custom user data including custom user data template
- Support for Amazon Linux 2 EKS Optimized AMI and Bottlerocket nodes
  - Windows based node support is limited to a default user data template that is provided due to the lack of Windows support and manual steps required to provision Windows based EKS nodes
- Support for module created security group, bring your own security groups, as well as adding additional security group rules to the module created security group(s)
- Support for creating node groups/profiles separate from the cluster through the use of sub-modules (same as what is used by root module)
- Support for node group/profile "default" settings - useful for when creating multiple node groups/Fargate profiles where you want to set a common set of configurations once, and then individually control only select features on certain node groups/profiles

### [IRSA Terraform Module](https://github.com/terraform-aws-modules/terraform-aws-iam/tree/master/modules/iam-role-for-service-accounts-eks)

An IAM role for service accounts (IRSA) sub-module has been created to make deploying common addons/controllers easier. Instead of users having to create a custom IAM role with the necessary federated role assumption required for IRSA plus find and craft the associated policy required for the addon/controller, users can create the IRSA role and policy with a few lines of code. See the [`terraform-aws-iam/examples/iam-role-for-service-accounts`](https://github.com/terraform-aws-modules/terraform-aws-iam/blob/master/examples/iam-role-for-service-accounts-eks/main.tf) directory for examples on how to use the IRSA sub-module in conjunction with this (`terraform-aws-eks`) module.

Some of the addon/controller policies that are currently supported include:

- [Cert-Manager](https://cert-manager.io/docs/configuration/acme/dns01/route53/#set-up-an-iam-role)
- [Cluster Autoscaler](https://github.com/kubernetes/autoscaler/blob/master/cluster-autoscaler/cloudprovider/aws/README.md)
- [EBS CSI Driver](https://github.com/kubernetes-sigs/aws-ebs-csi-driver/blob/master/docs/example-iam-policy.json)
- [EFS CSI Driver](https://github.com/kubernetes-sigs/aws-efs-csi-driver/blob/master/docs/iam-policy-example.json)
- [External DNS](https://github.com/kubernetes-sigs/external-dns/blob/master/docs/tutorials/aws.md#iam-policy)
- [External Secrets](https://github.com/external-secrets/kubernetes-external-secrets#add-a-secret)
- [FSx for Lustre CSI Driver](https://github.com/kubernetes-sigs/aws-fsx-csi-driver/blob/master/docs/README.md)
- [Karpenter](https://github.com/aws/karpenter/blob/main/website/content/en/preview/getting-started/cloudformation.yaml)
- [Load Balancer Controller](https://github.com/kubernetes-sigs/aws-load-balancer-controller/blob/main/docs/install/iam_policy.json)
  - [Load Balancer Controller Target Group Binding Only](https://kubernetes-sigs.github.io/aws-load-balancer-controller/v2.4/deploy/installation/#iam-permission-subset-for-those-who-use-targetgroupbinding-only-and-dont-plan-to-use-the-aws-load-balancer-controller-to-manage-security-group-rules)
- [App Mesh Controller](https://github.com/aws/aws-app-mesh-controller-for-k8s/blob/master/config/iam/controller-iam-policy.json)
  - [App Mesh Envoy Proxy](https://raw.githubusercontent.com/aws/aws-app-mesh-controller-for-k8s/master/config/iam/envoy-iam-policy.json)
- [Managed Service for Prometheus](https://docs.aws.amazon.com/prometheus/latest/userguide/set-up-irsa.html)
- [Node Termination Handler](https://github.com/aws/aws-node-termination-handler#5-create-an-iam-role-for-the-pods)
- [Velero](https://github.com/vmware-tanzu/velero-plugin-for-aws#option-1-set-permissions-with-an-iam-user)
- [VPC CNI](https://docs.aws.amazon.com/eks/latest/userguide/cni-iam-role.html)

See [terraform-aws-iam/modules/iam-role-for-service-accounts](https://github.com/terraform-aws-modules/terraform-aws-iam/tree/master/modules/iam-role-for-service-accounts-eks) for current list of supported addon/controller policies as more are added to the project.



## Examples

- [Complete](https://github.com/terraform-aws-modules/terraform-aws-eks/tree/master/examples/complete): EKS Cluster using all available node group types in various combinations demonstrating many of the supported features and configurations
- [EKS Managed Node Group](https://github.com/terraform-aws-modules/terraform-aws-eks/tree/master/examples/eks_managed_node_group): EKS Cluster using EKS managed node groups
- [Fargate Profile](https://github.com/terraform-aws-modules/terraform-aws-eks/tree/master/examples/fargate_profile): EKS cluster using [Fargate Profiles](https://docs.aws.amazon.com/eks/latest/userguide/fargate.html)
- [Karpenter](https://github.com/terraform-aws-modules/terraform-aws-eks/tree/master/examples/karpenter): EKS Cluster with [Karpenter](https://karpenter.sh/) provisioned for intelligent data plane management
- [Outposts](https://github.com/terraform-aws-modules/terraform-aws-eks/tree/master/examples/outposts): EKS local cluster provisioned on [AWS Outposts](https://docs.aws.amazon.com/eks/latest/userguide/eks-outposts.html)
- [Self Managed Node Group](https://github.com/terraform-aws-modules/terraform-aws-eks/tree/master/examples/self_managed_node_group): EKS Cluster using self-managed node groups
- [User Data](https://github.com/terraform-aws-modules/terraform-aws-eks/tree/master/examples/user_data): Various supported methods of providing necessary bootstrap scripts and configuration settings via user data

## Contributing

We are grateful to the community for contributing bugfixes and improvements! Please see below to learn how you can take part.

- [Code of Conduct](https://github.com/terraform-aws-modules/.github/blob/master/CODE_OF_CONDUCT.md)
- [Contributing Guide](https://github.com/terraform-aws-modules/.github/blob/master/CONTRIBUTING.md)

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.47 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | >= 2.10 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.47 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | >= 2.10 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_vpc"></a> [vpc](#module\_vpc) | terraform-aws-modules/vpc/aws | 5.4.0 |

## Resources

| Name | Type |
|------|------|
| [aws_eks_cluster] | resource |
| [kubernetes_namespace_v1] | resource |
| [aws_eks_node_group] | resource |
| [aws_iam_role] | resource |
| [aws_iam_role_policy_attachment] | resource |
| [aws_security_group] | resource |


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="aws_region"></a> [aws_region](#aws_region) | Indicates which aws region the resources needs to be provisioned| `string` | `us-west-2` | yes |
| <a name="environment"></a> [environment](#environment) | Indicates which aws environment the resources needs to be provisioned| `string` | `dev` | no |
| <a name="owners"></a> [owners](#owners) | Indicates about the owner name for used in tags | `string` | `Prasath_S` | yes |
| <a name="category"></a> [category](#category) | Indicates about the category name for used in tags | `string` | `ENG_ASSESSMENT` | yes |
| <a name="vpc_name"></a> [vpc_name](#vpc_name) | VPC name | `string` | null | no |
| <a name="vpc_cidr_block"></a> [vpc_cidr_block](#vpc_cidr_block) | VPC cidr block | `string` | `10.0.0.0/16` | yes |
| <a name="vpc_public_subnets"></a> [vpc_public_subnets](#vpc_public_subnets) | VPC public subnets cidr block | `list(string)` | `["10.0.101.0/24", "10.0.102.0/24"]` | yes |
| <a name="vpc_private_subnets"></a> [vpc_private_subnets](#vpc_private_subnets) | VPC private subnets cidr block | `list(string)` | `["10.0.101.0/24", "10.0.102.0/24"]` | yes |
| <a name="vpc_enable_nat_gateway"></a> [vpc_enable_nat_gateway](#vpc_enable_nat_gateway) | Indicates whether to enable nat gateway inside VPC or not | `bool` | `true` | yes |
| <a name="vpc_single_nat_gateway"></a> [vpc_single_nat_gateway](#vpc_single_nat_gateway) | Indicates whether to enable single nat gateway inside VPC or not | `bool` | `true` | yes |
| <a name="cluster_name"></a> [cluster_name](#cluster_name) | EKS Cluster name | `string` | `Prasath` | yes |
| <a name="cluster_service_ipv4_cidr"></a> [cluster_service_ipv4_cidr](#cluster_service_ipv4_cidr) | EKS Cluster service IPV4 cidr range for the services to get ip address range in EKS | `string` | `172.20.0.0/16` | yes |
| <a name="cluster_version"></a> [cluster_version](#cluster_version) | EKS Cluster version | `string` | `1.27` | yes |
| <a name="cluster_endpoint_private_access"></a> [cluster_endpoint_private_access](#cluster_endpoint_private_access) | EKS Cluster endpoint private access | `bool` | `false` | yes |
| <a name="cluster_endpoint_public_access"></a> [cluster_endpoint_public_access](#cluster_endpoint_public_access) | EKS Cluster endpoint public access | `bool` | `true` | yes |
| <a name="cluster_endpoint_public_access_cidrs"></a> [cluster_endpoint_public_access_cidrs](#cluster_endpoint_public_access_cidrs) | EKS Cluster endpoint public access cidrs | `list(string)` | `["0.0.0.0/0"]` | yes |


## Outputs

| Name | Description |
|------|-------------|
| <a name="vpc_id"></a> [vpc_id](#vpc_id) | Outputs the vpc id|
| <a name="vpc_cidr_block"></a> [vpc_cidr_block](#vpc_cidr_block) | Outputs the vpc cidr block|
| <a name="private_subnets"></a> [private_subnets](#private_subnets) | List of IDs of private subnets|
| <a name="public_subnets"></a> [public_subnets](#public_subnets) | List of IDs of public subnets|

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

