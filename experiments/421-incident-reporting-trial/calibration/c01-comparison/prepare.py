#!/usr/bin/env python3
"""Prepare blind C01 inputs; does not read the reference file or call a model."""
import hashlib
import json
import math
import pathlib
import re
import time
from collections import Counter

ROOT = pathlib.Path(__file__).resolve().parent
CASE = ROOT.parent.parent / "sample-review" / "inputs" / "C01.json"
HASH = "d1952aed1a793fe6da7dc5d0fbbaf89facf6d4fb182d988ce74f0ba15bda4887"
STOP = frozenset("a an and as at be by for from had has in is it its of on or that the their they this to was were when which with owner agent".split())


def terms(text):
    return [word for word in re.findall(r"[a-z0-9]+", text.lower()) if len(word) > 1 and word not in STOP]


def main():
    data = CASE.read_bytes()
    if hashlib.sha256(data).hexdigest() != HASH:
        raise ValueError("C01 input changed since review packet")
    case = json.loads(data)
    start = time.monotonic()
    docs = [Counter(terms(record["incident"] + " " + record["rule"])) for record in case["history"]]
    query = Counter(terms(case["incident"]))
    count = len(docs)
    idf = {word: math.log((count + 1) / (1 + sum(word in doc for doc in docs))) + 1 for word in query}
    scores = [sum(query[word] * doc[word] * idf[word] for word in query) for doc in docs]
    order = sorted(range(count), key=lambda i: (-scores[i], case["history"][i]["pattern_id"]))[:5]
    elapsed = time.monotonic() - start
    ranking = [{"pattern_id": case["history"][i]["pattern_id"], "score": round(scores[i], 6)} for i in order]
    indexed = [case["history"][i] for i in order]
    contract = ("Classify the incident against the supplied historical records. Return a JSON object with "
                "disposition: existing, new, or escalate; pattern_id: the supplied ID for an existing pattern "
                "or null otherwise; evidence: a short array of relevant supplied IDs; and reason: one brief sentence. "
                "Use existing only when the incident fits that record's underlying error pattern. "
                "If there is no appropriate supplied record, choose new; if the evidence does not permit a decision, "
                "choose escalate. Do not use tools or inspect files. Reply with only the JSON object.")
    for arm, history in (("full-history", case["history"]), ("indexed", indexed)):
        prompt = contract + "\n\nIncident:\n" + case["incident"] + "\n\nSupplied historical records:\n" + json.dumps(history, ensure_ascii=False, indent=2)
        (ROOT / f"{arm}-prompt.txt").write_text(prompt + "\n", encoding="utf-8")
    schema = {"type": "object", "properties": {"disposition": {"type": "string", "enum": ["existing", "new", "escalate"]},
              "pattern_id": {"type": ["string", "null"]}, "evidence": {"type": "array", "items": {"type": "string"}},
              "reason": {"type": "string"}}, "required": ["disposition", "pattern_id", "evidence", "reason"], "additionalProperties": False}
    (ROOT / "output-schema.json").write_text(json.dumps(schema, indent=2) + "\n")
    manifest = {"case_id": "C01", "status": "prepared", "source_input_sha256": HASH,
                "arm_order": ["indexed", "full-history"], "eligible_history_ids": [r["pattern_id"] for r in case["history"]],
                "indexed_ranking": ranking, "retrieval_seconds": elapsed,
                "retrieval_method": "Case-insensitive alphanumeric tokens, fixed stop words, query term frequency times document term frequency times log((N+1)/(df+1))+1; descending score then pattern ID; top five. Document = incident plus rule.",
                "retriever_limits": "Lexical approximation; no explicitly approved aliases or separately structured requirement/operation/error-signature fields.",
                "prompt_sha256": {arm: hashlib.sha256((ROOT / f"{arm}-prompt.txt").read_bytes()).hexdigest() for arm in ("indexed", "full-history")},
                "schema_sha256": hashlib.sha256((ROOT / "output-schema.json").read_bytes()).hexdigest()}
    (ROOT / "preparation.json").write_text(json.dumps(manifest, indent=2) + "\n")


if __name__ == "__main__":
    main()
