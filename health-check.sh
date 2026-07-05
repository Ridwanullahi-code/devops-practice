#!/bin/bash

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
RESET='\033[0m'

print_ok() {
  echo -e "${GREEN}  ✓ $1${RESET}"
}

print_fail() {
  echo -e "${RED}  ✗ $1${RESET}"
}

print_warn() {
  echo -e "${YELLOW}  ! $1${RESET}"
}

print_title() {
  echo ""
  echo "=================================="
  echo "  $1"
  echo "=================================="
}

print_title "ENVIRONMENT HEALTH CHECK"
echo "  Date: $(date)"
echo "  User: $(whoami)"

print_title "Checking Node.js"
if command -v node &> /dev/null; then
  VERSION=$(node --version)
  print_ok "Node.js is installed — $VERSION"
else
  print_fail "Node.js is NOT installed"
fi

print_title "Checking Git"
if command -v git &> /dev/null; then
  VERSION=$(git --version)
  print_ok "$VERSION is installed"
else
  print_fail "Git is NOT installed"
fi

print_title "Checking Project Folder"
PROJECT_DIR=~/devops-practice
if [ -d "$PROJECT_DIR" ]; then
  print_ok "Project folder found at $PROJECT_DIR"
  FILE_COUNT=$(ls $PROJECT_DIR | wc -l)
  print_ok "$FILE_COUNT files inside the folder"
else
  print_fail "Project folder NOT found"
fi

print_title "Checking Disk Space"
DISK_USAGE=$(df -h ~ | awk 'NR==2 {print $5}' | tr -d '%')
if [ "$DISK_USAGE" -lt 80 ]; then
  print_ok "Disk space is fine — ${DISK_USAGE}% used"
elif [ "$DISK_USAGE" -lt 90 ]; then
  print_warn "Disk space getting full — ${DISK_USAGE}% used"
else
  print_fail "Disk space critically low — ${DISK_USAGE}% used"
fi

print_title "Checking Internet"
if ping -c 1 google.com &> /dev/null; then
  print_ok "Internet connection is working"
else
  print_fail "No internet connection"
fi

echo ""
echo "=================================="
echo "  Check complete!"
echo "=================================="
echo ""
