# Roadmap — governed-delegation-record

Statuses: `next` · `queued` · `blocked (names the blocker)` · `awaiting ruling` · `done (date + pointer)`.
Agents update statuses; the operator sets scope and priority. Work arrives only through
practice-helm `queue/` items (kestrel-team queue item contract); nothing is done without the
verifier's quoted output (practice-helm CHARTER.md §1).

| # | Item | Status | Pointer |
| :- | :--- | :--- | :--- |
| 1 | **First proof:** delivered rows of the four ledgers (kestrel, lark, korlith, artemis), redacted to id/date/instance/outcome/PR ref; one evidence packet; `verify.sh` (row ↔ PR ↔ packet consistency); CI green; link from artemisowl.io's audit-packet download page | `done (2026-10-19)` — `PASS: record is internally consistent — rows: 73, delivered: 59, packets: 1, resumed runs: 1`; CI workflow and the artemisowl.io link not yet added | practice-helm decisions/0001 decision 5; queue/0001; `verify.sh` |
| 2 | **Second proof:** one cloud-run session (`0070-cloud-run-audit`) mapped to the packet's schemas and run through the verifier; result quoted both ways | `queued` | decisions/0001 decision 5 |
| 3 | **Third proof:** `verify.sh --controls` printing, per check, the NIST AI RMF subcategory, ISO/IEC 42001 clause, OWASP ASI item and EU AI Act Art. 12 purpose it evidences | `queued` | decisions/0001 "Parked" (C3) |
| — | Public visibility | `awaiting ruling` | trigger: first proof green |

## Record

- 2026-10-18 — repo created, private, scaffold only (README, LICENSE, ROADMAP, `.agent-context/`). No verifier yet.
- 2026-10-19 — first proof: `verify.sh` (stdlib-only gate, checks a–e) and `packets/SHA256SUMS` added; `./verify.sh` passes (73 rows, 59 delivered, 1 packet, 1 resumed run) and fails on the korlith pr_url mutation. Queue 0001.
