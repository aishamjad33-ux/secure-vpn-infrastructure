#!/bin/bash
# =============================================================
# user_manager.sh — Secure VPN Infrastructure
# User Account Management Script
# =============================================================

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}============================================${NC}"
echo -e "${BLUE}   Secure VPN — User Management System     ${NC}"
echo -e "${BLUE}============================================${NC}"
echo -e "Host: $(hostname) | Date: $(date)"
echo ""

echo -e "${YELLOW}SELECT OPTION:${NC}"
echo "1) Create new user"
echo "2) Delete user"
echo "3) Grant sudo privilege"
echo "4) Revoke sudo privilege"
echo "5) List all system users"
echo "6) Check user privilege level"
echo "7) Exit"
echo ""
read -p "Enter option [1-7]: " opt

case $opt in
  1) read -p "Enter username: " u
     sudo adduser "$u"
     echo -e "${GREEN}[OK] User $u created.${NC}" ;;
  2) read -p "Enter username to delete: " u
     sudo deluser --remove-home "$u"
     echo -e "${RED}[OK] User $u deleted.${NC}" ;;
  3) read -p "Enter username to grant sudo: " u
     sudo usermod -aG sudo "$u"
     echo -e "${GREEN}[OK] Sudo granted to $u.${NC}" ;;
  4) read -p "Enter username to revoke sudo: " u
     sudo deluser "$u" sudo
     echo -e "${RED}[OK] Sudo revoked from $u.${NC}" ;;
  5) echo -e "${YELLOW}--- System Users ---${NC}"
     awk -F: '$3 >= 1000 && $3 < 65534 {print "User: "$1" | Home: "$6}' /etc/passwd ;;
  6) read -p "Enter username to check: " u
     id "$u"
     groups "$u" ;;
  7) echo "Exiting..."; exit 0 ;;
  *) echo -e "${RED}Invalid option${NC}" ;;
esac
