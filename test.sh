#!/bin/bash

# ─────────────────────────────────────────
#  TEST SCRIPT
#  Runs all tests before deployment
#  Stops everything if any test fails
# ─────────────────────────────────────────

GREEN='\033[0;32m'
RED='\033[0;31m'
RESET='\033[0m'

print_ok()    { echo -e "${GREEN}  ✓ $1${RESET}"; }
print_fail()  { echo -e "${RED}  ✗ $1${RESET}"; }
print_title() { echo ""; echo "── $1 ──────────────────────────"; }

print_title "Running tests"
echo "  Time: $(date)"

# ── Run the actual tests ──────────────────

# Check if jest/npm test is available
if [ ! -f "package.json" ]; then
  print_fail "No package.json found — are you in the right folder?"
  exit 1
fi

echo ""
echo "  Running npm test..."
echo ""

# Run tests and capture whether they passed or failed
npm test

# $? captures the exit code of the last command
# 0 = success, anything else = failure
TEST_RESULT=$?

# ── Report result ─────────────────────────

echo ""
if [ $TEST_RESULT -eq 0 ]; then
  echo "════════════════════════════════════"
  print_ok "All tests passed! Safe to deploy."
  echo "════════════════════════════════════"
  exit 0    # exit with success
else
  echo "════════════════════════════════════"
  print_fail "Tests FAILED. Do NOT deploy."
  print_fail "Fix the failing tests first."
  echo "════════════════════════════════════"
  exit 1    # exit with failure — stops any script that called this
fi
