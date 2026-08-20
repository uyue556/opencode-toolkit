# Performance Troubleshooting (USE + TSA)

Source: `brendangregg-use-tsa` (devops), `application-performance-performance-optimization`
(reliability), `devops-troubleshooter` (devops), `server-management` (reliability).

## When to use
A server/VM/container is "slow" with unknown cause; latency/throughput regressed after a
deploy; metrics look abnormal; an app hangs or threads pile up; an incident needs an evidence-
backed RCA.

## Step 0 — Problem statement before measuring

Ask: what makes you think there's a problem? Has it ever performed well? What changed recently
(software, hardware, load)? Can it be expressed as latency/run time — quantify it? Who else is
affected? What's the environment (OS, versions, config, container/VM limits)?

## Step 1 — 60-second triage (Linux)

Check **errors and saturation first**, then utilization. Record every exonerated resource.

```bash
uptime                 # load trend (Linux load includes uninterruptible I/O)
dmesg | tail           # kernel errors: oom-killer, SYN flooding, hardware
vmstat 1               # r > CPU count = CPU saturation; si/so = swapping; wa = disk
mpstat -P ALL 1        # per-CPU imbalance (single hot CPU = single-threaded app)
pidstat 1              # per-process CPU over time
iostat -xz 1           # await (app-suffered latency), avgqu-sz, %util
free -m                # memory; buffers/cache near zero hurts
sar -n DEV 1           # NIC throughput vs link limit
sar -n TCP,ETCP 1      # active/passive connections, retransmits
top                    # spot variable load
```

## Step 2 — USE sweep (resource-oriented)

For **every** resource (CPU, memory, network, disk, controllers, plus software resources like
locks/pools/FD capacity and imposed limits like cgroup quotas/ulimits): check **Utilization,
Saturation, Errors** — errors before utilization.
- 100% utilization is usually a bottleneck (confirm via saturation).
- Any non-zero saturation can be a problem.
- Non-zero, still-increasing error counters are worth investigating.
- A clean sweep is a result: it narrows the search space.

## Step 3 — TSA sweep (thread-oriented)

For each thread of interest, split time into **Executing / Runnable / Anonymous Paging /
Sleeping / Lock / Idle**. Investigate most-frequent first. If > ~10% Runnable or Paging, fix
those first — they can be tuned toward zero.
- Runnable: `/proc/PID/schedstat` run_delay, `perf sched latency`.
- Paging: `vmstat` si/so, per-process `min_flt`.
- Sleeping: `offcputime`/`cpudist` (bcc).
- Lock: `/proc/lock_stat`, `valgrind --tool=drd`.
- Executing: `pidstat`/flame graphs.

## Step 4 — Drill down

Follow the biggest contributor: Executing → CPU profile + flame graph; Sleeping/Lock → off-CPU
stacks (`offcputime -p PID`, render with `flamegraph.pl --color=io`); latency complaints →
time decomposition; microservices → RED method. Prefer eBPF in-kernel aggregation over
per-event dumps; start with sub-second traces in production.

## Step 5 — Confirm root cause

State the causal chain (trigger → mechanism → symptom) with every link evidenced. Ask "why" up
to five times. Would removing this cause prevent recurrence? Does it explain all primary
evidence?

## Step 6 — Fix and verify

Apply the cheapest effective fix (mantra: don't do it → cache it → do it less → do it later →
off-peak → concurrently → cheaper). Re-measure with the **same instruments** and show
before/after. "Deployed" is not "verified".

## Common signatures

- **Linux load looks high but CPUs idle** → load includes uninterruptible disk tasks; check
  `vmstat` "r" and `iostat` await.
- **Host CPU fine but app starves** → check resource controls: cgroup `cpu.max` and
  `cpu.stat nr_throttled` (Runnable-dominant TSA on an idle host is the tell).
- **"Time spent in MySQL"** → component timers are request-oriented; run TSA on threads — the
  time may be Runnable (noisy neighbor), not execution.
- **Off-CPU stacks polluted** → filter involuntary switches: `offcputime --state 2`
  (TASK_UNINTERRUPTIBLE); fix frame pointers (`-fomit-frame-pointer` breaks user stacks).
- **OOM with no traceback (exit 137)** → cgroup OOM; size workers vs `memory.max`, not CPU count.

## App-level performance optimization

Only after systemic bottlenecks are ruled out:
- Profile first, then tune: flame graphs for CPU, heap dumps for memory, query plans for DB.
- Database: indexes, N+1 elimination, connection pooling, slow-query analysis, caching.
- Backend/API: batching, pagination, caching (with correct invalidation), async/queue where
  appropriate.
- Frontend: bundle size, lazy load, CDN/edge, image optimization, Core Web Vitals.
- Load test with production-like traffic; establish a baseline before optimizing; set
  regression thresholds in CI.
- Continuous: production monitoring + performance regression detection (change-point analysis).

## Troubleshooting priority (server ops)

Check if it's running → logs → resources (disk/memory/CPU) → network (ports/DNS) →
dependencies (DB/APIs). Read-only diagnostics first; any remediation requires explicit
confirmation.
