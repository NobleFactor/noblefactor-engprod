---
title: "Calibration candidates: review notes"
status: provisional
---

# Calibration candidates: review notes

These are preparatory observations, not an approved reference or a complete sample. The saved source hash is `48d3120ea7a31d674a1c65a99733376d67bb131709a689b0dfb96b00648c489c`. Source row positions below are zero-based positions in the process-violations table, not timestamps. The source table does not establish within-day chronology and is not globally sorted by date. A source-position replay would be a synthetic sequence; an Owner or independent reviewer must accept that choice or require stronger chronological evidence. The C02 source row spans October 6–7, rather than being limited to October 6.

| Candidate | Incident | Provisional reference evidence | Review issue |
| --- | --- | --- | --- |
| C01, row 9 | Statements of unverified inferences as fact | Row 2, P003, describes unverified claims and cites the same certainty rule. | Row 2 and row 9 are both dated October 6; their relative time is not established. The existing shortlist omits P003. |
| C02, row 10 | Short options used after a promise to use long options | Row 5, P006, describes repeated short options and cites the long-option rule. The source also cites the certainty rule for row 10. | Row 5 is dated October 6 and row 10 spans October 6–7; sequence is not established. The provisional reference also accepts P003, but does not explain why a single answer matching P003 would sufficiently identify this occurrence's short-option pattern. The reviewer must settle the intended classification and how multiple applicable patterns are scored. |

The baseline histories in `case-01.json` and `case-02.json` have row positions but no pattern IDs. The later [sample review packet](../sample-review/review.md) proposes a complete 16-case sample with consistent row-anchor IDs, four retransmissions and separate provisional references. It needs review and is not frozen. The older five-record lists here are a preliminary lexical check, not an implementation of the plan's requirement/operation/error-signature/approved-alias retriever. Resolving only the two calibration candidates is insufficient to approve the full sample.
