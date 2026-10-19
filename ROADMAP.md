# Roadmap — governed-delegation-record

Statuses: `next` · `queued` · `blocked (names the blocker)` · `awaiting ruling` · `done (date + pointer)`.
Agents update statuses; the operator sets scope and priority. Work arrives only through
practice-helm `queue/` items (kestrel-team queue item contract); nothing is done without the
verifier's quoted output (practice-helm CHARTER.md §1).

| # | Item | Status | Pointer |
| :- | :--- | :--- | :--- |
| 1 | **First proof:** delivered rows of the four ledgers (kestrel, lark, korlith, artemis), redacted to id/date/instance/outcome/PR ref; one evidence packet; `verify.sh` (row ↔ PR ↔ packet consistency); CI green; link from artemisowl.io's audit-packet download page | `done (2026-10-19)` — `PASS: record is internally consistent — rows: 73, delivered: 59, packets: 1, resumed runs: 1`; CI workflow and the artemisowl.io link not yet added | practice-helm decisions/0001 decision 5; queue/0001; `verify.sh` |
| 2 | **Second proof:** one cloud-run session (`0070-cloud-run-audit`) mapped to the packet's schemas and run through the verifier; result quoted both ways | `done (2026-10-19)` — `PASS: record is internally consistent — rows: 73, delivered: 59, packets: 1, resumed runs: 1, sessions: 1`; packet verifier exit 1 (checks 1–3 close, 4 cannot: verdict FAIL → deny) | decisions/0001 decision 5; queue/0002; `sessions/0070-cloud-run-audit/RESULT.md` |
| 3 | **Third proof:** `verify.sh --controls` printing, per check, the NIST AI RMF subcategory, ISO/IEC 42001 clause, OWASP ASI item and EU AI Act Art. 12 purpose it evidences | `queued` | decisions/0001 "Parked" (C3) |
| — | Public visibility | `awaiting ruling` | trigger: first proof green |

## Record

- 2026-10-18 — repo created, private, scaffold only (README, LICENSE, ROADMAP, `.agent-context/`). No verifier yet.
- 2026-10-19 — first proof: `verify.sh` (stdlib-only gate, checks a–e) and `packets/SHA256SUMS` added; `./verify.sh` passes (73 rows, 59 delivered, 1 packet, 1 resumed run) and fails on the korlith pr_url mutation. Queue 0001.
- 2026-10-19 — CI: `.github/workflows/verify.yml` added on `main` as an attended commit (`7b92a28`) after PR #1 merged (`9cca672`); first run https://github.com/artemis-owl/governed-delegation-record/actions/runs/39261254023 — `completed success`, last line `PASS: record is internally consistent — rows: 73, delivered: 59, packets: 1, resumed runs: 1`. First proof complete, CI clause included.
- 2026-10-19 — second proof: session `0070-cloud-run-audit` mapped to `sessions/0070-cloud-run-audit/packet/corr-f39865b445dc0115/`; the Agent Audit Packet verifier (`cd4c2c6`) closes schemas, parse and policy bundle and stops at the evidence→allowed-decision check (exit 1: the vendor reported 1187 passed, the trusted host 1 failed, so the decision is deny); `verify.sh` checks (f) and (g) gate the mapping and `sessions/SHA256SUMS`. Queue 0002.
- 2026-10-19 — PR #2 merged by the operator (`1c6a555`, 14:34Z) after a fix-forward at integration (`sessions/SHA256SUMS` regenerated for the `TASK.delivered.md` rename). CI on main: https://github.com/artemis-owl/governed-delegation-record/actions/runs/39270143017 `completed success`, last line `PASS: record is internally consistent — rows: 73, delivered: 59, packets: 1, resumed runs: 1, sessions: 1`. Second proof complete.
