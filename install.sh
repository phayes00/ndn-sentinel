#!/bin/bash
set -e

# ═══════════════════════════════════════════════════════════
# NDN Sentinel Agent - One-Line Installer
# ═══════════════════════════════════════════════════════════

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'
BOLD='\033[1m'

echo -e "${BLUE}${BOLD}"
echo "  ╔═══════════════════════════════════════╗"
echo "  ║       NDN Sentinel EDR Agent          ║"
echo "  ║       Endpoint Detection & Response   ║"
echo "  ╚═══════════════════════════════════════╝"
echo -e "${NC}"

# Parse args
ORG_ID=""
SUPABASE_URL=""
SUPABASE_KEY=""

while [[ $# -gt 0 ]]; do
  case $1 in
    --org-id) ORG_ID="$2"; shift 2 ;;
    --supabase-url) SUPABASE_URL="$2"; shift 2 ;;
    --supabase-key) SUPABASE_KEY="$2"; shift 2 ;;
    *) echo -e "${RED}Unknown option: $1${NC}"; exit 1 ;;
  esac
done

if [ -z "$ORG_ID" ] || [ -z "$SUPABASE_URL" ] || [ -z "$SUPABASE_KEY" ]; then
  echo -e "${RED}Error: Missing required arguments.${NC}"
  echo "Usage: install.sh --org-id <ORG_ID> --supabase-url <URL> --supabase-key <KEY>"
  exit 1
fi

# Check root
if [ "$EUID" -ne 0 ]; then
  echo -e "${RED}Error: Please run as root (use sudo)${NC}"
  exit 1
fi

# Check Linux
if [ "$(uname)" != "Linux" ]; then
  echo -e "${RED}Error: NDN Sentinel only supports Linux${NC}"
  exit 1
fi

# Check architecture
ARCH=$(uname -m)
if [ "$ARCH" != "x86_64" ]; then
  echo -e "${RED}Error: Only x86_64 is currently supported (detected: $ARCH)${NC}"
  exit 1
fi

INSTALL_DIR="/opt/ndn-sentinel"
BINARY_URL="https://github.com/phayes00/ndn-sentinel/releases/latest/download/ndn-agent"

echo -e "${CYAN}[1/5]${NC} Creating install directory..."
mkdir -p $INSTALL_DIR

echo -e "${CYAN}[2/5]${NC} Downloading NDN Sentinel agent..."
if command -v curl &> /dev/null; then
  curl -sL "$BINARY_URL" -o "$INSTALL_DIR/ndn-agent"
elif command -v wget &> /dev/null; then
  wget -q "$BINARY_URL" -O "$INSTALL_DIR/ndn-agent"
else
  echo -e "${RED}Error: curl or wget required${NC}"
  exit 1
fi

chmod +x "$INSTALL_DIR/ndn-agent"
echo -e "${GREEN}  ✓ Agent binary downloaded${NC}"

echo -e "${CYAN}[3/5]${NC} Configuring agent..."
cat > "$INSTALL_DIR/.env" << ENVEOF
SUPABASE_URL=$SUPABASE_URL
SUPABASE_KEY=$SUPABASE_KEY
ORG_ID=$ORG_ID
ENVEOF

chmod 600 "$INSTALL_DIR/.env"
echo -e "${GREEN}  ✓ Configuration saved${NC}"

echo -e "${CYAN}[4/5]${NC} Creating systemd service..."
cat > /etc/systemd/system/ndn-agent.service << SVCEOF
[Unit]
Description=NDN Sentinel EDR Agent
After=network.target
Wants=network-online.target

[Service]
Type=simple
WorkingDirectory=$INSTALL_DIR
ExecStart=$INSTALL_DIR/ndn-agent
Restart=always
RestartSec=5
Environment=RUST_LOG=info
EnvironmentFile=$INSTALL_DIR/.env

[Install]
WantedBy=multi-user.target
SVCEOF

systemctl daemon-reload
systemctl enable ndn-agent
echo -e "${GREEN}  ✓ Systemd service created${NC}"

echo -e "${CYAN}[5/5]${NC} Starting NDN Sentinel..."
systemctl start ndn-agent
sleep 2

if systemctl is-active --quiet ndn-agent; then
  echo ""
  echo -e "${GREEN}${BOLD}  ═══════════════════════════════════════${NC}"
  echo -e "${GREEN}${BOLD}  ✓ NDN Sentinel is now protecting this server${NC}"
  echo -e "${GREEN}${BOLD}  ═══════════════════════════════════════${NC}"
  echo ""
  echo -e "  ${BOLD}Install path:${NC}  $INSTALL_DIR"
  echo -e "  ${BOLD}Service:${NC}       ndn-agent.service"
  echo -e "  ${BOLD}Status:${NC}        sudo systemctl status ndn-agent"
  echo -e "  ${BOLD}Logs:${NC}          sudo journalctl -u ndn-agent -f"
  echo ""
  echo -e "  Your endpoint will appear on the dashboard within 30 seconds."
  echo ""
else
  echo -e "${RED}Error: Agent failed to start. Check logs:${NC}"
  echo "  sudo journalctl -u ndn-agent --no-pager -n 20"
  exit 1
fi
