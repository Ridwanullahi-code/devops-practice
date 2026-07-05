#!/bin/bash

# ─────────────────────────────────────────
#  DEPLOY SCRIPT
#  Pulls latest code and restarts server
#  Stops if tests fail
# ─────────────────────────────────────────

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
RESET='\033[0m'

print_ok()    { echo -e "${GREEN}  ✓ $1${RESET}"; }
print_fail()  { echo -e "${RED}  ✗ $1${RESET}"; }
print_warn()  { echo -e "${YELLOW}  ! $1${RESET}"; }
print_title() { echo ""; echo "── $1 ──────────────────────────"; }

echo ""
echo "════════════════════════════════════"
echo "  DEPLOYING GRADE TRACKER"
echo "  $(date)"
echo "════════════════════════════════════"

# ── STEP 1: Run tests first ───────────────────────

print_title "Step 1 of 5 — Running tests"

# Call test.sh — if it fails, stop deployment immediately
bash test.sh

if [ $? -ne 0 ]; then
  print_fail "Deployment stopped — fix failing tests first"
  exit 1
fi

print_ok "Tests passed — continuing deployment"

# ── STEP 2: Pull latest code ──────────────────────

print_title "Step 2 of 5 — Pulling latest code"

# Save current version in case we need to roll back
CURRENT_BRANCH=$(git branch --show-current)
CURRENT_COMMIT=$(git rev-parse --short HEAD)
print_warn "Current version: $CURRENT_BRANCH @ $CURRENT_COMMIT"

# Pull latest code from GitHub
git pull origin main

if [ $? -ne 0 ]; then
  print_fail "Git pull failed — check your connection or conflicts"
  exit 1
fi

print_ok "Latest code pulled successfully"

# ── STEP 3: Install any new dependencies ──────────

print_title "Step 3 of 5 — Installing dependencies"

npm install

if [ $? -ne 0 ]; then
  print_fail "npm install failed"
  exit 1
fi

print_ok "Dependencies up to date"

# ── STEP 4: Restart the server ────────────────────

print_title "Step 4 of 5 — Restarting server"

# Check if pm2 is available (process manager for Node.js)
if command -v pm2 &> /dev/null; then
  pm2 restart grade-tracker
  print_ok "Server restarted with pm2"
else
  print_warn "pm2 not found — skipping server restart"
  print_warn "Install pm2 with: npm install -g pm2"
fi

# ── STEP 5: Confirm deployment ────────────────────

print_title "Step 5 of 5 — Verifying deployment"

NEW_COMMIT=$(git rev-parse --short HEAD)
print_ok "Deployed version: $NEW_COMMIT"
print_ok "Deployed at: $(date)"

# Write deployment log
echo "$(date) — Deployed $NEW_COMMIT by $(whoami)" >> logs/deployments.log
print_ok "Deployment logged"

# ── DONE ─────────────────────────────────────────

echo ""
echo "════════════════════════════════════"
echo "  Deployment complete! 🚀"
echo "════════════════════════════════════"
echo ""
