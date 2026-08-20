# Debugging Methodology

Source: `diagnose-android-overheating` (systematically generalized from its evidence-based ADB
diagnosis workflow). Use whenever a problem is hard to reproduce, intermittent, or has many
possible causes. Applies to devices, servers, services, and code.

## 1. Diagnostic contract (before collecting data)

1. Confirm you are authorized to inspect the target.
2. Ask what the symptom means precisely: location/component, activity, state, onset, duration,
   and whether it also occurs under no load.
3. Record environment: model/version, recent changes, dependencies, ambient conditions, visible
   warnings.
4. State that the observation tooling itself can perturb behavior (e.g., a USB cable charges and
   warms a phone; an attached profiler changes timing). Use the least invasive capture and compare
   with/without the tool.
5. If multiple targets exist (multi-device, multi-host), select the specific one — never assume
   the first listed is the intended one.

## 2. Capture an untouched baseline

Before resetting anything (logs, caches, counters), force-stopping services, or changing settings,
preserve the initial state:

- Read-only status: version/build, uptime, load/CPU, temperature/battery state, process list,
  resource usage, current config values.
- If a service or field is unavailable, record that limitation. **Do not turn missing output into
  a healthy verdict.** OEM/vendor builds expose different services and fields.

## 3. Choose the evidence branch (narrow the search)

Collect only the branches matching the symptom:

- idle symptom → background activity: alarms, jobs, sensors, location, network.
- during load → process CPU, memory, I/O, per-resource activity.
- after a change → capture current values and compare with known previous state before proposing
  rollback.
- at scale/spike → throughput, queue depth, latency percentiles, connection pools.

Do not collect a full dump (bug report / full trace) unless narrow evidence is insufficient —
they can contain sensitive data (account identifiers, personal activity, network details).

## 4. Reproduce with a controlled comparison

Define **one pass/fail comparison** before changing anything. Keep everything else constant
(workload, duration, environment, starting state). Timestamp every observation. Avoid synthetic
load unless explicitly requested and the system isn't already degraded.

Good comparisons: with feature X vs without; full load vs idle; after restart vs before; current
config vs previous known-good; on network A vs network B.

## 5. Correlate — do not guess

Require **at least two independent signals** before attributing cause:

- severity/trend + sustained process CPU
- change in resource + relevant activity
- symptom while idle + persistent background activity
- symptom during a specific state + state/current evidence + a cooler/lighter comparison
- throttling + a workload-specific subsystem

A single hot reading doesn't identify the cause. A high-CPU snapshot doesn't prove sustained load.
A named background process doesn't prove meaningful cost without duration and timeline correlation.

## 6. Classify the finding

Use one primary class and list plausible contributors separately: resource load; network/radio
loop; transfer/streaming; media/GPU; sensors/GPS/location polling; charging/power equipment;
OS/service residue or post-update optimization; hardware aging; normal workload; insufficient
evidence.

State confidence as `confirmed`, `strongly supported`, `possible`, or `unknown`. Reserve
`confirmed` for a controlled comparison or direct timeline evidence that changes with the
suspected cause.

## 7. Gate every intervention

- Present evidence and the proposed experiment **before** changing anything.
- Read-only inspection may proceed within the authorized scope.
- Interruptive actions (stopping a process, changing connectivity) require awareness and must not
  disrupt critical functions (auth, navigation, notifications, alarms).
- Persistent changes (config, disabling features, debloating, dev options) require explicit
  approval, an exact pre-change value, a rollback command, and post-change verification.
- Never disable safety/thermal protection, spoof status, or use generic "optimizations" as
  root-cause fixes.
- **Change one variable at a time.** After the test, restore the old value unless the user chooses
  to keep the verified change.

## 8. Output format

```
Symptom and context:
Safety status:
Evidence collected:
Controlled comparison:
Most likely cause:
Confidence:
Contributors or alternatives:
Proposed next test or smallest fix:
Approval required:
Rollback:
Remaining uncertainty:
```

## 9. Best practices

- Preserve raw output before filtering (labels/field layouts vary).
- Prefer trends and before/after windows over single snapshots.
- Separate surface symptom, internal state, and framework-reported severity.
- Keep a record of every mutation and its original value.
- Redact serials, usernames, IDs, SSIDs, personal identifiers, and notification content before
  sharing logs.
- Escalate persistent unexplained issues to hardware/vendor support when software evidence is
  weak.

## 10. Common pitfalls

- Filtering verbose output down to one word and losing the important parts.
- Calling the top-CPU process the cause from one sample — sample across the symptom window.
- Resetting counters/logs immediately — save the pre-existing history first.
- Applying several "optimizations" together — test one reversible hypothesis at a time and verify
  the symptom, not just the setting.
- Treating missing vendor data as evidence of no problem — report the blind spot and use an
  independent comparison or escalate.