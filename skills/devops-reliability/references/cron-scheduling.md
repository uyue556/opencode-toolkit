# Cron & Schedule Validation

Source: `cron-doctor` (devops).

## When to use
Writing, editing, reviewing, or deploying any cron expression — crontab, Kubernetes `CronJob`,
GitHub Actions `schedule`, Airflow DAG, Celery beat, systemd timer — or debugging a job that
"didn't fire" / "fired at the wrong time".

## The problem

Cron failure is **silent**: a syntactically valid expression that never fires, or fires far more
often than intended. `crontab -l` only checks syntax, not semantics.

## The five cron death-traps

1. **Impossible dates — never fires.**
   `0 0 30 2 *` parses fine and never fires (Feb has no 30th). Same for day 31 in 30-day months.
   Fix: `0 0 28-31 * *` + end-of-month check in the script, or `L` where supported.

2. **OR-semantics — fires too often.**
   `0 0 1,15 * 1` does NOT mean "1st and 15th if Monday" — when **both** day-of-month and
   day-of-week are restricted, cron ORs them: "1st, 15th, OR every Monday" (~6 fires/mo vs ~2).
   Fix: run daily and guard in-script:
   ```bash
   0 0 * * 1 [ "$(date +%d)" = "01" -o "$(date +%d)" = "15" ] && your-command
   ```

3. **Midnight spike — everything at once.**
   Every `0 0 * * *` job competes at exactly 00:00 (backups, rotations, cert renewals).
   Fix: stagger — `17 2 * * *` or `43 3 * * *`. Jitter is your friend.

4. **Uneven steps — drift.**
   `*/7 * * * *` is NOT "every 7 minutes evenly" — it resets at 60: 0,7,...,56, then a 4-minute
   gap. Fix: use step values that divide 60 (`*/5`, `*/10`, `*/15`, `*/20`, `*/30`), or a
   loop with `sleep 420`.

5. **Leap-year Feb 29 — annual surprise.**
   `0 0 29 2 *` fires only on leap years. Fix: `0 0 28 2 *` + handle the 29th in-script.

## Validation engine

This skill ships a zero-dependency cron engine (`scripts/cron-engine.js`, Node.js, no npm
install) that parses, describes in plain English, deep-validates the traps above, and computes
next fire times:

```javascript
const { describe, validate, nextRuns, formatNextRuns } = require('./scripts/cron-engine.js');
const d = describe('0 0 30 2 *');          // "At 00:00, on day-of-month 30 in FEB"
const result = validate('0 0 30 2 *');     // valid syntax + observations ("never fires")
const runs = nextRuns('0 9 * * 1-5', new Date(), 5);
console.log(formatNextRuns(runs, new Date()));
```

```bash
node scripts/cli.js describe "*/5 * * * *"
node scripts/cli.js validate "0 0 30 2 *"
node scripts/cli.js next "0 9 * * 1-5" 5
```

Always give the user a plain-English description AND run the trap checklist; report next-5 fire
times so the schedule can be eyeballed against intent.

## Field reference

| Field | Pos | Range | Notes |
|---|---|---|---|
| minute | 1 | 0–59 | |
| hour | 2 | 0–23 | |
| day-of-month | 3 | 1–31 | |
| month | 4 | 1–12 | JAN–DEC accepted |
| day-of-week | 5 | 0–7 | 0 and 7 = Sunday; SUN–SAT accepted |

## Common presets

| Expression | Meaning | Use |
|---|---|---|
| `*/5 * * * *` | every 5 min | health checks, polling |
| `0 * * * *` | hourly | aggregation |
| `0 2 * * *` | 2am daily | off-peak batch (avoid midnight) |
| `0 9 * * 1-5` | 9am Mon–Fri | business-hours task |
| `0 0 1 * *` | midnight 1st | monthly report |

## Best practices

- ✅ Describe in plain English + run the trap checklist + show next runs and annual fire count
  (365×/yr vs 12×/yr is a ~30× cost/load difference).
- ✅ Stagger midnight jobs; prefer step values that divide 60.
- ✅ Comment intent above every crontab line; set an explicit timezone (`CRON_TZ`) — K8s
  CronJob and GitHub Actions default to UTC.
- ❌ Don't trust `crontab -l` validation (syntax only).
- ❌ Don't restrict both day-of-month and day-of-week without confirming OR-logic.
- ❌ Don't schedule everything at `0 0`.

## Pitfall fixes

- "Job isn't running": impossible date (trap 1), daemon down (`systemctl status crond`), file
  missing trailing newline / wrong ownership.
- "Runs far more often": OR-semantics (trap 2). Move one field to `*` or guard in-script.
- "Intervals uneven": step doesn't divide 60 (trap 4).
- "Works locally, not in cluster": timezone — set `timeZone`/`TZ` explicitly.
