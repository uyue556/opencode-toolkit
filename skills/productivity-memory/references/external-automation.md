# External Service Automation

Automating external SaaS tools (files, scheduling, e-signature, email, calendar) and
messaging. Two patterns dominate: **Rube MCP (Composio) toolkits** for most SaaS, and
**standalone OAuth CLIs** for Gmail/Google Calendar. Telegram covers phone notifications and
approval flows.

## Rube MCP (Composio) pattern — Box, Dropbox, OneDrive, Cal.com, Calendly, DocuSign

All these skills share one anatomy; learn it once and apply per service:

- **Prerequisites**: Rube MCP server configured with the service's Composio toolkit connected.
- **Always search the tool schemas first** before calling: tool signatures change; never assume
  the argument shape from memory.
- **ID resolution is the #1 common step**: list → pick the id (object, folder, event, template)
  → operate on that id. Pass ids, not display names, to mutation calls.
- **Pagination**: list calls are paged; loop or use the page token until you've gathered
  everything, rather than assuming a single response.
- **Async operations**: some uploads/sign requests return immediately while processing in the
  background — poll status endpoints rather than assuming completion.
- **Rate limits**: throttle batch loops; back off on 429s.
- **Parameter quirks** differ per service (path vs id; URI formats; nested params; timezones).
  Read the returned error, don't guess.

Per-service quick reference:

| Service | Core workflows | Watch out for |
|---|---|---|
| Box | upload/download, search, folder mgmt, collaboration, metadata queries, sign requests | ID formats, nested params |
| Dropbox | search, upload/download, share/links, folders, list contents | path formats, async ops |
| OneDrive | search/browse, upload/download, share + permissions, folders, change tracking | path vs ID, search limits |
| Cal.com | bookings, availability, webhooks, teams, org admin | booking flow, ID resolution |
| Calendly | events, invitees, scheduling links + availability, cancel, org/invitations | URI formats, scopes |
| DocuSign | templates, envelopes from templates, status monitoring, lifecycle | template role mapping, envelope status flow |

Generic workflow: connect → search tools → resolve IDs → perform the operation with paged,
rate-limited calls → confirm with a read-back or status check.

## Standalone Gmail integration

No MCP server; lightweight CLI with standalone OAuth. First-time setup is OAuth (google-auth
flow, token cached locally). Capabilities:

- **Search**: Gmail query syntax; filter by label; include spam/trash when asked.
- **Read**: full content, metadata (headers) only, or minimal (IDs only).
- **Send**: simple, with CC/BCC, from alias (must be configured in Gmail settings), HTML.
- **Drafts**: create, send existing.
- **Labels**: mark read/unread, archive, star/unstar, important, multiple label changes at once.
- **List labels.**

Treat the OAuth token as a secret; keep it out of logs and commits.

## Standalone Google Calendar integration

Same standalone-OAuth approach. Capabilities:
- **List calendars**; **list events** (default next 30 days; time-range, specific calendar, limit).
- **Get event details**; **create** events (basic / with description+location / attendees /
  specific calendar).
- **Update** title, time, multiple fields, attendees; **delete** events.
- **Find free time**: 30-min slot for self, 60-min slot with multiple attendees.
- **Respond to invitations**: accept / decline / tentative / without notifying organizer.

## Telegram bot messaging

Pure bash + curl + jq; no install beyond a bot token. First run: `scripts/telegram.sh setup`
(BotFather walkthrough).

- `send "msg"` (with `--silent`, `--format md`), `send --to <target> --bot <bot>`,
  `file report.pdf "Q3 report"`, `read` (new incoming messages), and
  `ask "Deploy to prod?" --options "Yes,No" --timeout 300`
  (exit 0 = answered, stdout = answer; exit 2 = timeout) for approval flows.
- Config via env vars or `~/.config/telegram/config` (mode 600): bot tokens, default chat
  targets, approver user IDs.
- **Safety gate**: get explicit approval for target chat, bot, and content before sending.
  Never auto-send workspace/customer/credential/secret data. Replies only accepted from
  configured chat IDs; `ask` fails closed for groups unless approver IDs are set.
- Wire into hooks: "notify when Claude needs input / finished" via settings.json hooks; gate
  deploy scripts with an inline ask-and-wait.
- Telegram is a third-party service — message content leaves the machine. Tokens grant control
  of the bot: store in a protected local store, rotate on suspicion.
