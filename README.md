# Minecraft server infrastructure on Azure

This repository uses Terraform to create Azure infrastructure intended to host a Minecraft server. It creates a resource group, virtual network and subnet, network security group, static public IP, Linux virtual machine, storage account and private blob container. The VM has a system-assigned managed identity with **Storage Blob Data Contributor** access to the container.

> **What this does not do:** the current Terraform configuration creates the Ubuntu VM but does not install, configure, or start Minecraft. A server installation and its world data setup are still needed before players can connect. The storage container is created and permissioned, but the configuration does not mount it or configure backups.

## Requirements

- An Azure subscription where you can create resource groups, networking, virtual machines, storage accounts, and role assignments.
- [Azure CLI](https://learn.microsoft.com/cli/azure/install-azure-cli) and [Terraform](https://developer.hashicorp.com/terraform/install).
- An SSH key pair. Terraform needs the **public** key; keep the private key on your machine.
- A public IPv4 address or CIDR range for SSH access.

Sign in to Azure and select the subscription before running Terraform:

```sh
az login
az account set --subscription "<subscription-id-or-name>"
```

The AzureRM provider is configured to use Microsoft Entra ID for Storage Blob operations. Terraform can use the Azure CLI sign-in for local runs.

## Configure inputs

Create a local `terraform.tfvars` file in the project root. This file is ignored by Git; do not force-add it because it contains personal configuration.

```hcl
ssh_key_public = "ssh-ed25519 AAAA... your-public-key-comment"
admin_cidr     = "203.0.113.10/32"
source_image_reference = { # if it is the need of using other source image
  publisher = "Canonical"
  offer     = "ubuntu-24_04-lts"
  sku       = "server"
  version   = "latest"
}
```

Replace both example values. `admin_cidr` should be your current public IPv4 address in CIDR notation, usually `/32` for one address. The public key must be the key you will use to SSH into the VM.

### Inputs

| Variable | Required | Default | Purpose |
| --- | --- | --- | --- |
| `ssh_key_public` | Yes | — | Public SSH key installed for the VM administrator. |
| `admin_cidr` | Yes | — | IPv4 CIDR allowed to connect to SSH on port 22. |
| `location` | No | `swedencentral` | Azure region for resources. |
| `resource_group_name` | No | `minecraft_server` | Resource group name. |
| `vm_name` | No | `minecraftserver` | Linux VM name. |
| `vm_size` | No | `Standard_F4als_v7` | Azure VM size; availability depends on the selected region and subscription. |
| `admin_username` | No | `adminuser` | VM administrator account. |
| `dns_label` | No | `minecrafttaverna` | Label for the public IP DNS name; it must be available in Azure. |
| `is_voicechat` | No | `true` | When true, allow inbound UDP port 24454 for voice chat. |
| `azurerm_storage_account_name` | No | `storageaccminecraft` | Storage account name; Azure requires a globally unique valid name. |
| `azurerm_storage_container_name` | No | `minecraft-artifacts` | Private blob container name. |

The Terraform variable definitions also expose the virtual network, subnet, NSG, IP, address ranges, and VM image settings. See [`variables.tf`](variables.tf) to override their defaults. Verify that the VM size, image, DNS label, and storage account name are available for your subscription and region.

## Deploy

Run these commands from the repository root:

```sh
terraform init
terraform fmt -recursive
terraform validate
terraform plan
terraform apply
```

Review the plan before applying. `terraform apply` creates billable Azure resources. Terraform uses local state by default, so keep `terraform.tfstate`, `terraform.tfstate.backup`, and any saved plans private and out of Git.


## Network access and finding the server address

The network security group allows:

| Port | Protocol | Source | Purpose |
| --- | --- | --- | --- |
| 22 | TCP | `admin_cidr` | SSH administration. |
| 25565 | TCP | Any IPv4 address | Standard Minecraft Java server traffic. |
| 24454 | UDP | Any IPv4 address, when `is_voicechat = true` | Voice chat traffic. |

After deployment, find the public IP address and DNS name in the Azure portal under the resource group's **Public IP address** resource. With the default names, you can also query them using Azure CLI:

```sh
az network public-ip show \
  --resource-group minecraft_server \
  --name linuxboxpip \
  --query ipAddress \
  --output tsv

az network public-ip show \
  --resource-group minecraft_server \
  --name linuxboxpip \
  --query dnsSettings.fqdn \
  --output tsv
```

Use the resulting address to SSH as `adminuser` (or your configured `admin_username`). Once you install and start a Minecraft server, players can connect using the public IP or DNS name. The server software must listen on the allowed ports.

## Destroy the infrastructure

To remove the resources managed by this Terraform configuration:

```sh
terraform destroy
```

Review the destroy plan before confirming. This removes the VM, network, storage account, and container managed by this configuration, including data stored in that container.
