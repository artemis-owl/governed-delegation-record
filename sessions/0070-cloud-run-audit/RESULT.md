# 0070-cloud-run-audit — the packet verifier over a vendor session

Session `cse_01W6mixYaieBkixHXEvdpAdn` (claude-opus-5-5, 33 turns, 670 s; target
`wcorbett36/kestrel-team`, branch `cloud/0070-cloud-run-audit`, tip `a933123`) mapped into
`packet/corr-f39865b445dc0115/` and checked by the Agent Audit Packet's own verifier
(github.com/artemis-owl/agent-audit-packet at `cd4c2c6`, unmodified), run as:

```bash
cd /tmp/aap && ./verify.sh /home/user/governed-delegation-record/sessions/0070-cloud-run-audit/packet/corr-f39865b445dc0115
```

Full output (stdout and stderr), raw:

```text
packet: /home/user/governed-delegation-record/sessions/0070-cloud-run-audit/packet/corr-f39865b445dc0115
ok   schemas match SHA256SUMS
ok   1 decision trace(s), 5 evidence record(s) parse
ok   every trace cites the shipped policy bundle: sha256:2accc48376b4…
Traceback (most recent call last):
  File "<stdin>", line 22, in <module>
KeyError: 'policy_decision'
```

packet-verifier exit: 1

## The six checks

| # | Check | Result | Why |
| :- | :--- | :--- | :--- |
| 1 | schemas match SHA256SUMS | closes | The two `.avsc` files and `SHA256SUMS` are copied unchanged from the sample packet, so the contract is the packet's own. |
| 2 | decision traces and evidence parse | closes | One DecisionTrace (from `audit.json`) and five EvidenceEvents (one per commit in RUN_REPORT.md (2)) are well-formed JSON lines. |
| 3 | every trace cites the shipped policy bundle | closes | `bundle_hash` is sha256 over the audit's declared gate and mutation strings, and `policy/metadata.json` ships the same value. |
| 4 | every evidence record closes the loop on an allowed decision | cannot | The verifier stops here with `KeyError: 'policy_decision'`: a vendor push carries no decision it acted under, and the trusted decision is `deny` (verdict FAIL), so even with that field the next assertion (`decision == "allow"`) fails. |
| 5 | no allowed decision is missing its evidence | cannot | Not reached (the script exits at check 4); on this data it would hold vacuously, since the one decision is a deny and all five pushes are evidenced. |
| 6 | observability pointer matches the trace | cannot | Not reached (the script exits at check 4); `observability/pointers.json` carries the trace's `trace_id` and points at the vendor session, not at a tracing backend. |

## The headline

The vendor session reported `1187 passed in 68.87s` and `result: success`; the trusted-host
audit re-ran the same gate on the same tip and got `1 failed, 1186 passed`
(`FAILED tests/test_cloud_audit.py::test_containment_main_moved_fails`, `source/audit.log`
line 345), so its verdict is FAIL and the mapped decision is `deny`. The packet makes that
legible as five `commit.pushed` evidence records hanging off a decision that denies them:
the actions happened, and the policy that judges them did not allow them.

## What a vendor session cannot supply

- **Decision provenance before the action.** The packet's model is decide, then act, then
  evidence; in this delegation contract the vendor pushes first and the trusted decision is the
  audit after the push. Evidence of an *allowed* decision therefore cannot exist for a denied
  verdict, and no evidence record can name the decision it acted under — which is exactly where
  the verifier stops.
- **An image digest.** The vendor publishes no image digest for the workload, so
  `workload.image_digest` is null and there is no `supplychain/` directory.
- **A full log.** The run-log API returns a condensed event log and a truncated final message
  (`[+3421 chars truncated by the tool]`). It carries no per-push time, so every evidence
  `event_time` is the audit's `audited_at` (2026-10-16T13:55:50Z), not the push time.
