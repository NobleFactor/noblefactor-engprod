#!/usr/bin/env python3
"""Prepare C02 with the C01 preparation code and retriever, without a model call."""
import importlib.util
import hashlib
import json
import pathlib

ROOT = pathlib.Path(__file__).resolve().parent
C01_PREPARE = ROOT.parent / "c01-comparison" / "prepare.py"
spec = importlib.util.spec_from_file_location("c01_prepare", C01_PREPARE)
module = importlib.util.module_from_spec(spec)
spec.loader.exec_module(module)
module.ROOT = ROOT
module.CASE = ROOT.parent.parent / "sample-review" / "inputs" / "C02.json"
module.HASH = "b559beb95ea669122c1b9df70bffd8c4133efc212f96b8c355328611c5e97a7c"

# The saved C02 input hash is checked against the original sample manifest.
manifest = json.loads((ROOT.parent.parent / "sample-review" / "manifest.json").read_text())
if module.HASH != next(item["sha256"] for item in manifest["inputs"] if item["case_id"] == "C02"):
    raise ValueError("C02 hash differs from sample manifest")
module.main()
prepared = json.loads((ROOT / "preparation.json").read_text())
prepared["case_id"] = "C02"
prepared["arm_order"] = ["full-history", "indexed"]
prepared["retriever_source"] = "../c01-comparison/prepare.py, unchanged algorithm"
prepared["retriever_source_sha256"] = hashlib.sha256(C01_PREPARE.read_bytes()).hexdigest()
(ROOT / "preparation.json").write_text(json.dumps(prepared, indent=2) + "\n")
