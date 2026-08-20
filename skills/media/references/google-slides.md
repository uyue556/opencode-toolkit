# Google Slides automation

Lightweight Google Slides integration with standalone OAuth — no MCP server. Full read/write access.
**Requires a Google Workspace account**; personal Gmail is not supported.

## Table of Contents

- [Setup & auth](#setup--auth)
- [Read commands](#read-commands)
- [Write commands](#write-commands)
- [Slide layouts](#slide-layouts)
- [Token management](#token-management)

## Setup & auth

First-time authentication opens a browser:

```bash
python scripts/auth.py login       # authenticate
python scripts/auth.py status      # check auth
python scripts/auth.py logout      # logout
```

All operations go through `scripts/slides.py`, which auto-authenticates on first use.

## Read commands

```bash
python scripts/slides.py get-text "1abc123xyz789"                       # all text content
python scripts/slides.py get-text "https://docs.google.com/presentation/d/1abc123xyz789/edit"
python scripts/slides.py find "quarterly report" --limit 5              # search presentations
python scripts/slides.py get-metadata "1abc123xyz789"                   # title, slide count, object IDs
```

Presentations can be addressed by bare ID or full URL — the scripts extract the ID automatically.

## Write commands

```bash
python scripts/slides.py create "Q4 Sales Report"                       # new empty deck
python scripts/slides.py add-slide "1abc123xyz789" --layout TITLE_AND_BODY
python scripts/slides.py add-slide "1abc123xyz789" --layout TITLE --at 0    # 0-based position
python scripts/slides.py replace-text "1abc123xyz789" "Draft" "Final" --match-case
python scripts/slides.py delete-slide "1abc123xyz789" "g123abc456"          # by object ID (get-metadata)
python scripts/slides.py batch-update "1abc123xyz789" \
  '[{"replaceAllText":{"containsText":{"text":"foo"},"replaceText":"bar"}}]'
```

`batch-update` is the advanced path for formatting, inserting shapes/images, and complex edits (accepts raw
Slides API `batchUpdate` request objects).

## Slide layouts

`BLANK` (default), `TITLE`, `TITLE_AND_BODY`, `TITLE_AND_TWO_COLUMNS`, `TITLE_ONLY`, `SECTION_HEADER`,
`ONE_COLUMN_TEXT`, `MAIN_POINT`, `BIG_NUMBER`.

## Output shapes

- `get-text`: presentation title + text from every shape/text box + table cell contents.
- `find`: `{"presentations":[{"id","name","modifiedTime"}],"nextPageToken"}`.
- `get-metadata`: `{presentationId, title, slideCount, pageSize, hasMasters, hasLayouts}`.

## Token management

Tokens are stored in the OS keyring (macOS Keychain / Windows Credential Locker / Linux Secret Service under
service `google-slides-skill-oauth`) and auto-refresh expired tokens via Google's cloud function.