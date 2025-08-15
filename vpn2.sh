#!/bin/bash
# ===================================================
# GHOST MODE PRIVACY SHIELD - ADVANCED ANTI-DETECTION
# Author: Abdullah Awan (Elite Cybersecurity Specialist)
# Version: 3.1 (Fixed Variable Initialization)
# ===================================================

# Initialize all variables at the top
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m'

# Strict error handling
set -euo pipefail
trap "echo -e '\n${RED}[!] Script interrupted! Run again to reactivate.${NC}'; exit 1" INT

# Dependency check function
check_deps() {
  local DEPS=(wireguard resolvconf macchanger stubby ufw curl jq openssl)
  for pkg in "${DEPS[@]}"; do
    if ! dpkg -l | grep -q "^ii  $pkg "; then
      echo -e "${YELLOW}[+] Installing $pkg...${NC}"
      apt install -y $pkg
    fi
  done
}

# Main initialization
init() {
  # Check root
  if [ "$(id -u)" -ne 0 ]; then
    echo -e "${RED}[!] Run as root: sudo $0${NC}" >&2
    exit 1
  fi
  
  check_deps
  clear
  echo -e "${YELLOW}"
  echo "========================================"
  echo "  GHOST MODE PRIVACY SHIELD ACTIVATED  "
  echo "========================================"
  echo -e "${NC}"
}

# [Rest of your functions (vpn_rotate, mac_cycle, etc.) remain unchanged]
# ... (include all your existing functions here)

# Main execution
init

# Verify VPN configs exist before continuing
if ! ls /etc/wireguard/wg0_*.conf 1> /dev/null 2>&1; then
  echo -e "${RED}"
  cat << "EOF"
============================================
ERROR: No VPN configs found!
Create multiple WireGuard configs named:
  - wg0_us.conf (USA)
  - wg0_de.conf (Germany)
  - wg0_jp.conf (Japan)
  - etc.
Place in /etc/wireguard/ and rerun script
============================================
EOF
  echo -e "${NC}"
  exit 1
fi

# Activate all protections
vpn_rotate
mac_cycle
stealth_mode
clean_traces

echo -e "\n${GREEN}"
echo "============================================"
echo "  GHOST MODE ACTIVE - YOU ARE NOW INVISIBLE"
echo "============================================"
echo -e "${NC}"

# Keep script running
while true; do sleep 3600; done
