# Quick Lab Notes — {{ROOM_NAME}}
**Date:** {{YYYY-MM-DD}}  
**Target:** {{target.ip}}  

---

## Quick Commands
- nmap: `nmap -sC -sV {{target.ip}} -oN assets/10_nmap.txt`
- http dir: `gobuster dir -u http://{{target.ip}} -w /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt`
- ftp active: `lftp -e 'set ftp:passive-mode false; get locks.txt; bye' ftp://{{target.ip}}`

---

## Observations
- Port 21 (ftp): passive mode issues.
- Webroot: `/var/www/html`
- User found: `{{username}}`
- Interesting file: `/etc/passwd` (check for writable lines)

---

## To Do
- [ ] Try ftp with lftp (active mode)
- [ ] Check sudo -l
- [ ] Enumerate SUID files
- [ ] Inspect cron jobs and systemd services
- [ ] Check writable directories

---

## Scratchpad
Paste or append command outputs, temporary notes, hashes, credentials, or observed anomalies below.

```
# example: sudo -l
(root) /bin/tar

# example: flag found
THM{example_flag}
```

---

## Notes
Use this file as a quick working scratchpad while solving the CTF. When the challenge is complete, migrate relevant information into the structured write-up (see `writeup-template.md`).

