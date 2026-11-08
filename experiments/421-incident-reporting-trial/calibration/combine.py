#!/usr/bin/env python3
"""Combine the saved C01 and C02 turn exports without model calls."""
import csv
import pathlib

ROOT = pathlib.Path(__file__).resolve().parent
OUT = ROOT / "combined"
OUT.mkdir(exist_ok=True)
for name in ("results.csv", "usage.csv"):
    records = []
    fields = None
    for case in ("c01-comparison", "c02-comparison"):
        with (ROOT / case / name).open(newline="", encoding="utf-8") as source:
            reader = csv.DictReader(source)
            if fields is not None and fields != reader.fieldnames:
                raise ValueError("CSV columns differ between cases")
            fields = reader.fieldnames
            records.extend(reader)
    with (OUT / name).open("w", newline="", encoding="utf-8") as output:
        writer = csv.DictWriter(output, fieldnames=fields)
        writer.writeheader()
        writer.writerows(records)
