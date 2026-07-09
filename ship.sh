#!/bin/bash
set -e

# ship.sh — automated commit -> push -> PR -> CI wait -> merge pipeline
#
# Usage:
#   ./ship.sh "commit message"
#   ./ship.sh "commit message" branch-name
#
# Requires: git, gh (authenticated via `gh auth login`)

COMMIT_MSG="${1:-"chore: automated update"}"
BASE_BRANCH="main"
BRANCH_NAME="${2:-auto/$(date +%Y%m%d-%H%M%S)}"

echo "==> Checking git status"
if [ -z "$(git status --porcelain)" ]; then
    echo "Nothing to commit. Exiting."
    exit 0
fi

echo "==> Creating branch: $BRANCH_NAME"
git checkout -b "$BRANCH_NAME"

echo "==> Staging and committing changes"
git add -A
git commit -m "$COMMIT_MSG"

echo "==> Pushing branch to origin"
git push -u origin "$BRANCH_NAME"

echo "==> Creating pull request"
PR_URL=$(gh pr create \
    --title "$COMMIT_MSG" \
    --body "Automated PR created by ship.sh" \
    --base "$BASE_BRANCH" \
    --head "$BRANCH_NAME")

echo "PR created: $PR_URL"

echo "==> Waiting for CI checks to complete"
# --watch blocks until all checks finish; exits non-zero if any check fails
if gh pr checks "$PR_URL" --watch; then
    echo "==> All checks passed. Merging PR"
    gh pr merge "$PR_URL" --squash --delete-branch --auto
    echo "==> Done. PR merged (or queued for auto-merge if branch protection requires it)."
else
    echo "==> CI checks failed. PR left open for review: $PR_URL"
    exit 1
fi
