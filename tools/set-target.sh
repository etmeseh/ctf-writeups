--remove)
    if [[ $# -lt 2 ]]; then
      echo "Error: missing HOSTNAME for --remove"
      usage
      exit 2
    fi
    NAME="$2"
    echo "Backing up $HOSTS_FILE..."
    TIMESTAMP=$(date +%s)
    cp -a "$HOSTS_FILE" "$HOSTS_FILE.bak.$TIMESTAMP"
    # rotate backups: keep only the newest $MAX_BACKUPS backups
    echo "Rotating backups (keeping up to $MAX_BACKUPS)..."
    BACKUPS=( $(ls -1t ${HOSTS_FILE}.bak.* 2>/dev/null || true) )
    if [[ ${#BACKUPS[@]} -gt $MAX_BACKUPS ]]; then
      TO_REMOVE=( "${BACKUPS[@]:$MAX_BACKUPS}" )
      for f in "${TO_REMOVE[@]}"; do
        rm -f "$f" || true
      done
    fi
    echo "Removing entries matching: $NAME"
    # Use sed to remove lines containing the exact hostname word
    sed -i.bak".$TIMESTAMP" "/\b$NAME\b/d" "$HOSTS_FILE"
    echo "Removed. New entries for '$NAME':"
    grep -n "\b$NAME\b" "$HOSTS_FILE" || echo "(none)"
    exit 0#!/usr/bin/env bash
# set-target.sh
# Idempotent helper to add/update/remove a target hostname in /etc/hosts
# Usage:
#   sudo ./set-target.sh 10.10.226.105            # set target.ip -> 10.10.226.105
#   sudo ./set-target.sh 10.10.226.105 target.ip  # set custom hostname
#   sudo ./set-target.sh --remove target.ip       # remove entries for target.ip
#   sudo ./set-target.sh --list                   # list /etc/hosts entries for target patterns
# Notes:
# - This script MUST be run with sudo (it will check and re-run with sudo if needed).
# - It makes a timestamped backup of /etc/hosts before modifying.
# - It's safe to run repeatedly (idempotent).

set -euo pipefail

# defaults
DEFAULT_NAME="target.ip"
HOSTS_FILE="/etc/hosts"
# maximum number of timestamped backups to keep (oldest removed when exceeded)
MAX_BACKUPS=5

usage() {
  cat <<'EOF'
set-target.sh — Manage a convenient lab hostname in /etc/hosts (idempotent, safe)

USAGE:
  sudo ./set-target.sh <IP> [HOSTNAME]
      Add or update HOSTNAME (default: target.ip) to point to IP in /etc/hosts.

  sudo ./set-target.sh --remove HOSTNAME
      Remove any /etc/hosts lines that contain HOSTNAME as a word.

  sudo ./set-target.sh --list [HOSTNAME]
      Show matching lines in /etc/hosts (default: target.ip).

  sudo ./set-target.sh --help
      Show this help text.

EXAMPLES:
  sudo ./set-target.sh 10.10.226.105
      # -> adds/updates "10.10.226.105 target.ip"

  sudo ./set-target.sh 10.10.226.105 my.ctf
      # -> adds/updates "10.10.226.105 my.ctf"

  sudo ./set-target.sh --remove target.ip
      # -> removes lines containing "target.ip"

  sudo ./set-target.sh --list my.ctf
      # -> shows entries matching my.ctf

IMPLEMENTATION NOTES:
  • The script creates a timestamped backup of /etc/hosts before any modification.
  • To avoid clutter, it keeps only the most recent $MAX_BACKUPS backups and deletes older ones.
  • The script attempts a best-effort resolver cache flush (systemd-resolved or nscd) after changes.
  • The script is idempotent: running it multiple times with the same arguments results in the same /etc/hosts mapping.

SAFETY / BEST PRACTICES:
  • This modifies /etc/hosts — run only on systems where you have permission (e.g., your AttackBox or local machine).
  • Avoid scripting this on shared systems without coordination.
  • If you want a different maximum backup count, I can add a --keep <N> option.

EOF
}

# Ensure running as root or re-exec with sudo
if [[ $(id -u) -ne 0 ]]; then
  echo "This script needs root privileges. Re-running with sudo..."
  exec sudo bash "$0" "$@"
fi

if [[ $# -eq 0 ]]; then
  usage
  exit 1
fi

cmd="$1"
case "$cmd" in
  --help|-h)
    usage
    exit 0
    ;;
  --remove)
    if [[ $# -lt 2 ]]; then
      echo "Error: missing HOSTNAME for --remove"
      usage
      exit 2
    fi
    NAME="$2"
    echo "Backing up $HOSTS_FILE..."
    TIMESTAMP=$(date +%s)
    cp -a "$HOSTS_FILE" "$HOSTS_FILE.bak.$TIMESTAMP"
    echo "Removing entries matching: $NAME"
    # Use grep -v to remove lines containing the exact hostname word
    sed -i.bak".$TIMESTAMP" "/\b$NAME\b/d" "$HOSTS_FILE"
    echo "Removed. New entries for '$NAME':"
    grep -n "\b$NAME\b" "$HOSTS_FILE" || echo "(none)"
    exit 0
    ;;
  --list)
    NAME="${2:-$DEFAULT_NAME}"
    echo "Listing lines in $HOSTS_FILE matching: $NAME"
    grep -n "\b$NAME\b" "$HOSTS_FILE" || echo "(none)"
    exit 0
    ;;
  *)
    # expect IP [NAME]
    IP="$1"
    NAME="${2:-$DEFAULT_NAME}"
    # basic IP validation (IPv4)
    if ! [[ "$IP" =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]]; then
      echo "Error: first argument must be an IPv4 address. Got: $IP"
      usage
      exit 3
    fi
    ;;
esac

# At this point we have IP and NAME for add/update
# Backup hosts file
TIMESTAMP=$(date +%s)
cp -a "$HOSTS_FILE" "$HOSTS_FILE.bak.$TIMESTAMP"
# rotate backups: keep only the newest $MAX_BACKUPS backups to avoid clutter
BACKUPS=( $(ls -1t ${HOSTS_FILE}.bak.* 2>/dev/null || true) )
if [[ ${#BACKUPS[@]} -gt $MAX_BACKUPS ]]; then
  TO_REMOVE=( "${BACKUPS[@]:$MAX_BACKUPS}" )
  for f in "${TO_REMOVE[@]}"; do
    rm -f "$f" || true
  done
fi

# Remove existing lines that contain the hostname as a word
sed -i.bak".$TIMESTAMP" "/\b$NAME\b/d" "$HOSTS_FILE"

# Append the new mapping
echo "$IP $NAME" >> "$HOSTS_FILE"

# Show result
echo "Added/updated: $IP $NAME"
echo "Current matching lines in $HOSTS_FILE:"
grep -n "\b$NAME\b" "$HOSTS_FILE" || echo "(none)"

# Try to flush resolver caches if available (best-effort)
if systemctl is-active --quiet systemd-resolved 2>/dev/null; then
  echo "Flushing systemd-resolved cache..."
  systemd-resolve --flush-caches || true
elif systemctl is-active --quiet nscd 2>/dev/null; then
  echo "Restarting nscd..."
  systemctl restart nscd || true
fi

echo "Done. Backup saved to ${HOSTS_FILE}.bak.$TIMESTAMP and ${HOSTS_FILE}.bak.$TIMESTAMP.bak (sed copy)."
