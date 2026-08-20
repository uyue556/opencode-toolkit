# MLOps: Remote / Rented GPU Training

Source: `remote-gpu-trainer` (ml-ops).

## When to use
Deploying, monitoring, or troubleshooting long-running GPU jobs on **rented instances you don't
own** — AutoDL, RunPod, vast.ai, Lambda, Paperspace, Chinese platforms (恒源云/矩池云/Featurize/
揽睿星舟), bare SSH boxes, Slurm, or K8s. Triggers: 远程 GPU 训练, GPU 租赁/租卡, spot 抢占,
断点续训 (resumable training), tmux 训练守护, CUDA OOM/显存不足, loss NaN/spike, 多卡训练 hang.
Not for local single-GPU training, or managed multi-cloud shopping (use SkyPilot/Modal).

## Operating principles (the WHY)

1. **Minimize paid wall-clock** — smoke locally on CPU before renting; launch detached; release
   the instant verification passes.
2. **Cheap checks before expensive compute** — a 1–2 batch CPU smoke (logger off) kills
   import/config/shape/scale bugs for ~free.
3. **Trust artifacts you loaded, not log lines that claim success** — "synced/saved/done" lies
   under a silently-failed write; reconcile watcher state against the real process/artifact.
4. **Know what survives stop vs destroy** — per platform, the data you need often lives on the
   volatile mount. This is the single biggest portability trap.
5. **Storage fails on the dimension you're not watching** — disk dies on **inodes** before
   bytes; monitor `df -i`, not just `df -h`; clean by value (keep tiny evidence, drop scratch).
6. **Never mutate inputs under a live run** — a running job holds scripts in memory by
   byte-offset; overwriting mid-run re-executes blocks. Version filenames.
7. **Design for retry** — failure is probabilistic; make wrappers idempotent + resumable; wrap
   bulk transfers in `timeout`+resume loops.
8. **Checkpoint-to-durable + idempotent resume is the universal spine** — file checkpoint to
   durable storage + unconditional load-latest-on-startup survives SSH drops, walltime kills,
   K8s reschedules, spot preemption, and Colab disconnects. The detach primitive
   (tmux/sbatch/Job/commit) is the swappable plug.
9. **Cost and destructive actions are the user's call** — never auto-release/terminate/delete
   without confirmation; if cleanup can't free space, ask to expand the disk.
10. **Teach the user the platform** — surface convenience features and **danger clocks**
    (e.g., AutoDL auto-releases a stopped instance after ~15 days; a "stop" that keeps billing).

## Core 6-phase workflow

