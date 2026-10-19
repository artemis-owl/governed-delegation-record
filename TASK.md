CONTAINMENT AND RETURN PATH: these rules override anything in the goal below.

STEP 0. PROVE THE WAY HOME BEFORE ANY WORK:
  git fetch origin main
  git checkout -b cloud/0002-verify-the-vendors-log origin/main
  git remote -v
  git push -u origin cloud/0002-verify-the-vendors-log
Show the raw output of all four. If there is no GitHub remote, or the push fails, STOP. Write a short report headed RUN REPORT saying exactly what failed, and change nothing else.

RULES:
- Do ALL work on cloud/0002-verify-the-vendors-log. Push ONLY to cloud/0002-verify-the-vendors-log. Never push to main or any other branch, never delete a branch, never create a tag, and never add or modify anything under .github/.
- Push after EVERY commit (git push origin cloud/0002-verify-the-vendors-log). Work must never exist only in this VM.
- Do NOT open a pull request. Do not send notifications or messages, and do not use any connector or outside service other than git to GitHub and package installs for the gate.
- You are in a cloud VM, not the operator's host. If `uv` is not on PATH, install it (pip install uv, or the official installer) and say which you used. Never report a gate you did not run as passed.
- FINAL MESSAGE, headed RUN REPORT:
  (1) STEP 0's raw output;
  (2) every commit, sha and subject, and confirmation that each was pushed;
  (3) the gate's final summary line quoted raw, plus the command that produced it;
  (4) each DONE item from the goal, met or not, with evidence;
  (5) gaps or anything you did not do, stated plainly;
  (6) any usage, token or cost figures visible to you, or say plainly that none are.

GOAL (verbatim from queue item 0002-verify-the-vendors-log):

