#Specify Resource Group 
variable "resourcegroup" {
  type    = string
  description = "Specify the resource group where the VM should be created"  
}

variable "location" {
  type    = string
  description = "Specify the location where the resources should be created, e.g. westeurope"
  default = "UK South"
}

#Replace [Organization] https://dev.azure.com/[Organization]/_usersSettings/tokens
variable "url" {
  type = string
  description = "Specify the Azure DevOps url e.g. https://dev.azure.com/mmelcher"
  default = "https://dev.azure.com/merajakhan"
}

#Create via https://dev.azure.com/[Organization]/_usersSettings/tokens
variable "pat" {
  type = string
  description = "Provide a Personal Access Token (PAT) for Azure DevOps"
}

#The build agent pool. Create it via https://dev.azure.com/[Organization]/_settings/agentpools?poolId=8&_a=agents
variable "pool" {
  type = string
  description = "Specify the name of the agent pool - must exist before"
  default = "MKAgentPool"
}

#The name of the agent
variable "agent" {
  type = string
  description = "Specify the name of the agent"
  default = "MKLinuxAgent"
}

#SSH KEY - change it or you cant sign in to the VM!
variable "sshkey" {
  type    = string
  description = "Provide a ssh public key to logon to the VM"
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAA ..."
}

variable "size" {
  type    = string
  description = "Specify the size of the VM"
  default="Standard_DS2_v2"
}