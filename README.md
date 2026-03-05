
<svg xmlns="http://www.w3.org/2000/svg" width="147.78" height="36" viewBox="0 0 147.78 36">
  <g id="Group_480" data-name="Group 480" transform="translate(-142.22 -92)">
    <path id="Path_670" data-name="Path 670" d="M1.9,0V-21.818H16.342v3.8H6.509v5.2h8.874v3.8H6.509V0ZM23.3-21.818V0H18.757V-21.818ZM28.96,6.371A7.185,7.185,0,0,1,27.3,6.206a6.469,6.469,0,0,1-1.071-.336l1.023-3.516a4.217,4.217,0,0,0,2.029.192A1.927,1.927,0,0,0,30.59,1.257l.3-.788-5.87-16.832h4.773L33.179-4.347h.17l3.42-12.017h4.8L35.181,1.875A7.269,7.269,0,0,1,32.971,5.1,6.053,6.053,0,0,1,28.96,6.371ZM43.381,0V-21.818h4.613v9.62h.288l7.852-9.62h5.529l-8.1,9.769L61.758,0H56.24L50.263-8.97,47.994-6.2V0Zm26.2.32A8.321,8.321,0,0,1,65.3-.74,7.164,7.164,0,0,1,62.511-3.7a9.509,9.509,0,0,1-.98-4.416,9.558,9.558,0,0,1,.98-4.437A7.164,7.164,0,0,1,65.3-15.517a8.321,8.321,0,0,1,4.288-1.06,8.321,8.321,0,0,1,4.288,1.06,7.164,7.164,0,0,1,2.786,2.962,9.558,9.558,0,0,1,.98,4.437,9.509,9.509,0,0,1-.98,4.416A7.164,7.164,0,0,1,73.873-.74,8.321,8.321,0,0,1,69.585.32ZM69.606-3.2A2.815,2.815,0,0,0,72.158-4.6a6.648,6.648,0,0,0,.868-3.548,6.676,6.676,0,0,0-.868-3.553,2.812,2.812,0,0,0-2.551-1.412A2.852,2.852,0,0,0,67.018-11.7a6.644,6.644,0,0,0-.874,3.553A6.616,6.616,0,0,0,67.018-4.6,2.855,2.855,0,0,0,69.606-3.2ZM86.031.266A6.1,6.1,0,0,1,82.664-.7a6.611,6.611,0,0,1-2.386-2.844,10.811,10.811,0,0,1-.884-4.618,10.661,10.661,0,0,1,.911-4.682,6.558,6.558,0,0,1,2.418-2.8,6.15,6.15,0,0,1,3.3-.932,5.084,5.084,0,0,1,2.3.463,4.606,4.606,0,0,1,1.491,1.145,5.812,5.812,0,0,1,.868,1.353h.138v-8.2h4.528V0H90.867V-2.621h-.192a5.481,5.481,0,0,1-.895,1.348,4.6,4.6,0,0,1-1.507,1.1A5.207,5.207,0,0,1,86.031.266Zm1.438-3.612A2.9,2.9,0,0,0,90.01-4.672a6.147,6.147,0,0,0,.9-3.51,6.039,6.039,0,0,0-.895-3.489,2.912,2.912,0,0,0-2.546-1.294,2.882,2.882,0,0,0-2.562,1.326,6.154,6.154,0,0,0-.879,3.457,6.253,6.253,0,0,0,.884,3.489A2.872,2.872,0,0,0,87.469-3.345Z" transform="translate(184 121)" fill="#fff"/>
    <text id="_." data-name="." transform="translate(281 121)" fill="#00f10a" font-size="30" font-family="Inter-Bold, Inter" font-weight="700"><tspan x="0" y="0">.</tspan></text>
    <g id="FAVICON-FLYKOD" transform="translate(-2019.704 1338.546) rotate(90)">
      <g id="Group_477" data-name="Group 477" transform="translate(-1244.495 -2193.563)">
        <path id="Path_665" data-name="Path 665" d="M5.871,25.939H.21V8.719A8.708,8.708,0,0,1,8.888,0h17.18V5.661H8.888A3.041,3.041,0,0,0,5.871,8.719Z" transform="translate(-0.21)" fill="#00f10a"/>
        <path id="Path_663" data-name="Path 663" d="M42.054,50.94H24.835V45.279H42.054a3.05,3.05,0,0,0,3.036-3.058V24.986h5.662V42.221a8.718,8.718,0,0,1-8.7,8.719" transform="translate(-19.231 -19.3)" fill="#00f10a"/>
        <path id="Path_664" data-name="Path 664" d="M20.995,25.149,6.727,10.88l4-4L24.982,21.13l-1.876,1.89Z" transform="translate(-5.244 -5.312)" fill="#00f10a"/>
      </g>
    </g>
  </g>
</svg>


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
