#!/usr/bin/env python3
"""Flatten a yt-dlp json3 subtitle file into a single clean .txt file.

Copied from the youtube-transcript source skill. yt-dlp must be run with
--sub-format json3 (never VTT/SRT: auto-VTT repeats every line twice).

Usage:
    yt-dlp --skip-download --write-subs --write-auto-subs \
        --sub-langs "en.*" --sub-format json3 -o "$OUT/$NAME.%(ext)s" "URL"
    python3 yt_json3_to_txt.py <output_dir> [out.txt]
"""
import json
import html
import re
import glob
import sys
import pathlib


def main():
    if len(sys.argv) < 2:
        sys.exit(__doc__)
    out_dir = sys.argv[1]
    files = glob.glob(str(pathlib.Path(out_dir) / "*.json3"))
    if not files:
        sys.exit("no json3 file found")
    data = json.load(open(files[0], encoding="utf-8"))
    parts = [
        "".join(s.get("utf8", "") for s in e.get("segs") or [])
        for e in data.get("events", [])
    ]
    txt = re.sub(
        r"\s+", " ", html.unescape(" ".join(p.strip() for p in parts if p.strip()))
    ).strip()
    out = pathlib.Path(sys.argv[2]) if len(sys.argv) > 2 else pathlib.Path(files[0]).with_suffix(".txt")
    out.write_text(txt, encoding="utf-8")
    print(out)


if __name__ == "__main__":
    main()
