#!/bin/bash

# ─────────────────────────────────────────
#  SETUP SCRIPT
#  Run this once when you join the project
#  It sets everything up automatically
# ─────────────────────────────────────────

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
RESET='\033[0m'

print_ok()    { echo -e "${GREEN}  ✓ $1${RESET}"; }
print_fail()  { echo -e "${RED}  ✗ $1${RESET}"; }
print_warn()  { echo -e "${YELLOW}  ! $1${RESET}"; }
print_title() { echo ""; echo "── $1 ──────────────────────────"; }

# ── STEP 1: Check requirements ────────────────────

print_title "Checking requirements"

# Check Node.js
if command -v node &> /dev/null; then
  print_ok "Node.js found — $(node --version)"
else
  print_fail "Node.js is required but not installed"
  print_fail "Install it from: https://nodejs.org"
  exit 1    # stop the script — cannot continue without node
fi

# Check Git
if command -v git &> /dev/null; then
  print_ok "Git found — $(git --version)"
else
  print_fail "Git is required but not installed"
  exit 1
fi

# ── STEP 2: Install dependencies ──────────────────

print_title "Installing dependencies"

# Check if package.json exists before running npm install
if [ -f "package.json" ]; then
  npm install
  print_ok "Dependencies installed"
else
  print_warn "No package.json found — skipping npm install"
fi

# ── STEP 3: Create .env file ──────────────────────

print_title "Setting up environment"

if [ -f ".env" ]; then
  print_warn ".env file already exists — skipping"
  print_warn "Delete it manually if you want to reset"
else
  # Copy from the example file if it exists
  if [ -f ".env.example" ]; then
    cp .env.example .env
    print_ok ".env created from .env.example"
    print_warn "Open .env and fill in your actual values"
  else
    # Create a fresh .env with default values
    cat > .env << EOF
# Environment variables for grade tracker
# Fill these in with your actual values

PORT=3000
NODE_ENV=development
DATABASE_URL=your_database_url_here
JWT_SECRET=change_this_to_a_random_secret
EOF
    print_ok ".env file created"
    print_warn "Open .env and fill in your actual values before running the app"
  fi
fi

# ── STEP 4: Create important folders ─────────────

print_title "Creating project folders"

# -p means create parent folders too, no error if already exists
mkdir -p src/students
mkdir -p src/grades
mkdir -p src/subjects
mkdir -p src/shared
mkdir -p tests
mkdir -p logs

print_ok "Project folders ready"

# ── STEP 5: Set correct permissions ──────────────

print_title "Setting permissions"

# Make all scripts executable automatically
chmod +x *.sh
print_ok "Scripts are now executable"

# Protect the .env file — only owner can read it
chmod 600 .env
print_ok ".env is protected (600 — only you can read it)"

# ── DONE ─────────────────────────────────────────

echo ""
echo "════════════════════════════════════"
echo "  Setup complete! 🎉"
echo "════════════════════════════════════"
echo ""
echo "  Next steps:"
echo "  1. Open .env and fill in your values"
echo "  2. Run: npm start"
echo "  3. Visit: http://localhost:3000"
echo ""
