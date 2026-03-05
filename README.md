<p align="center">
  <img src="https://flykod.com/img/flykod-logo.svg" alt="Flykod Logo" width="280">
</p>

# Flykod Server Setup

Scripts for bootstrapping WordPress servers on DigitalOcean droplets.

This project automates the installation of the stack needed to run a single WordPress site:

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
- **5** – Install WordPress (into /var/www/html)

After each action you can press Enter and choose another option or exit.

*(Optional)* To run this on SSH login, add to `~/.bashrc`:  
`[ -f /path/to/flykod-server-setup/welcome.sh ] && bash /path/to/flykod-server-setup/welcome.sh`

---

## Script overview

| Script | Description |
|--------|-------------|
| **flykod** | Launcher: run `flykod start` from anywhere (after linking to `/usr/local/bin`). |
| **welcome.sh** | Server overview and command list. Run when you need a reminder. |
| **install-stack.sh** | Installs Nginx, PHP, MariaDB and dependencies. |
| **create-site.sh** | Creates the Nginx virtual host for the domain (root: /var/www/html). |
| **change-domain.sh** | Changes a site’s domain (e.g. dev → production). |
| **install-wordpress.sh** | Downloads and installs WordPress into /var/www/html. |
| **firewall.sh** | Configures the firewall (UFW). |

---

## Usage flow

### 1. Prepare the server

Create an Ubuntu droplet on DigitalOcean, connect via SSH, then run (clone + open menu in one command):

```bash
git clone https://github.com/flykod/flykod-server-setup && cd flykod-server-setup && bash welcome.sh
```

**Optional — use `flykod start` from anywhere:** after cloning, run once (from inside the repo):

```bash
sudo ln -sf $(pwd)/flykod /usr/local/bin/flykod
```

Then from any directory you can open the menu with:

```bash
flykod start
```

Or step by step (clone only):

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
bash install-wordpress.sh
```

(Installs into /var/www/html.)

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

Single site; document root (world standard):

```
/var/www/html
```

The same folder is used for the site at every step; only the domain (Nginx `server_name`) changes when you run `change-domain.sh`.

---

## Command summary

```bash
flykod start                                       # Open menu (if linked: sudo ln -sf $(pwd)/flykod /usr/local/bin/flykod)
bash welcome.sh                                    # Open menu from repo directory
bash create-site.sh domain.com                     # Site with SSL (domain already pointed)
bash create-site.sh dev.domain.com --dev           # Site without SSL, accessible by IP
bash change-domain.sh old.com new.com              # Change site domain
bash install-wordpress.sh                          # Install WordPress into /var/www/html
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
