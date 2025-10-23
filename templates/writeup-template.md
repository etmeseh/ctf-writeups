# {{ROOM_NAME}} — Full Writeup Template
**Date:** {{YYYY-MM-DD}}  
**Platform:** {{TryHackMe / HTB / Custom}}  
**Target:** {{target.ip}}  
**Difficulty:** {{Easy / Medium / Hard}}  

---

## Summary
One-paragraph overview: what the challenge is about, the main vulnerability and the final result (e.g., user/root access achieved). Keep it short and informative.

## Environment
- Host / VM / AttackBox: {{attackbox / vpn / local}}
- Target IP / Hostname: `{{target.ip}}`
- Notes: OS version, special network constraints, authentication preconditions, required lab setup, etc.

---

## Table of Contents
1. [Enumeration](#enumeration)
2. [Initial Access / Exploitation](#initial-access--exploitation)
3. [Privilege Escalation](#privilege-escalation)
4. [Post-Exploitation](#post-exploitation)
5. [Forensics & Evidence](#forensics--evidence)
6. [Cleanup](#cleanup)
7. [Remediation](#remediation)
8. [Lessons Learned](#lessons-learned)
9. [References](#references)

---

## Enumeration
Commands and relevant outputs. Save command outputs into `assets/` and link them here.

```bash
# network
nmap -sC -sV -oN assets/10_nmap_initial.txt {{target.ip}}

# web
curl -sI http://{{target.ip}}/ | tee assets/20_http_head.txt

# local checks (once you have shell)
sudo -l > assets/30_sudo-l.txt
find / -type f -perm -4000 -ls 2>/dev/null > assets/31_suid_files.txt
```

**Key findings:**
- Open ports: ...
- Services & versions: ...
- Notable files/paths: ...
- Possible credentials: ...

---

## Initial Access / Exploitation
Describe the method used to gain initial access. Include commands and short explanations for why they were used.

```bash
# Example
# Exploit or misconfiguration used
<commands here>
```

**Why this works:**
Explain the vulnerability or misconfiguration in simple terms.

---

## Privilege Escalation
List all vectors tried (even failed attempts) and clearly mark the successful one. Include outputs saved into `assets/`.

```bash
# Example: using sudo allowed binary
sudo -l > assets/30_sudo-l.txt
# Successful exploit
sudo /bin/tar -cf /dev/null /dev/null --checkpoint=1 --checkpoint-action=exec='/bin/bash -p'
# verify
id > assets/51_post_tar_id.txt
```

**Analysis:**
- Why this escalation worked
- Why alternatives failed or were not applicable

---

## Post-Exploitation
- **Flags found:** `{{flag}}`
- **Sensitive files:** list absolute paths
- **Persistence checks:** cron, systemd services, autoruns
- **Exfiltration steps (if applicable):** commands used to collect evidence

---

## Forensics & Evidence
List archived files and what they contain. Reference asset filenames that are stored in the repo.
- `assets/10_nmap_initial.txt` — initial port/service scan
- `assets/30_sudo-l.txt` — sudo permissions
- `assets/51_post_tar_id.txt` — root verification

---

## Cleanup
Commands you ran (or recommend running) to remove artifacts created during the engagement. Be explicit and safe.

```bash
# examples
rm -f /tmp/uploaded_file
# restore hosts if changed locally
sudo ./tools/set-target.sh --remove target.ip
```

---

## Remediation
Short, actionable recommendations for system administrators to fix the issue(s):
- Remove or restrict dangerous `sudo` entries (do not allow full binaries like tar/mount unless necessary)
- Keep packages updated (patch known CVEs)
- Harden services and remove unnecessary SUID binaries
- Limit write access to sensitive directories

---

## Lessons Learned
- Important takeaways
- What to look for next time
- Recommended references (GTFOBins, CVE pages, blogposts)

---

## References
- GTFOBins: https://gtfobins.github.io/
- Relevant CVEs, blog posts, room links

---

*Template created to ensure consistent, reproducible CTF write-ups. When finished, move relevant parts from this draft into a final `writeups/YYYY-MM-DD-<room-name>/` directory and add assets.*