| Phase | Action | Verify |
|---|---|---|
| 0. Environment audit | Read profile's storage survival-matrix; `df -h && df -i`, cgroup `memory.max`, `nvidia-smi`; pre-compute checkpoint disk budget | expected GPU + `df -i` not near 100% |
| 1. SSH + credentials | Set alias/env per profile; push secrets via **stdin**, never onto shared/durable FS; the prebuilt image IS the env (don't `conda create` on a rental) | `ssh <alias> 'python -c "import torch;print(torch.cuda.is_available())"'` |
| 2. Wrapper + CPU smoke | Build idempotent `run_one`/`run_queue`; size batch/workers to the box for standalone, PIN them across ablation cells for fair comparison; smoke locally first | smoke exits 0 on 2 batches, logger off |
| 3. Detached launch | Launch via tmux/sbatch/Job; probe log head + alive; never block with a foreground sleep | alive within 60s, first log line shows expected step/epoch |
| 4. Durable monitoring | For >1–2h jobs: four-layer monitoring (on-box self-completion chain + patrol loop + event sentinels + recovery handbook); a session-bound watcher dies with the session | patrol reports even when nothing changed |
| 5. Aggregate + verify + teardown | Checked-sync to durable storage (gate the success line on the copy result), **load-and-verify each artifact**, then stop the meter | verify reports 100% OK BEFORE any teardown |

**Iron Law — teardown gate:** NO `release`/`terminate`/`destroy`/file-delete until checkpoints
are pulled to local AND verified by load, and the user has explicitly approved. "It looked done
in the log" is not evidence.

## Mental verb model

`up` (rent+reach) → `push` (code/data on) → `run` (detached + checkpointing) → `watch` (durable
monitor) → `pull` (results off + verify) → `down` (stop the meter).

## Per-platform facts that bite

| Platform | Survives stop | Survives destroy | Spot grace | China mirror |
|---|---|---|---|---|
| AutoDL | /root + data + FS | FS only | n/a | yes (`/etc/network_turbo`, hf-mirror) |
| RunPod | volume disk (bills 2×) | Network Volume only | ~5s SIGTERM→KILL | no (`hf_transfer`) |
| vast.ai | disk (bills forever) | nothing | ~0s (abrupt) | no |
| Lambda | n/a (no stop) | nothing | n/a (on-demand) | no |
| China platforms | varies; data disk bills | per-platform persistent vol | n/a | yes |
| generic SSH/Slurm/K8s | you own it | you own it | Slurm SIGTERM→KillWait (~30s) | only if in China |

## Top gotchas

1. SSH drops on `pkill -9` (exit 255) — normal; re-ssh to verify, don't panic.
2. tmux holds the script in memory — editing mid-run re-executes blocks; version filenames.
3. Disk-full crashes `torch.save` (`iostream error`) — pre-budget; auto-prune `latest.pth`, keep `best`.
4. cgroup OOM, no traceback (bare `Killed`/exit 137) — `num_workers × big-tensor`; size workers vs `memory.max`.
5. Silent sync failure — `cp … 2>/dev/null; echo synced` lies; gate success on the actual copy result.
6. Spot grace is tiny (~5s → ~0s) — a SIGTERM-flush handler is NOT a safety net; checkpoint on a timer to durable storage, load-latest unconditionally.
7. "Stop" rarely stops the meter — only terminate/destroy does, and it's irreversible.
8. CRLF breaks `.sh` on Linux — `.gitattributes` `*.sh text eol=lf`; on-box `sed -i 's/\r$//'`.

## When training itself breaks (model-level debug layer)

- **OOM (CUDA/VRAM + host RAM):** ladder: grad-accum → bf16 → activation-checkpointing →
  `expandable_segments` → FSDP/ZeRO → CPU/NVMe offload → LoRA/QLoRA. OOM-at-a-specific-step:
  check first backward / validation / longest batch.
- **Distributed launch (torchrun/accelerate/deepspeed):** DDP/FSDP/ZeRO env contract;
  multi-GPU **hangs** usually = one-rank-diverged, rank-conditional collective, or
  dataloader-length mismatch.
- **NaN / loss spikes:** fp16/bf16/tf32 + AMP/GradScaler; `detect_anomaly`; for LLMs check
  warmup, grad clip, init, z-loss.
- **Runs but won't learn:** overfit-one-batch smoke; params-not-updating; optimizer/LR/wd/
  schedule config; loss-function footguns (double-softmax, BCEWithLogits, CE target form);
  frozen-BN drift in fine-tuning.
- **Throughput:** GPU-bound vs data-bound vs comms-bound; dataloader knobs; `torch.compile`
  traps; `torch.profiler`/Nsight.
- **Data pipeline correctness (not speed):** worker-RNG augmentation duplication,
  IterableDataset worker/rank sharding, `set_epoch`, collate/`pin_memory`/`spawn` contracts,
  RGB-vs-BGR, ToTensor ÷255.

## Parallel ablation fan-out

One job per cell, an **isolated write path per job** (no shared mutable output), launched
across instances/queues. Enforce the independence predicate before fanning out (don't fan out
onto shared state); reconcile results after.

## Bundled scripts from source

The upstream skill ships wrapper templates (`run_one`/`run_queue`), monitors (`mem_monitor`,
`gpu_health`, `reap_vram_zombies`), a read-only patrol (`health_patrol.sh.template`), transfer
helpers (`download_loop`, `aggregate_to_fs`, `setup-china-mirrors`), and a load-and-verify
checker (`verify_local.py`). Those are platform-profile specific and were NOT copied here
(see `dedup-notes.md`); reference the upstream `remote-gpu-trainer` repo for the full set.
