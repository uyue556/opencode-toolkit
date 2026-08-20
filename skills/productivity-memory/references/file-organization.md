# File Organization

Restore order to chaotic folders (Downloads, Documents, home) — with a plan and the user's
approval at every destructive step. Rule zero: **never delete without explicit confirmation**;
log every move so it can be undone.

## Workflow

1. **Understand scope.** Which directory? Main problem (can't find things / duplicates / no
   structure)? Any files or folders to avoid (active projects, sensitive data)? How aggressive?
2. **Analyze the current state**:
   ```bash
   ls -la [target]
   find [target] -type f -exec file {} \; | head -20      # file types
   du -sh [target]/* | sort -rh | head -20                # largest files
   find [target] -type f | sed 's/.*\.//' | sort | uniq -c | sort -rn   # type counts
   ```
   Summarize: total files/folders, type breakdown, size distribution, date ranges, issues.
3. **Find duplicates** (only when requested):
   ```bash
   find [dir] -type f -exec md5 {} \; | sort | uniq -d            # exact dups by hash
   find [dir] -type f -printf '%f\n' | sort | uniq -d             # similar names
   find [dir] -type f -printf '%s %p\n' | sort -n                 # similar sizes
   ```
   For each duplicate set show all paths, sizes, dates; recommend which to keep (usually newest
   or best-named); **always ask before deleting.**
4. **Propose a plan** before touching anything: current state → proposed structure → the exact
   list of folders to create, files to move, renames, and deletions → files needing the user's
   decision → "Ready to proceed? (yes/no/modify)".
5. **Execute only after approval.** Preserve original modification dates; handle filename
   conflicts gracefully; stop and ask on anything unexpected.
6. **Report + maintenance cadence**: what changed, the new tree, and a routine — weekly sort new
   downloads, monthly archive completed projects, quarterly re-check duplicates, yearly archive.

## Grouping logic

- **By type**: Documents (PDF/DOCX/TXT), Images, Video, Archives, Spreadsheets, Presentations.
- **By purpose**: Work vs Personal; Active vs Archive; project-specific; reference; temp/scratch.
- **By date**: current year/month, previous years, very old (archive candidates).
- **When to archive**: untouched 6+ months; completed work you may reference later; old versions
  after migration; files you're hesitant to delete — archive first.

## Naming conventions

- Folders: clear, descriptive, no spaces (use hyphens/underscores), specific
  ("client-proposals" not "docs"), numeric prefixes to order ("01-current", "02-archive").
- Files: include dates ("2024-10-17-meeting-notes.md"), descriptive ("q3-financial-report.xlsx"),
  avoid version numbers in names (use version control instead), strip download artifacts
  ("document-final-v2 (1).pdf" → "document.pdf").
