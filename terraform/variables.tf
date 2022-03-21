variable "route53_domain_name" {
  type        = string
  description = "The domain"
  default     = "natebayaws.cloud"
}

variable "route53_zone_id" {
  type        = string
  description = <<EOF
The route53 zone id where DNS entries will be created. Should be the zone id
for the domain in the var route53_domain_name.
EOF
  default     = "Z08283091JJ6X8ITV69S6"
}

variable "jenkins_dns_alias" {
  type        = string
  description = <<EOF
The DNS alias to be associated with the deployed jenkins instance. Alias will
be created in the given route53 zone
EOF
  default     = "jenkins-controller"
}

variable "vpc_id" {
  type        = string
  description = "The vpc id for where jenkins will be deployed"
  default     = "vpc-4ff8bc37"
}

variable "efs_subnet_ids" {
  type        = list(string)
  description = "A list of subnets to attach to the EFS mountpoint. Should be private"
  default     = ["subnet-082823527a66dfb03", "subnet-01ead1fb0854f8abc"] # private A, private B
}

variable "jenkins_controller_subnet_ids" {
  type        = list(string)
  description = "A list of subnets for the jenkins controller fargate service. Should be private"
  default     = ["subnet-082823527a66dfb03", "subnet-01ead1fb0854f8abc"] # private A, private B
}

variable "alb_subnet_ids" {
  type        = list(string)
  description = "A list of subnets for the Application Load Balancer"
  default     = ["subnet-04e026aa71cda0f0f", "subnet-01ea73f369a51bcd5"] # public A, public B
}
