<p align="center">
  <img src="https://flykod.com/img/flykod-logo.svg" alt="Flykod Logo" width="280">
</p>

# Flykod Server Setup

Scripts for bootstrapping WordPress servers on DigitalOcean droplets.

This project automates the installation of the stack needed to run WordPress sites:

- Nginx
- PHP 8.3
- MariaDB
- Certbot (SSL)
- Firewall (UFW)

---           
        
## What is this machine? (first time or when you forget)

Run on the server:

```bash
bash welcome.sh
```

Shows the **Flykod logo**, server info (IP, sites), and an **interactive menu**:

- **0** – Exit  
- **1** – Install stack (Nginx, PHP, MariaDB, Certbot)  
- **2** – Configure firewall  
- **3** – Create site (prompts for domain and dev mode **y/n**)  
- **4** – Change domain (prompts for old and new domain)  
- **5** – Install WordPress (prompts for domain)

After each action you can press Enter and choose another option or exit.

*(Optional)* To run this on SSH login, add to `~/.bashrc`:  
`[ -f /path/to/flykod-server-setup/welcome.sh ] && bash /path/to/flykod-server-setup/welcome.sh`

---

## Script overview

| Script | Description |
|--------|-------------|
| **welcome.sh** | Server overview and command list. Run when you need a reminder. |
| **install-stack.sh** | Installs Nginx, PHP, MariaDB and dependencies. |
| **create-site.sh** | Creates the Nginx virtual host and site directory. |
| **change-domain.sh** | Changes a site’s domain (e.g. dev → production). |
| **install-wordpress.sh** | Downloads and installs WordPress into the site. |
| **firewall.sh** | Configures the firewall (UFW). |

---

## Usage flow

### 1. Prepare the server

Create an Ubuntu droplet on DigitalOcean, connect via SSH and clone:

```bash
ssh root@SERVER_IP
git clone https://github.com/flykod/flykod-server-setup
cd flykod-server-setup
bash welcome.sh
```

Install stack and firewall:

```bash
bash install-stack.sh
bash firewall.sh
```

### 2. Create the site

**If the domain already points to the server** (production):

```bash
bash create-site.sh example.com
```

**If the domain is not pointed yet** (development): use `--dev` to create the site and access it **by IP** until DNS is correct:

```bash
bash create-site.sh 123.example.com --dev
```

- The site is available at `http://<SERVER_IP>`.
- When the domain is pointed, you can request SSL or switch to the final domain (see below).

### 3. Install WordPress

```bash
bash install-wordpress.sh example.com
```

(Use the same domain you passed to `create-site.sh`.)

### 4. Change the domain later (e.g. dev → production)

Example: in dev you used `123.example.com` and in production you want `example.com`.

```bash
bash change-domain.sh 123.example.com example.com
```

The script updates Nginx and requests an SSL certificate for the new domain. **You still need to update URLs in WordPress** (the script shows options: WP-CLI, Better Search Replace plugin, or manual).

---

## IP access

- Only available **when the site was created with `--dev`** in `create-site.sh`.
- The “default” site for IP access is stored in `/etc/flykod-server/current_domain`.
- When you run `change-domain.sh`, that default is updated to the new domain (the same site remains accessible by IP).

---

## Site layout on the server

Sites live under:

```
/var/www/sites
```

Examples:

- `/var/www/sites/client1.com`
- `/var/www/sites/123.example.com` (after `change-domain` it can respond as `example.com`; the directory name stays the same)

---

## Command summary

```bash
bash welcome.sh                                    # See what this machine is and list commands
bash create-site.sh domain.com                     # Site with SSL (domain already pointed)
bash create-site.sh dev.domain.com --dev           # Site without SSL, accessible by IP
bash change-domain.sh old.com new.com              # Change site domain
bash install-wordpress.sh domain.com               # Install WordPress
bash firewall.sh                                   # Configure firewall
```

---

## Requirements

- Ubuntu 22.04 LTS
- DigitalOcean droplet (or any server with Nginx/PHP/MariaDB)
- For SSL with Certbot: domain DNS pointing to the server

---

## Author

Flykod
