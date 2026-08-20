#!/bin/bash
# cleanup-unused-ebs.sh - Find unattached EBS volumes (dry-run by default).
# Uncomment the delete line after verifying dependencies and ownership.
set -euo pipefail

echo "Finding unattached EBS volumes..."
VOLUMES=$(aws ec2 describe-volumes \
  --filters Name=status,Values=available \
  --query 'Volumes[*].VolumeId' \
  --output text)

for vol in $VOLUMES; do
  echo "Would delete: $vol"
  # Uncomment to actually delete:
  # aws ec2 delete-volume --volume-id "$vol"
done