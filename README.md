# AWS EKS Terraform module

Terraform module which creates AWS EKS (Kubernetes) cluster resource and namespace inside cluster.

# Use Case

General requirements:
1. Deploy in US West 2
2. Cluster name should be your last name
3. Kubernetes version 1.27
4. Create a unique cluster service role for the cluster
5. Resources created should be tagged
        OWNER:APPLICANT_LASTNAME_FIRSTINITIAL
        CATEGORY:ENG_ASSESSMENT

Other requirements:
Node:
1. Node group – max size 6, min size 3, desired size 4
2. Nodes should be CPU Optimized
3. Amazon EKS optimized AMI
4. Auto Update
Namespace:
1. Should have at least one namespace - your last name
Networking:
1. Private with exception of this CIDR block - 196.182.32.48/32
2. VPC should be read in from an output


# Note

1. This AWS EKS module will also create VPC, Subnets (Public & Private), NAT G/W by calling the VPC module from terraform registry.

2. This whole AWS EKS terraform module focuses on creating and deleting EKS cluster resources by using terraform.

3. This module will also create a custom security groups for EKS managed node groups.

# Resources spec

VPC:

1. For creating VPC resource, I have used a module from Terraform registry.
	source  = "terraform-aws-modules/vpc/aws"
	version = "5.4.0“
2. Name of the VPC: “Prasath”
3. VPC CIDR block: "10.0.0.0/16“
4. I have created 2 subnets
	1. Public Subnet
	2. Private Subnet
5. Public Subnet CIDR range: ["10.0.101.0/24", "10.0.102.0/24"]
6. Private Subnet CIDR rage: ["10.0.1.0/24", "10.0.2.0/24"]
7. I have used locals block to reuse the tags across multiple AWS resources
	Tags: OWNER: Prasath_S
	      CATEGORY: ENG_ASSESSMENT
8. Region: us-west-2
9. Availability Zone: Used datasource to pick the available AZ’s in that region
10. Outputs:
	1. VPC_ID
	2. VPC_CIDR block

EKS:

EKS cluster has been created using the resource block.
EKS Cluster name: “Prasath”
EKS Cluster role: “Prasath_S-dev-eks-master-role”
IAM Policy attached with cluster role: 
1. AmazonEKSClusterPolicy
2. AmazonEKSVPCResourceController
EKS Node Group:
	1. Public Node Group
	2. Private Node Group
6. Node Specs:
	1. CPU Optimized nodes: “C5.Xlarge”
	2. EKS optimized AMI: “AL2_x86_64”
	3. Min: 3
	4. Max: 6
	5. Desired: 4
7. Node Group names:
	1. Prasath_S-eks-ng-private
	2. Prasath_S-eks-ng-Public
8. Node Group Role: “Prasath_S-eks-nodegroup-role”
9. IAM policy attached with node group role:
	1. AmazonEKSWorkerNodePolicy
	2. AmazonEKS_CNI_Policy
	3. AmazonEC2ContainerRegistryReadOnly
10. Namespace: 
	1. In order to create a namespace in EKS cluster we need to have Kubernetes provider.
11. Namespace name: “Prasath-ns”
12. Security Groups:
    1. name: "prasath-eks-ng-sg"
    2. Ingress: 
        from_port: 0
        to_port: 65535
        cidr_block: "196.182.32.48/32"
    3. Egress:
        from_port: 0
        to_port: 0
        cidr_block: "0.0.0.0/0"


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

