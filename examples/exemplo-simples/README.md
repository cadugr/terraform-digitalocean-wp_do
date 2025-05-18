
# Exemplo de Uso: Módulo de Infraestrutura WordPress na DigitalOcean

Este exemplo demonstra como utilizar o módulo [cadugr/wp_do/digitalocean](https://registry.terraform.io/modules/cadugr/wp_do/digitalocean/latest) para provisionar uma infraestrutura completa de WordPress com alta disponibilidade na DigitalOcean.

## Recursos Criados

Ao utilizar este módulo, os seguintes recursos são provisionados automaticamente:

- VPC privada para isolar a infraestrutura
- Múltiplas máquinas virtuais para WordPress
- Instância de banco de dados MySQL gerenciado
- Servidor NFS para armazenamento compartilhado
- Load Balancer para distribuir requisições entre as instâncias do WordPress

## Pré-requisitos

- Conta na [DigitalOcean](https://www.digitalocean.com/)
- Chave SSH pública configurada localmente (ex: `~/.ssh/aula-terraform.pub`)
- Token de API da DigitalOcean
- Terraform instalado (v1.0 ou superior)

## Estrutura do Projeto

```
.
├── main.tf
├── variables.tf
├── outputs.tf
└── README.md
```

## Como Utilizar

### 1. Configure as variáveis necessárias

No arquivo `variables.tf`:

```
variable "do_token" {
  type = string
}

variable "region" {
  type    = string
  default = "nyc1"
}

variable "wp_vm_count" {
  type        = number
  default     = 2
  description = "Número de máquinas virtuais para o WordPress"
}
```

### 2. Referencie o módulo no `main.tf`

```hcl
terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~>2.0"
    }
  }
}

provider "digitalocean" {
  token = var.do_token
}

resource "digitalocean_ssh_key" "ssh-key" {
  name       = "wp-ssh"
  public_key = file("~/.ssh/aula-terraform.pub")
}

module "wp_stack" {
  source  = "cadugr/wp_do/digitalocean"
  version = "1.x.x"

  region      = var.region
  wp_vm_count = var.wp_vm_count
  vms_ssh     = digitalocean_ssh_key.ssh-key.fingerprint
}
```

### 3. Visualize os resultados no `outputs.tf`

```hcl
output "stack_wp_lb_ip" {
  value       = module.wp_stack.wp_lb_ip
  description = "IP do Load Balancer"
}

output "stack_wp_vm_ips" {
  value       = module.wp_stack.wp_vm_ips
  description = "IPs das VMs do WordPress"
}

output "stack_nfs_vm_ip" {
  value       = module.wp_stack.nfs_vm_ip
  description = "IP da VM do NFS"
}

output "stack_wp_db_user" {
  value       = module.wp_stack.wp_db_user
  description = "Usuário do banco de dados"
}

output "stack_wp_db_pwd" {
  value       = module.wp_stack.wp_db_pwd
  description = "Senha do banco de dados"
  sensitive   = true
}
```

## Execução

```bash
terraform init
terraform plan
terraform apply
```

## Observações

- O número mínimo de instâncias WordPress é **2**.
- A senha do banco de dados é exibida apenas se o Terraform permitir visualizar `sensitive outputs`.
