#!/bin/bash
# cleanup-old-snapshots.sh - List EBS snapshots older than 90 days (dry-run by default).
# Verify no compliance requirement retains them before actually deleting.
set -euo pipefail

CUTOFF_DATE=$(date -d '90 days ago' --iso-8601)

aws ec2 describe-snapshots --owner-ids self \
  --query "Snapshots[?StartTime<='$CUTOFF_DATE'].[SnapshotId,StartTime,VolumeSize]" \
  --output text | while read -r snap_id start_time size; do

  echo "Snapshot: $snap_id (Created: $start_time, Size: ${size}GB)"
  # Uncomment to delete:
  # aws ec2 delete-snapshot --snapshot-id "$snap_id"
done