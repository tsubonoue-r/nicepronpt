#!/bin/bash
# Local CodeGen Agent - Anthropic API Bypass
# Uses Claude Code directly instead of external API calls

set -e

ISSUE_NUMBER="$1"

if [ -z "$ISSUE_NUMBER" ]; then
  echo "Usage: $0 <issue-number>"
  exit 1
fi

echo "🤖 Local CodeGen Agent - Issue #$ISSUE_NUMBER"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Step 1: Fetch issue details
echo "📋 Fetching issue details..."
ISSUE_DATA=$(gh issue view "$ISSUE_NUMBER" --json title,body,labels)
ISSUE_TITLE=$(echo "$ISSUE_DATA" | jq -r '.title')
ISSUE_BODY=$(echo "$ISSUE_DATA" | jq -r '.body')

echo "Title: $ISSUE_TITLE"
echo "Body: $ISSUE_BODY"
echo ""

# Step 2: Create feature branch
BRANCH_NAME="feature/issue-${ISSUE_NUMBER}"
echo "🌿 Creating branch: $BRANCH_NAME"
git checkout -b "$BRANCH_NAME" 2>/dev/null || git checkout "$BRANCH_NAME"

# Step 3: Signal to Claude Code to generate code
echo "✨ Code generation required..."
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📝 TASK FOR CLAUDE CODE:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Issue #${ISSUE_NUMBER}: ${ISSUE_TITLE}"
echo ""
echo "${ISSUE_BODY}"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Please generate the necessary code files for this issue."
echo "When done, this script will continue with commit and PR creation."
echo ""
read -p "Press Enter when code generation is complete..."

# Step 4: Stage changes
echo "📦 Staging changes..."
git add .

# Step 5: Create commit
echo "💾 Creating commit..."
COMMIT_MSG="feat: ${ISSUE_TITLE}

Implements issue #${ISSUE_NUMBER}

${ISSUE_BODY}

🤖 Generated with Local CodeGen Agent (Claude Code Bypass)

Co-Authored-By: Claude Sonnet 4.5 <noreply@anthropic.com>"

git commit -m "$COMMIT_MSG" || echo "No changes to commit"

# Step 6: Push branch
echo "🚀 Pushing branch..."
git push -u origin "$BRANCH_NAME"

# Step 7: Create PR
echo "📬 Creating Pull Request..."
gh pr create \
  --title "feat: ${ISSUE_TITLE}" \
  --body "$(cat <<EOF
## Summary

Implements #${ISSUE_NUMBER}

## Changes

${ISSUE_BODY}

## Test Plan

- [ ] Manual testing completed
- [ ] Code review passed
- [ ] Quality score ≥80

---

🤖 Generated with Local CodeGen Agent (Claude Code Bypass)
EOF
)" \
  --draft

echo ""
echo "✅ Done! Draft PR created."
echo "🔗 View PR: $(gh pr view --json url -q .url)"
