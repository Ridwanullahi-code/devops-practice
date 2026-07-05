#!/bin/bash

# ─────────────────────────────────────────
#  BACKUP SCRIPT
#  Backs up project files every night
#  Run automatically with a cron job
# ─────────────────────────────────────────

GREEN='\033[0;32m'
RED='\033[0;31m'
RESET='\033[0m'

print_ok()    { echo -e "${GREEN}  ✓ $1${RESET}"; }
print_fail()  { echo -e "${RED}  ✗ $1${RESET}"; }
print_title() { echo ""; echo "── $1 ──────────────────────────"; }

# ── Configuration ─────────────────────────────────

PROJECT_NAME="grade-tracker"
SOURCE_DIR=~/devops-practice
BACKUP_DIR=~/backups
DATE=$(date +%Y-%m-%d_%H-%M)    # example: 2026-07-04_17-30
BACKUP_NAME="${PROJECT_NAME}_${DATE}"
MAX_BACKUPS=7    # keep only last 7 backups, delete older ones

# ── STEP 1: Create backup folder ─────────────────

print_title "Preparing backup"

mkdir -p $BACKUP_DIR
print_ok "Backup folder ready at $BACKUP_DIR"

# ── STEP 2: Create the backup ─────────────────────

print_title "Creating backup"

# Copy project files (excluding node_modules — too large)
cp -r $SOURCE_DIR $BACKUP_DIR/$BACKUP_NAME

# Remove node_modules from backup to save space
rm -rf $BACKUP_DIR/$BACKUP_NAME/node_modules

print_ok "Files backed up to $BACKUP_DIR/$BACKUP_NAME"

# Show backup size
BACKUP_SIZE=$(du -sh $BACKUP_DIR/$BACKUP_NAME | cut -f1)
print_ok "Backup size: $BACKUP_SIZE"

# ── STEP 3: Delete old backups ────────────────────

print_title "Cleaning old backups"

# Count how many backups exist
BACKUP_COUNT=$(ls $BACKUP_DIR | grep $PROJECT_NAME | wc -l)

if [ $BACKUP_COUNT -gt $MAX_BACKUPS ]; then
  # Delete oldest backups, keep only last 7
  ls -t $BACKUP_DIR | grep $PROJECT_NAME | tail -n +$((MAX_BACKUPS + 1)) | while read old_backup; do
    rm -rf "$BACKUP_DIR/$old_backup"
    print_ok "Deleted old backup: $old_backup"
  done
else
  print_ok "Only $BACKUP_COUNT backups exist — nothing to delete"
fi

# ── STEP 4: Log the backup ────────────────────────

print_title "Logging backup"

mkdir -p ~/devops-practice/logs
echo "$(date) — Backup created: $BACKUP_NAME (${BACKUP_SIZE})" >> ~/devops-practice/logs/backups.log
print_ok "Backup logged"

# ── DONE ─────────────────────────────────────────

echo ""
echo "════════════════════════════════════"
echo "  Backup complete! 💾"
echo "  Location: $BACKUP_DIR/$BACKUP_NAME"
echo "════════════════════════════════════"
echo ""
