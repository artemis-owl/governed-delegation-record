# 0008-the-provenance-check-lands-green-audit-1 — the session checker over a vendor session

Session `cse_01Buwmo4vptCJjQbT8eRU4UT`, mapped from `source/` into `packet/corr-3647e23e77b854e6/` by the Agent Audit Packet's `map-session.sh` and checked by its `verify.sh` (github.com/artemis-owl/agent-audit-packet at `44b7fb5`), run as:

```bash
./map-session.sh <record>/sessions/0008-the-provenance-check-lands-green-audit-1/source <record>/sessions/0008-the-provenance-check-lands-green-audit-1/packet
./verify.sh <record>/sessions/0008-the-provenance-check-lands-green-audit-1/packet/corr-3647e23e77b854e6
```

This is the run's FIRST audit, kept beside the one that passed. Its one FAIL is the auditor's, not the work's: the report repeats `9a9c528`, a commit the task itself named as the cherry-pick's source, and the auditor read it as a commit the run claimed. kestrel-team `15e8d28` fixed that; the re-audit passed and the run is row `cloud-0008-the-provenance-check-lands-green` in `rows/artemis.jsonl` (`done`, `delivered`).

The mapper's output:

```text
session: cse_01Buwmo4vptCJjQbT8eRU4UT
mapped   1 decision trace: decision 'deny' from audit verdict FAIL, 5 rationale item(s)
mapped   2 evidence record(s), one per commit the report lists
mapped   policy bundle hash over the audit's declared gate and mutation: sha256:a73eb2611230…
not evidenced by this export: a policy decision before the action (the audit decided after the push)
not evidenced by this export: a time per push (every event_time is the audit's audited_at)
not evidenced by this export: an image digest or SBOM (no supplychain/)
wrote    sessions/0008-the-provenance-check-lands-green-audit-1/packet/corr-3647e23e77b854e6
```

The verifier's full output (stdout and stderr), raw, with the record's path shown as `<record>`:

```text
packet: <record>/sessions/0008-the-provenance-check-lands-green-audit-1/packet/corr-3647e23e77b854e6
ok   schemas match SHA256SUMS
ok   1 decision trace(s), 2 evidence record(s) parse
ok   every trace cites the shipped policy bundle: sha256:a73eb2611230…
FAIL every evidence record closes the loop on an allowed decision: 2 evidence record(s) of an executed action under decision 'deny'; 2 of 2 evidence record(s) carry no details.policy_decision
ok   no allowed decision is missing its evidence
ok   observability pointer matches the trace
FAIL: 1 check(s) failed
```

packet-verifier exit: 1
