#!/usr/bin/env python3
"""Synthetic accounting and occurrence-identity fixtures; not a telemetry parser."""
from decimal import Decimal
import unittest


def reconcile(events, rate):
    """Reconcile one final, uniquely identified synthetic event per request.

    Reject ambiguous events rather than guess whether a cumulative counter or a
    repeated last-usage snapshot represents another provider request.
    """
    events_by_id = {}
    requests = {}
    for event in events:
        event_id = event["event_id"]
        if event_id in events_by_id:
            if events_by_id[event_id] != event:
                raise ValueError("conflicting usage event id")
            continue
        events_by_id[event_id] = event
        request_id = event["request_id"]
        if request_id in requests:
            raise ValueError("multiple usage events for request need attribution")
        requests[request_id] = event
        counts = [event[k] for k in ("input", "cached", "output", "reasoning", "total")]
        if any(type(n) is not int or n < 0 for n in counts):
            raise ValueError("invalid token count")
        if event["cached"] > event["input"] or event["reasoning"] > event["output"]:
            raise ValueError("subset count exceeds total")
        if event["total"] != event["input"] + event["output"]:
            raise ValueError("unexpected token relationship")
    total = sum((
        (Decimal(e["input"] - e["cached"]) * rate["input"]
         + Decimal(e["cached"]) * rate["cached"]
         + Decimal(e["output"]) * rate["output"]) / Decimal(1_000_000)
        for e in requests.values()
    ), Decimal(0))
    return len(requests), total


class Ledger:
    def __init__(self):
        self.deliveries = {}
        self.occurrences = {}
        self.reports = {}
        self.charges = {}

    def record(self, delivery, occurrence, pattern, request, charge):
        data = (occurrence, pattern, request, charge)
        if delivery in self.deliveries and self.deliveries[delivery] != data:
            raise ValueError("conflicting delivery")
        if occurrence in self.occurrences and self.occurrences[occurrence] != (pattern, request, charge):
            raise ValueError("conflicting occurrence")
        if request in self.charges and self.charges[request] != (occurrence, charge):
            raise ValueError("conflicting charge")
        self.deliveries[delivery] = data
        self.occurrences[occurrence] = (pattern, request, charge)
        self.reports[occurrence] = pattern
        self.charges[request] = (occurrence, charge)


class FixtureTests(unittest.TestCase):
    def test_usage_reordered_duplicates_and_failure(self):
        rate = {"input": Decimal("2"), "cached": Decimal("0.5"), "output": Decimal("10")}
        a = {"event_id": "e1", "request_id": "r1", "input": 1000, "cached": 400,
             "output": 100, "reasoning": 60, "total": 1100, "status": "success"}
        b = {"event_id": "e2", "request_id": "r2", "input": 200, "cached": 0,
             "output": 20, "reasoning": 10, "total": 220, "status": "partial_failure"}
        self.assertEqual(reconcile([a, b, a], rate), (2, Decimal("0.003")))
        self.assertEqual(reconcile([b, a, b], rate), (2, Decimal("0.003")))
        with self.assertRaises(ValueError):
            reconcile([a, dict(a, output=99)], rate)
        with self.assertRaises(ValueError):
            reconcile([a, dict(a, event_id="e3")], rate)
        with self.assertRaises(ValueError):
            reconcile([dict(a, reasoning=101)], rate)
        with self.assertRaises(ValueError):
            reconcile([dict(a, total=1099)], rate)

    def test_retransmissions_and_separate_occurrences(self):
        ledger = Ledger()
        ledger.record("d1", "o1", "p1", "r1", Decimal("0.002"))
        ledger.record("d1", "o1", "p1", "r1", Decimal("0.002"))
        ledger.record("d2", "o1", "p1", "r1", Decimal("0.002"))
        ledger.record("d3", "o2", "p1", "r2", Decimal("0.001"))
        self.assertEqual((len(ledger.deliveries), len(ledger.occurrences), len(ledger.reports), len(ledger.charges)), (3, 2, 2, 2))
        self.assertEqual(sum(charge for _, charge in ledger.charges.values()), Decimal("0.003"))
        with self.assertRaises(ValueError):
            ledger.record("d4", "o1", "p2", "r1", Decimal("0.002"))
        with self.assertRaises(ValueError):
            ledger.record("d4", "o3", "p1", "r1", Decimal("0.002"))
        self.assertEqual(len(ledger.deliveries), 3)


if __name__ == "__main__":
    unittest.main()
