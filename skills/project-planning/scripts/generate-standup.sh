#!/bin/bash
# generate-standup.sh - AI-powered standup note generator
# Source: team-collaboration-standup-notes/resources/implementation-playbook.md
# Requires: git, jq, and optionally jira CLI, obsidian MCP tool, gcal, slack-cli, claude-ai.
# Optional integrations fail gracefully if the CLI/MCP tool is absent.

DATE=$(date +%Y-%m-%d)
USER=$(git config user.name)
USER_EMAIL=$(git config user.email)

echo "🤖 Generating standup note for $USER on $DATE..."

# 1. Collect Git commits
echo "📊 Analyzing Git history..."
COMMITS=$(git log --author="$USER" --since="24 hours ago" \
  --pretty=format:"%h|%s|%cr" --no-merges)

# 2. Query Jira (requires jira CLI; skip if absent)
JIRA_DONE="[]"
JIRA_PROGRESS="[]"
if command -v jira >/dev/null 2>&1; then
  echo "🎫 Fetching Jira tickets..."
  JIRA_DONE=$(jira issues list --assignee currentUser() \
    --jql "status CHANGED TO 'Done' DURING (-1d, now())" \
    --template json 2>/dev/null || echo "[]")
  JIRA_PROGRESS=$(jira issues list --assignee currentUser() \
    --jql "status = 'In Progress'" \
    --template json 2>/dev/null || echo "[]")
fi

# 3. Get Obsidian recent changes (via MCP, optional)
OBSIDIAN_CHANGES="[]"
if command -v obsidian_get_recent_changes >/dev/null 2>&1; then
  echo "📝 Checking Obsidian vault..."
  OBSIDIAN_CHANGES=$(obsidian_get_recent_changes --days 2)
fi

# 4. Get calendar events (optional)
MEETINGS="[]"
if command -v gcal >/dev/null 2>&1; then
  echo "📅 Fetching calendar..."
  MEETINGS=$(gcal --today --format=json)
fi

# 5. Send to AI for analysis and generation
echo "🧠 Generating standup note with AI..."
cat << EOF > /tmp/standup-context.json
{
  "date": "$DATE",
  "user": "$USER",
  "commits": $(echo "$COMMITS" | jq -R -s -c 'split("\n")'),
  "jira_completed": $JIRA_DONE,
  "jira_in_progress": $JIRA_PROGRESS,
  "obsidian_changes": $OBSIDIAN_CHANGES,
  "meetings": $MEETINGS
}
EOF

STANDUP_NOTE=$(claude-ai << 'PROMPT'
Analyze the provided context and generate a concise daily standup note.

Instructions:
- Group related commits into single accomplishment bullets
- Link commits to Jira tickets where possible
- Extract business value from technical changes
- Format as: Yesterday / Today / Blockers
- Keep bullets concise (1-2 lines each)
- Include relevant links to PRs and tickets
- Flag any potential blockers based on context

Context: $(cat /tmp/standup-context.json)

Generate standup note in markdown format.
PROMPT
)

# 6. Save draft to Obsidian (create dir if missing)
mkdir -p ~/Obsidian/Standup\ Notes
echo "$STANDUP_NOTE" > ~/Obsidian/Standup\ Notes/$DATE.md

# 7. Present for human review
echo "✅ Draft standup note generated!"
echo ""
echo "$STANDUP_NOTE"
echo ""
read -p "Review the draft above. Post to Slack? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]] && command -v slack-cli >/dev/null 2>&1; then
    # 8. Post to Slack
    slack-cli chat send --channel "#standup" --text "$STANDUP_NOTE"
    echo "📮 Posted to Slack #standup channel"
fi

echo "💾 Saved to: ~/Obsidian/Standup Notes/$DATE.md"
