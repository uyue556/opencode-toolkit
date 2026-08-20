#!/usr/bin/env python3
"""calculate-savings.py - Estimate monthly savings from EBS + EIP cleanup.

Read-only. Run before any cleanup to quantify the opportunity and to
justify the change to stakeholders. Prices are example values - adjust
to current regional list prices.
"""
import boto3

ec2 = boto3.client("ec2")

# EBS volume savings (gp3 example: $0.10/GB-month)
volumes = ec2.describe_volumes(
    Filters=[{"Name": "status", "Values": ["available"]}]
)
total_size = sum(v["Size"] for v in volumes["Volumes"])
monthly_cost = total_size * 0.10

# Elastic IP savings ($0.005/hour x 730 hours = $3.65/month each)
addresses = ec2.describe_addresses()
unused = [a for a in addresses["Addresses"] if "AssociationId" not in a]
eip_cost = len(unused) * 3.65

print(f"Unattached EBS Volumes: {len(volumes['Volumes'])}")
print(f"Total Size: {total_size} GB")
print(f"Monthly Savings: ${monthly_cost:.2f}")
print(f"\nUnused Elastic IPs: {len(unused)}")
print(f"Monthly Savings: ${eip_cost:.2f}")
print(f"\nTotal Monthly Savings: ${monthly_cost + eip_cost:.2f}")
print(f"Annual Savings: ${(monthly_cost + eip_cost) * 12:.2f}")