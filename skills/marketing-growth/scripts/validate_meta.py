#!/usr/bin/env python3
# Pre-deploy meta validation gate for tool/product/feature page sites.
# Usage: python3 validate_meta.py
# Reads data/tools.json (adapt path) and fails if any entry has a missing/too-long
# title or a missing/short/long description. Carried from tools-page-seo-optimizer.
import json, sys

tools = json.load(open('data/tools.json'))
errors = []

for t in tools:
    slug  = t.get('slug', '?')
    title = t.get('meta_title', '')
    desc  = t.get('meta_description', '')
    if not title:          errors.append(f"MISSING TITLE: {slug}")
    elif len(title) > 60:  errors.append(f"TITLE TOO LONG ({len(title)}): {slug}")
    if not desc:           errors.append(f"MISSING DESC: {slug}")
    elif len(desc) < 120:  errors.append(f"DESC TOO SHORT ({len(desc)}): {slug}")
    elif len(desc) > 160:  errors.append(f"DESC TOO LONG ({len(desc)}): {slug}")

if errors:
    print('\n'.join(errors)); sys.exit(1)
print(f"All {len(tools)} tools passed meta validation")
