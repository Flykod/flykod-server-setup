# Flykod Server Setup

Scripts para bootstrap de servidores WordPress em droplets da DigitalOcean.

Este projeto automatiza a instalação da stack necessária para rodar sites WordPress:

- Nginx
- PHP 8.3
- MariaDB
- Certbot (SSL)
- Firewall (UFW)

---

## Estrutura

install-stack.sh  
Instala nginx, php, mariadb e dependências.

create-site.sh  
Cria o virtual host do Nginx e a pasta do site.

install-wordpress.sh  
Baixa e instala o WordPress.

firewall.sh  
Configura o firewall do servidor.

---

## Fluxo de uso

Criar um novo droplet Ubuntu na DigitalOcean.

Conectar via SSH:

ssh root@IP_DO_SERVIDOR

Clonar o repositório:

git clone https://github.com/flykod/flykod-server-setup
cd flykod-server-setup

Instalar a stack do servidor:

bash install-stack.sh

Configurar firewall:

bash firewall.sh

Criar o site:

bash create-site.sh dominio.com

Instalar WordPress:

bash install-wordpress.sh dominio.com

Abrir o navegador e acessar:

http://dominio.com

Finalizar instalação do WordPress.

---

## Estrutura de sites no servidor

Os sites são criados em:

/var/www/sites

Exemplo:

/var/www/sites/client1.com  
/var/www/sites/client2.com  

---

## Requisitos

Ubuntu 22.04 LTS  
Droplet DigitalOcean  
DNS apontando para o servidor

---

## Autor

Flykod