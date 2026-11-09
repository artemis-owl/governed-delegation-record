# 0007-the-boundary-is-chief-editor-not-sole-author — the session checker over a vendor session

Session `cse_01Buwmo67x8YAgoZMBk78R7u`, mapped from `source/` into `packet/corr-d08f7d5b44d1d6ac/` by the Agent Audit Packet's `map-session.sh` and checked by its `verify.sh` (github.com/artemis-owl/agent-audit-packet at `44b7fb5`), run as:

```bash
./map-session.sh <record>/sessions/0007-the-boundary-is-chief-editor-not-sole-author/source <record>/sessions/0007-the-boundary-is-chief-editor-not-sole-author/packet
./verify.sh <record>/sessions/0007-the-boundary-is-chief-editor-not-sole-author/packet/corr-d08f7d5b44d1d6ac
```

The audit's one FAIL is about the work: the run built the provenance check, and the check then refused two published pieces that lack `spotEdited`, so the host gate is red. The run is row `cloud-0007-the-boundary-is-chief-editor-not-sole-author` in `rows/artemis.jsonl` (`aborted`, `undelivered`).

The mapper's output:

```text
session: cse_01Buwmo67x8YAgoZMBk78R7u
mapped   1 decision trace: decision 'deny' from audit verdict FAIL, 5 rationale item(s)
mapped   1 evidence record(s), one per commit the report lists
mapped   policy bundle hash over the audit's declared gate and mutation: sha256:a73eb2611230…
not evidenced by this export: a policy decision before the action (the audit decided after the push)
not evidenced by this export: a time per push (every event_time is the audit's audited_at)
not evidenced by this export: an image digest or SBOM (no supplychain/)
wrote    sessions/0007-the-boundary-is-chief-editor-not-sole-author/packet/corr-d08f7d5b44d1d6ac
```

The verifier's full output (stdout and stderr), raw, with the record's path shown as `<record>`:

```text
packet: <record>/sessions/0007-the-boundary-is-chief-editor-not-sole-author/packet/corr-d08f7d5b44d1d6ac
ok   schemas match SHA256SUMS
ok   1 decision trace(s), 1 evidence record(s) parse
ok   every trace cites the shipped policy bundle: sha256:a73eb2611230…
FAIL every evidence record closes the loop on an allowed decision: 1 evidence record(s) of an executed action under decision 'deny'; 1 of 1 evidence record(s) carry no details.policy_decision
ok   no allowed decision is missing its evidence
ok   observability pointer matches the trace
FAIL: 1 check(s) failed
```

packet-verifier exit: 1
