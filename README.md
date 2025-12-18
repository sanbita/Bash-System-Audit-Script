# 🔍 Bash System Audit Script

An interactive **Bash-based system audit tool** designed to perform basic security and system checks on Linux machines.

This script is intended for **learning, security auditing, and SOC fundamentals practice**.



## ✨ Features

- 📅 Display system banner (date & current user)
- 📁 Automatic creation of `audit_logs` directory
- 🧾 Timestamped audit report generation
- 🎨 Colored terminal output for readability
- 🧭 Interactive menu to select checks
- 🖥️ System information (kernel, disk usage)
- 👤 Local user enumeration (UID > 1000)
- 🕵️ Last logged-in users
- 🔐 Detection of SUID files (privilege escalation risks)
- ⚙️ Top 5 memory-consuming processes
- 🌐 Open listening ports detection (`ss -tuln`)
- 🚨 Sensitive files access verification:
  - `/etc/shadow`
  - `/etc/passwd`
  - `/etc/sudoers`



## 🛠️ Requirements

- Linux system
- Bash shell
- Standard utilities:
  - `awk`
  - `ps`
  - `ss`
  - `find`
  - `last`

(Some checks may require **root privileges** for full visibility.)



## 🚀 Usage

```bash
chmod +x audit.sh
./audit.sh