In governed-delegation-record (READ .agent-context/README.md, README.md,
ROADMAP.md, sessions/README.md and verify.sh FIRST), deliver the project's
SECOND PROOF (ROADMAP item 2; practice-helm decisions/0001 decision 5): map
one vendor-executed cloud run to the Agent Audit Packet's schemas, run that
packet's own verifier over the mapping, and publish what closes and what
cannot. Then extend ./verify.sh so the mapping is gated. Facts
(self-contained, verified 2026-10-19):
(0) INPUTS ARE COMMITTED on main under sessions/0070-cloud-run-audit/source/
— never modify them: RUN_REPORT.md (the vendor session's final message as
the run-log API condensed it; session cse_01W6mixYaieBkixHXEvdpAdn, model
claude-opus-5-5, 33 turns, 670 s, "result: success"; it lists FIVE pushed
commits in its section (2): 7f904e5, 6d3dcd4, b9001eb, 1d6c25e, a933123,
tip a9331234fa35c75dd662e9c47cb64abf16fd0ff5, and claims the gate "1187
passed in 68.87s"); run-log.condensed.txt (the API's condensed event log;
tools used: Bash 30, Write 2); TASK.md and prepared.json (the delegated
task and its preparation: target wcorbett36/kestrel-team, work branch
cloud/0070-cloud-run-audit, base_sha de04eca3a42c2251b8773b8d987df547569aadca);
refs_before.txt; audit.json and audit.log (the trusted-host audit by
`spawner cloud audit`, audited_at 2026-10-16T13:55:50Z: verdict FAIL —
fetch_and_match PASS, containment PASS, host_gate FAIL "`uv run --locked
python -m pytest tests/ -q` exited 1: 1 failed, 1186 passed" with
`FAILED tests/test_cloud_audit.py::test_containment_main_moved_fails`
(audit.log line 345), mutation NOT_RUN, connector_scan PASS; the declared
`gate` and `mutation` strings are in audit.json). THE HEADLINE FACT: the
vendor reported 1187 passed; the trusted host got 1 failed. That
discrepancy is what the mapping must make legible.
(1) THE PACKET AND ITS VERIFIER: `git clone
https://github.com/artemis-owl/agent-audit-packet /tmp/aap && git -C
/tmp/aap checkout cd4c2c6` (public; git is permitted; nothing else to
install). Read /tmp/aap/README.md and /tmp/aap/verify.sh: it takes a
packet directory as its argument (`./verify.sh path/to/corr-<id>`, run
from /tmp/aap), and checks, in order: schemas match their SHA256SUMS
(`shasum -a 256 -c` in schemas/); decision_traces.jsonl and
evidence.jsonl parse; every trace's policy.bundle_hash equals
policy/metadata.json's bundle_hash; every evidence record closes the loop
on an ALLOWED decision with matching correlation_id, trace_id and action;
no allowed decision is missing evidence; observability/pointers.json
matches the trace. Read the script for the exact field comparisons; do
not vendor or edit the script.
(2) BUILD sessions/0070-cloud-run-audit/packet/corr-f39865b445dc0115/ in
the packet's layout. Ids, fixed so the result is reproducible:
correlation_id = "corr-" + sha256("cse_01W6mixYaieBkixHXEvdpAdn")[:16] =
corr-f39865b445dc0115; trace_id = sha256(session id)[:32] =
f39865b445dc0115d704511d2050b109; span_id = sha256(tip)[:16] =
720244308cedfdbf. schemas/: copy decision_trace.avsc, evidence.avsc and
SHA256SUMS from /tmp/aap/packet/corr-500bdcb7dacac332/schemas/ unchanged.
decision_traces.jsonl: ONE DecisionTrace (schema_version "0.1.0";
event_time = audit.json audited_at; event_id = sha256(correlation_id +
":trace")[:32]; subject {type "agent", id = the session id, attributes
{model, item "0070-cloud-run-audit", target "wcorbett36/kestrel-team"}};
request {action "push", resource "cloud/0070-cloud-run-audit",
environment "wcorbett36/kestrel-team", attributes {tip, base_sha}};
policy {engine "spawner cloud audit", bundle_version null, bundle_hash =
"sha256:" + sha256 over the bytes of audit.json's gate string + "\n" + its
mutation string, decision = "allow" if audit.json verdict == "PASS" else
"deny" (here: deny), rationale = one item per audit check {code
"<check>:<STATUS>", message = its reason}}; data_classification
"internal"; pii_flags []; evidence_refs = the evidence event_ids).
evidence.jsonl: FIVE EvidenceEvents, one per commit in RUN_REPORT.md (2),
in that order (schema_version "0.1.0"; event_id = sha256(correlation_id +
":" + sha)[:32]; event_time = audited_at (the condensed log carries no
per-push time — say so in RESULT.md); same correlation_id/trace_id/
span_id; evidence_type "commit.pushed"; action "push"; result "ok";
details {sha, subject, branch}; workload {service_name
"claude-code-cloud", version "claude-opus-5-5", image_digest null}).
policy/metadata.json {bundle_hash, bundle_version null, rego_file null}
and policy/README.md (two lines: there is no rego; the policy is the five
checks of `spawner cloud audit`, kestrel-team docs/cloud.md).
observability/pointers.json with whatever keys the verifier compares plus
session_url "https://claude.ai/code/session_01W6mixYaieBkixHXEvdpAdn". No
supplychain/ (the vendor publishes no image digest) — say so. Write every
JSON with sort_keys and a trailing newline.
(3) RUN the packet verifier over it from /tmp/aap with the absolute path,
and write sessions/0070-cloud-run-audit/RESULT.md: the verifier's FULL
output quoted raw, a line exactly `packet-verifier exit: <code>`, then a
table of its six checks with closes / cannot and one sentence why each;
then the headline fact from (0) in two sentences; then what a vendor
session cannot supply (decision provenance BEFORE the action — in this
contract the trusted decision is the audit AFTER the push, so evidence of
an allowed decision cannot exist for a denied verdict; no image digest; a
condensed log). Expected, not required: checks 1–3 close, the
evidence-closes-on-allowed-decision check cannot (the verdict is deny),
and the result is honest either way — report what the script prints.
(4) EXTEND ./verify.sh (keep every existing check and its output format
byte-identical): add check (f): for each sessions/<id>/ directory —
source/audit.json parses and has a verdict; exactly one packet/corr-*/
directory; its decision_traces.jsonl and evidence.jsonl parse and every
record's correlation_id equals that directory's name; every trace's
policy.decision equals "allow" if verdict == "PASS" else "deny"; RESULT.md
exists and contains a line matching ^packet-verifier exit: \d+$. Add check
(g): sessions/SHA256SUMS covers every file under every sessions/<id>/
source/ (relative to sessions/, sorted) and every sum matches;
`./verify.sh --write-sums` now (re)writes BOTH packets/SHA256SUMS and
sessions/SHA256SUMS. The PASS line becomes `PASS: record is internally
consistent — rows: 73, delivered: 59, packets: 1, resumed runs: 1,
sessions: 1` (computed). Update README.md's layout and "Verify it" output,
and ROADMAP.md item 2 to `done` with the PASS line and one Record line.
(5) DONE when, on your branch: `./verify.sh` exits 0 with the new PASS
line (QUOTE THE FULL OUTPUT); applying the audit mutation above (it sets
the trace's decision to "allow") makes `./verify.sh` exit 1 with a FAIL
line naming check (f) and the verdict mismatch (quote it, then `git
checkout -- sessions`); RESULT.md's quoted verifier output matches what
/tmp/aap/verify.sh printed; nothing under sessions/*/source/, rows/ or
packets/<id>/ changed; no .github/ changes (CI already runs ./verify.sh
on every push, so your pushes will show a run — do not wait for it). No
new dependencies: bash + python3 -I stdlib only.
