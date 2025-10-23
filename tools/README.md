# set-target — /etc/hosts helper for CTF labs

**Kısa (TR):** Bu küçük yardımcı script, CTF/AttackBox oturumlarında hızlıca `target.ip` (veya özel hostname) kaydı ekleyip kaldırmanıza, yedek tutmanıza ve önbelleği temizlemenize yardımcı olur.

---

## Overview

`set-target.sh` is a small, idempotent helper script for managing a convenient host alias (default: `target.ip`) in `/etc/hosts`. It is designed for sandboxed/authorized lab environments (CTF, TryHackMe AttackBox, local VMs) to avoid typing or sharing raw IP addresses during exercises.

Key features:
- Add/update a hostname to point to an IPv4 address.
- Remove or list matching entries.
- Create timestamped backups of `/etc/hosts` before modifying.
- Keep only the most recent N backups (configurable via `MAX_BACKUPS` in the script; default is 5).
- Best-effort resolver cache flush for `systemd-resolved` or `nscd`.
- Fully idempotent and safe to run multiple times.

---

## Installation

1. Copy the script into your repo or your tools folder:
   ```bash
   mkdir -p tools
   cp set-target.sh tools/
   cd tools
   chmod +x set-target.sh
   ```

2. (Optional) Move to a global location for convenience:
   ```bash
   sudo mv set-target.sh /usr/local/bin/set-target
   sudo chmod +x /usr/local/bin/set-target
   ```

---

## Usage

> The script requires root privileges. If you run it as a normal user, it will re-exec itself with `sudo`.

### Add or update mapping (default name: `target.ip`)
```bash
sudo ./set-target.sh 10.10.226.105
# => Adds/updates: 10.10.226.105 target.ip
```

### Add or update mapping with custom hostname
```bash
sudo ./set-target.sh 10.10.226.105 my.ctf.local
# => Adds/updates: 10.10.226.105 my.ctf.local
```

### List matching entries (default: `target.ip`)
```bash
sudo ./set-target.sh --list
sudo ./set-target.sh --list my.ctf.local
```

### Remove mapping
```bash
sudo ./set-target.sh --remove target.ip
```

### Help
```bash
sudo ./set-target.sh --help
```

---

## Behavior & Implementation Notes

- The script makes a timestamped backup of `/etc/hosts` before any modification, named `/etc/hosts.bak.<UNIX_TIMESTAMP>`.
- Backup rotation: keeps at most `MAX_BACKUPS` recent backups (default `MAX_BACKUPS=5` inside the script). Older backups are deleted automatically.
- Idempotent: re-running the same `set-target.sh <IP> <NAME>` will always leave the hosts file in the same state (it removes any existing lines that match the hostname and appends the new one).
- After modification, the script attempts to flush DNS caches if `systemd-resolved` or `nscd` are detected.
- The script uses a conservative pattern match: it removes lines where the hostname appears as a whole word (`\bHOSTNAME\b`), minimizing accidental deletions.

---

## Troubleshooting

- If `getent hosts target.ip` still returns an old address:
  - Try `sudo systemd-resolve --flush-caches` (if available) or `sudo systemctl restart nscd`.
  - Confirm there are no other resolver layers (e.g., local DNSMasq or corporate DNS) interfering.
- If you see no effect in your browser, try `ping -c1 target.ip` to verify name resolution from the shell.
- If you accidentally removed the wrong line, restore from the most recent backup:
  ```bash
  sudo cp /etc/hosts.bak.<TIMESTAMP> /etc/hosts
  ```
  (You can list backups with `ls -1 /etc/hosts.bak.*`.)

---

## Safety & Best Practices

- Use this script only on systems where you have full permission (AttackBox, local VM, or your personal machine). Do **not** run on shared production hosts.
- Coordinate with teammates if multiple people edit `/etc/hosts` on the same shared environment.
- The script is conservative, but always review `/etc/hosts` after changes if you are in a sensitive environment.

---

## Example workflow (CTF)

1. Start AttackBox or connect VPN.
2. `cd /path/to/tools`
3. `sudo ./set-target.sh 10.10.226.105`
4. Now use `target.ip` in scans and browsers:
   - `nmap -sC -sV target.ip`
   - `curl http://target.ip/`
5. When finished:
   - `sudo ./set-target.sh --remove target.ip`

---

If you want a feature (e.g., `--keep N`, `--backup-dir`, or support for IPv6), open an issue or send a PR. I can also add a small test script that simulates `/etc/hosts` modifications in a sandbox directory for CI.

---

## License
MIT 

