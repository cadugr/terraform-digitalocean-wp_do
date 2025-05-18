# Terraform Module: WordPress Infrastructure on DigitalOcean

Este módulo do Terraform provisiona uma infraestrutura altamente disponível para execução do WordPress na [DigitalOcean](https://www.digitalocean.com/), incluindo:

- VMs para execução do WordPress
- VM para servidor NFS
- Banco de dados MySQL gerenciado
- Load Balancer para distribuir requisições entre as instâncias do WordPress
- Integração via rede privada (VPC)

## 📦 Registry Terraform

Este módulo está publicado no [Terraform Registry](https://registry.terraform.io/modules/cadugr/wp_do/digitalocean/latest).  
Você pode utilizá-lo diretamente em seu projeto da seguinte forma:

```hcl
module "wordpress_infra" {
  source  = "cadugr/wp_do/digitalocean"
  version = "1.0.0" # ou "latest"

  region      = "nyc1"
  wp_vm_count = 3
  vms_ssh     = "ssh-rsa AAAA..."
}
```

---

## 🔧 Recursos Criados

O módulo provisiona os seguintes recursos na DigitalOcean:

- **VPC** privada para isolar a infraestrutura (`digitalocean_vpc`)
- **Load Balancer** para distribuição de tráfego HTTP (`digitalocean_loadbalancer`)
- **Múltiplas Droplets** para execução do WordPress (`digitalocean_droplet.vm_wp`)
- **Droplet NFS** para armazenamento compartilhado (`digitalocean_droplet.vm_nfs`)
- **Banco de Dados MySQL** gerenciado (`digitalocean_database_cluster`)
- **Usuário e Banco de Dados** específicos para o WordPress

---

## 📥 Variáveis de Entrada

| Nome          | Tipo   | Descrição                                         | Padrão |
|---------------|--------|----------------------------------------------------|--------|
| `region`      | string | Região da DigitalOcean onde os recursos serão criados | `"nyc1"` |
| `wp_vm_count` | number | Número de instâncias para o WordPress (mínimo: 2) | `2`    |
| `vms_ssh`     | string | Chave pública SSH usada para acessar as VMs       | n/a    |

---

## 📤 Outputs

| Nome            | Descrição                                  |
|-----------------|---------------------------------------------|
| `wp_lb_ip`      | IP público do Load Balancer                 |
| `wp_vm_ips`     | Lista de IPs das instâncias do WordPress    |
| `nfs_vm_ip`     | IP da instância NFS                         |
| `wp_db_user`    | Nome do usuário do banco de dados           |
| `wp_db_pwd`     | Senha do banco de dados (marcado como sensível) |

---

## 🧠 Como Funciona

1. O módulo cria uma **VPC privada** onde todos os recursos ficam isolados.
2. Um **Load Balancer** recebe requisições HTTP na porta 80 e distribui entre as VMs do WordPress.
3. As **instâncias do WordPress** são criadas de forma dinâmica com base na variável `wp_vm_count`.
4. Uma **instância dedicada NFS** é criada para fornecer armazenamento compartilhado para as VMs.
5. Um **banco de dados MySQL gerenciado** é criado junto com um banco e um usuário específicos para o WordPress.

---

## 📎 Exemplo Completo

```hcl
provider "digitalocean" {
  token = var.do_token
}

module "wordpress_infra" {
  source  = "cadugr/wp_do/digitalocean"
  version = "1.0.0"

  region      = "nyc1"
  wp_vm_count = 3
  vms_ssh     = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQD..."
}

output "wordpress_url" {
  value = "http://${module.wordpress_infra.wp_lb_ip}"
}
```

---

## ❗ Requisitos

- Conta ativa na [DigitalOcean](https://cloud.digitalocean.com)
- Token de API válido com permissões para criar Droplets, VPCs, e bancos de dados
- Chave SSH pública já cadastrada na sua conta DigitalOcean

---

## 🛠️ Recomendação

- Configure o volume NFS para ser montado nas instâncias WordPress usando `cloud-init` ou provisionadores externos.
- Utilize um bucket ou volume DigitalOcean Block Storage adicional para persistência mais robusta dos dados.

---

## 📄 Licença

Este módulo está licenciado sob a [MIT License](LICENSE).

---
