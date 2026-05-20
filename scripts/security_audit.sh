#!/bin/bash
# =============================================================
# security_audit.sh — Secure VPN Infrastructure
# Automated Security Audit Script
# =============================================================

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${CYAN}============================================${NC}"
echo -e "${CYAN}   Secure VPN — Security Audit Report      ${NC}"
echo -e "${CYAN}============================================${NC}"
echo -e "Audited by: $(whoami)"
echo -e "Date:       $(date)"
echo -e "Hostname:   $(hostname)"
echo -e "OS:         $(lsb_release -d | cut -f2)"
echo -e "IP Address: $(hostname -I)"
echo ""

echo -e "${YELLOW}━━━ 1. Service Status ━━━${NC}"
systemctl is-active openvpn-server@server &>/dev/null \
  && echo -e "${GREEN}[PASS] OpenVPN: active${NC}" \
  || echo -e "${RED}[FAIL] OpenVPN: inactive${NC}"
systemctl is-active fail2ban &>/dev/null \
  && echo -e "${GREEN}[PASS] Fail2ban: active${NC}" \
  || echo -e "${RED}[FAIL] Fail2ban: inactive${NC}"
systemctl is-active sshd &>/dev/null \
  && echo -e "${GREEN}[PASS] SSH: active${NC}" \
  || echo -e "${RED}[FAIL] SSH: inactive${NC}"
echo ""

echo -e "${YELLOW}━━━ 2. Firewall Rules ━━━${NC}"
sudo ufw status
echo ""

echo -e "${YELLOW}━━━ 3. Failed Login Attempts ━━━${NC}"
FAILS=$(sudo grep 'Failed password' /var/log/auth.log 2>/dev/null | wc -l)
echo "Total failed SSH attempts: $FAILS"
sudo grep 'Failed password' /var/log/auth.log 2>/dev/null | tail -5 \
  || echo "No failed attempts recorded."
echo ""

echo -e "${YELLOW}━━━ 4. Fail2ban Active Bans ━━━${NC}"
sudo fail2ban-client status sshd 2>/dev/null || echo "Fail2ban sshd jail not active."
echo ""

echo -e "${YELLOW}━━━ 5. Listening Ports ━━━${NC}"
sudo ss -tulpn | grep LISTEN
echo ""

echo -e "${YELLOW}━━━ 6. SSH Hardening ━━━${NC}"
echo -n "PermitRootLogin: "
grep 'PermitRootLogin' /etc/ssh/sshd_config | grep -v '#'
echo -n "MaxAuthTries: "
grep 'MaxAuthTries' /etc/ssh/sshd_config | grep -v '#'
echo ""

echo -e "${YELLOW}━━━ 7. Active User Sessions ━━━${NC}"
who
echo ""

echo -e "${YELLOW}━━━ 8. Disk Usage ━━━${NC}"
df -h | grep -v tmpfs
echo ""

echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${CYAN}   Audit Complete — $(date)${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
