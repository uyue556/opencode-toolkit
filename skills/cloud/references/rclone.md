# rclone — Cloud Storage CLI

Condensed from `rclone-cli` (chaunsin/agent-skills, Apache-2.0), which was itself converted
from the official rclone Hugo docs. The original skill ships a full reference tree
(usage.md, flags.md, filtering.md, bisync.md, rc.md, crypt.md, cache.md, chunker.md,
union.md, combine.md, hasher.md, overview.md, install.md, docker.md, faq.md, `commands/`,
`providers/`) — those are ~2.3 MB of converted official docs and are **not** reproduced
here; consult https://rclone.org/docs/ instead.

## Security first

rclone can irreversibly modify/delete cloud data:

- **Always `--dry-run` first** for `sync`/`move`/`delete`/`purge`; `-i/--interactive` while
  learning.
- `rclone sync` **deletes** dest files not in source; `rclone purge` ignores all filters.
- Never put credentials on the command line; `rclone config` stores them; protect
  `~/.config/rclone/rclone.conf` (`chmod 600`); never commit tokens.
- Remote-control API (`--rc`) must bind localhost and use `--rc-htpasswd`.
- Mounts: use `--vfs-cache-mode full` for safer writes.

## Setup & config

```bash
rclone --version                      # if missing: curl https://rclone.org/install.sh | sudo bash
rclone config                         # interactive wizard
rclone config show                    # redacts secrets; --redacted=false reveals them (dangerous)
rclone config create myremote s3 provider=AWS env_auth=true region=us-east-1
rclone config update myremote region=us-west-2
rclone listremotes
```

Syntax: `rclone subcommand [options] source:path dest:path` (`remote:path` = remote, plain
path = local).

## Core commands

```bash
rclone ls/lsd/lsl/lsf/lsjson remote:path   # list (sizes, dirs, flexible)
rclone size remote:path ; rclone tree remote:path
rclone copy /local remote:path             # copy, no delete at dest
rclone sync --dry-run /local remote:path   # makes dest identical (DELETES extras) — dry-run first
rclone move /local remote:path             # copy then delete source
rclone delete remote:path                  # delete contents
rclone purge remote:path                   # delete path + contents (ignores filters!)
rclone check /local remote:path            # integrity compare
rclone dedupe remote:path                  # find/delete duplicates
rclone about remote:                       # quota
rclone cat remote:path/file.txt
```

## Filtering

```bash
rclone copy /src /dst --include "*.jpg" --include-from file.txt
rclone copy /src /dst --exclude "*.tmp" --exclude-from file.txt
rclone sync /src /dst --filter "+ *.jpg" --filter "- *"    # mix rules with --filter only
rclone copy /src /dst --min-size 1M --max-size 10G --min-age 7d --max-age 30d
```

Patterns: `*` non-separator run, `**` any depth, `?` single char, `{a,b}` alternation,
`{{regexp}}` Go regexp. **Don't mix `--include`/`--exclude`/`--filter`.**

## Key flags

`-v/-vv/--log-level` · `--dry-run` · `-i/--interactive` · `--ignore-existing` ·
`-I/--ignore-times` · `--transfers N` (default 4) · `--checkers N` (8) · `--bwlimit 10M` ·
`--max-transfer SIZE` · `-c/--checksum` · `--size-only` · `--multi-thread-streams N` (4) ·
`-P/--progress` · `--config PATH`.

## Mount & serve

```bash
rclone mount remote:path /mnt/remote --vfs-cache-mode full --vfs-cache-max-size 10G
fusermount -u /mnt/remote
rclone serve http|webdav|sftp|ftp|s3|dlna|restic|docker remote:path
```

## Crypt (encrypted remote)

Wrap any remote with a `crypt` remote (`rclone config`), then use it transparently:
`rclone copy /local/files crypt:path`; verify with `rclone cryptcheck crypt:path`.

## Common workflows

```bash
# Backup local → cloud (dry-run then real)
rclone sync --dry-run -P /home/user/docs remote:backup/docs && rclone sync -P /home/user/docs remote:backup/docs
# Cloud → cloud migration (server-side when possible)
rclone copy -P --transfers 8 src_remote:path dst_remote:path
# Bandwidth-limited
rclone copy --bwlimit 10M -P /data remote:backup
# Scheduled (cron)
0 2 * * * rclone sync -P /data remote:backup >> /var/log/rclone.log 2>&1
```

Provider configs (S3, Google Drive, Dropbox, OneDrive, Azure Blob, B2, GCS, SFTP, WebDAV,
Swift, FTP, +60 more): each has an official page at `https://rclone.org/<name>/`.
