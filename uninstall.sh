#!/bin/bash
set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
NC='\033[0m'
BOLD='\033[1m'

echo -e "${RED}${BOLD}"
echo "  ╔═══════════════════════════════════════╗"
echo "  ║     NDN Sentinel - Uninstaller        ║"
echo "  ╚═══════════════════════════════════════╝"
echo -e "${NC}"

if [ "$EUID" -ne 0 ]; then
  echo -e "${RED}Error: Please run as root (use sudo)${NC}"
  exit 1
fi

echo -e "${CYAN}[1/4]${NC} Stopping agent..."
systemctl stop ndn-agent 2>/dev/null || true
systemctl disable ndn-agent 2>/dev/null || true
echo -e "${GREEN}  ✓ Agent stopped${NC}"

echo -e "${CYAN}[2/4]${NC} Removing service..."
rm -f /etc/systemd/system/ndn-agent.service
systemctl daemon-reload
echo -e "${GREEN}  ✓ Service removed${NC}"

echo -e "${CYAN}[3/4]${NC} Removing agent files..."
rm -rf /opt/ndn-sentinel
echo -e "${GREEN}  ✓ Files removed${NC}"

echo -e "${CYAN}[4/4]${NC} Cleaning up..."
systemctl reset-failed ndn-agent 2>/dev/null || true
echo -e "${GREEN}  ✓ Cleanup complete${NC}"

echo ""
echo -e "${GREEN}${BOLD}  NDN Sentinel has been completely removed.${NC}"
echo ""
