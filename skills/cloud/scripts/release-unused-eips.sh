#!/bin/bash
# release-unused-eips.sh - List unassociated Elastic IPs (dry-run by default).
# Check DNS records before releasing; EIPs without an AssociationId cost money.
set -euo pipefail

aws ec2 describe-addresses \
  --query 'Addresses[?AssociationId==null].[AllocationId,PublicIp]' \
  --output text | while read -r alloc_id public_ip; do

  echo "Would release: $public_ip ($alloc_id)"
  # Uncomment to release:
  # aws ec2 release-address --allocation-id "$alloc_id"
done