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

Shows the **Flykod logo**, greeting (Powered by Flykod), server info (public IP, site root, domain when set), a **checklist** of completed steps, and an **interactive menu**:

- **0** – Exit  
- **1** – Install stack (Nginx, PHP, MariaDB, Certbot)  
- **2** – Configure firewall  
- **3** – Create database (local DB + user + generated password; skip if using external DB)  
- **4** – Create site (prompts for domain and dev mode **y/n**)  
- **5** – Install WordPress (into /var/www/html)  
- **6** – Change domain (prompts for old and new domain)  
- **7** – Show database password (view stored credentials again)

After each action you can press Enter and choose another option or exit.

*(Optional)* To run this on SSH login, add to `~/.bashrc`:  
`[ -f /path/to/flykod-server-setup/welcome.sh ] && bash /path/to/flykod-server-setup/welcome.sh`

---

## Script overview

| Script | Description |
|--------|-------------|
| **welcome.sh** | Server overview and command list. Run when you need a reminder. |
| **install-stack.sh** | Installs Nginx, PHP, MariaDB and dependencies. |
| **create-site.sh** | Creates the Nginx virtual host for the domain (root: /var/www/html). |
| **change-domain.sh** | Changes a site’s domain (e.g. dev → production). |
| **create-database.sh** | Creates a local MariaDB database and user with a generated password; stores credentials. |
| **show-db-password.sh** | Displays stored database credentials (e.g. if you lost the password). |
| **install-wordpress.sh** | Downloads and installs WordPress into /var/www/html. |
| **firewall.sh** | Configures the firewall (UFW). |

---

## Usage flow

All steps can be done from the **interactive menu** (welcome.sh); the commands below are the same actions if you prefer running them directly in the terminal.

### 1. Prepare the server

Create an Ubuntu droplet on DigitalOcean, connect via SSH, then run (clone + open menu in one command):

```bash
git clone https://github.com/flykod/flykod-server-setup && cd flykod-server-setup && bash welcome.sh
```

From the menu: choose **1** (Install stack), then **2** (Configure firewall). The checklist will show each step as done.

Or run from the repo directory:

```bash
bash install-stack.sh
bash firewall.sh
```

### 2. Create the database (optional)

From the menu: choose **3** (Create database) to create a local MariaDB database and user with an auto-generated password. Credentials are shown once and stored; use **7** (Show database password) to see them again. If you use an **external database**, skip this and enter your existing DB host, name, user and password when WordPress asks during installation.

### 3. Create the site

From the menu: choose **4**, enter the domain, then answer **y/n** for dev mode (use **y** if the domain is not pointed yet so you can access the site by IP).

Or from the terminal:

**If the domain already points to the server** (production):

```bash
bash create-site.sh example.com
```

**If the domain is not pointed yet** (development): use `--dev` to access the site **by public IP** until DNS is correct:

```bash
bash create-site.sh 123.example.com --dev
```

The site is then available at `http://<PUBLIC_IP>`. The menu will show “Domain not pointed yet — use the Public IP above to access the site.” When the domain is pointed, use **Change domain** (step 4) or request SSL.

### 4. Install WordPress

From the menu: choose **5** (use the database credentials from step 2 when WordPress asks).

Or from the terminal:

```bash
bash install-wordpress.sh
```

(Installs into /var/www/html.)

### 5. Change the domain later (e.g. dev → production)

From the menu: choose **6**, then enter the current domain and the new domain.

Or from the terminal (e.g. dev `123.example.com` → production `example.com`):

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
bash welcome.sh                                    # Open menu (from repo directory)
bash create-site.sh domain.com                     # Site with SSL (domain already pointed)
bash create-site.sh dev.domain.com --dev           # Site without SSL, accessible by IP
bash create-database.sh                            # Create local DB + user (password generated)
bash show-db-password.sh                           # Show stored DB credentials again
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
