# 🧠 CTF Writeups by Etmeseh

A structured and reproducible collection of **CTF (Capture The Flag)** and cybersecurity lab write-ups — designed to document, automate, and learn from every step of the exploitation lifecycle.

This repository brings together:
- 🎯 Detailed, structured write-ups for each challenge  
- ⚙️ Automation tools (like `set-target.sh`) for faster lab setup  
- 🧩 Templates and notes for standardized documentation  

All labs and exercises are completed in **authorized environments** (TryHackMe, HackTheBox, or local VMs).  
The goal is continuous learning and ethical skill-building.

---

## 📁 Repository Structure

```
ctf-writeups/
├── README.md
├── writeups/
│   ├── RoomName-or-slug/
│   │   ├── 01-enumeration.md
│   │   ├── 02-exploitation.md
│   │   ├── 03-privilege-escalation.md
│   │   ├── 04-post-exploit.md
│   │   ├── 05-cleanup.md
│   │   └── assets/
│   │       └── screenshots, logs, txt outputs
│   └── ...
├── templates/
│   ├── writeup-template.md
│   ├── issue-template.md
│   ├── notes-template.md
│   └── README.md (optional overview)
├── tools/
│   ├── set-target.sh
│   └── README.md
└── docs/
    ├── how-to-contribute.md
    └── metadata-format.md
```

---

## 🚀 Quick Start

### 1️⃣ Clone the repository
```bash
git clone https://github.com/<yourusername>/ctf-writeups.git
cd ctf-writeups
```

### 2️⃣ Add a new CTF challenge folder
```bash
mkdir -p writeups/$(date +%Y-%m-%d)-room-name
cp templates/writeup-template.md writeups/$(date +%Y-%m-%d)-room-name/01-enumeration.md
```

### 3️⃣ Manage your target alias
Use the built-in helper script to make IP management easier.
```bash
cd tools
sudo ./set-target.sh 10.10.226.105
# Now you can use 'target.ip' in all your scans
```

### 4️⃣ Start documenting
Follow the sections in the template:
- Enumeration
- Exploitation
- Privilege Escalation
- Post-Exploitation
- Cleanup
- Lessons Learned

---

## ⚙️ Included Tools

### 🔸 set-target.sh
> A simple helper to manage a reusable alias (`target.ip`) in `/etc/hosts`.

**Features**
- Add / remove / list hostnames  
- Timestamped `/etc/hosts` backups (auto-rotating, max 5 kept)  
- DNS cache flushing (systemd-resolved / nscd)  
- Safe, idempotent execution  

**Usage**
```bash
sudo ./set-target.sh 10.10.226.105       # add/update
sudo ./set-target.sh --list              # list entries
sudo ./set-target.sh --remove target.ip  # remove entry
```

---

## 📚 Templates

| File | Purpose |
|------|----------|
| `writeup-template.md` | Complete step-by-step CTF write-up structure |
| `issue-template.md` | GitHub issue tracker template for write-up progress |
| `notes-template.md` | Quick scratchpad for live lab notes |

Each challenge should include:
1. **`01-enumeration.md`** – all recon & scans  
2. **`02-exploitation.md`** – initial access  
3. **`03-privilege-escalation.md`** – root path  
4. **`04-post-exploit.md`** – flags, evidence  
5. **`05-cleanup.md`** – revert, lessons learned  

---

## 🧭 Workflow Example

```bash
# create folder
mkdir -p writeups/$(date +%Y-%m-%d)-tryhackme-tar-sudo
cp templates/writeup-template.md writeups/$(date +%Y-%m-%d)-tryhackme-tar-sudo/01-enumeration.md

# edit and add findings
vim writeups/2025-10-23-tryhackme-tar-sudo/01-enumeration.md

# commit progress
git add .
git commit -m "feat(writeup): add TryHackMe tar sudo enumeration phase"
```

---

## 🧩 Example Write-Up (snippet)

```markdown
# TryHackMe - Tar Sudo Privesc
**Date:** 2025-10-23  
**Target:** target.ip  
**Flag:** THM{80UN7Y_h4cK3r}
```

---

## 🧭 Contribution & Review

- Fork the repo and open a PR for write-ups.
- Use `templates/` for consistency.
- I will review PRs and suggest edits (formatting, clarity, redaction of sensitive steps if needed).

---

## 🧭 Future Plans

- Add Markdown-to-PDF export for sharing.
- Build a CLI to list and search write-ups by tag.
- Integrate automatic metadata (IP, difficulty, platform).
- Include AI-assisted write-up generator for consistent formatting.
- Expand `tools/` (enum automation, cleanup utilities, etc.).

---

## ⚖️ Disclaimer

All the labs, exercises, and scripts documented here are used **strictly for educational purposes** in authorized environments.  
Never attempt to reproduce these techniques on real-world systems without explicit permission.

---

## 👤 Author

**Etka Öncüol**  
💻 Informatics Enthusiast | 🧩 Dual Study Student (Berlin)  
🔗 [LinkedIn](https://linkedin.com/in/oncuol-etka) • [GitHub](https://github.com/etmeseh)

---

> _“From enumeration to escalation — one repo to rule them all.”_ 🧠

