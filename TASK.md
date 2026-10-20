CONTAINMENT AND RETURN PATH: these rules override anything in the goal below.

STEP 0. PROVE THE WAY HOME BEFORE ANY WORK:
  git fetch origin main
  git checkout -b cloud/0004-legibility-pass origin/main
  git remote -v
  git push -u origin cloud/0004-legibility-pass
Show the raw output of all four. If there is no GitHub remote, or the push fails, STOP. Write a short report headed RUN REPORT saying exactly what failed, and change nothing else.

RULES:
- Do ALL work on cloud/0004-legibility-pass. Push ONLY to cloud/0004-legibility-pass. Never push to main or any other branch, never delete a branch, never create a tag, and never add or modify anything under .github/.
- Push after EVERY commit (git push origin cloud/0004-legibility-pass). Work must never exist only in this VM.
- Do NOT open a pull request. Do not send notifications or messages, and do not use any connector or outside service other than git to GitHub and package installs for the gate.
- You are in a cloud VM, not the operator's host. If `uv` is not on PATH, install it (pip install uv, or the official installer) and say which you used. Never report a gate you did not run as passed.
- FINAL MESSAGE, headed RUN REPORT:
  (1) STEP 0's raw output;
  (2) every commit, sha and subject, and confirmation that each was pushed;
  (3) the gate's final summary line quoted raw, plus the command that produced it;
  (4) each DONE item from the goal, met or not, with evidence;
  (5) gaps or anything you did not do, stated plainly;
  (6) any usage, token or cost figures visible to you, or say plainly that none are.

GOAL (verbatim from queue item 0004-legibility-pass):

In governed-delegation-record (READ README.md, verify.sh and
.agent-context/README.md FIRST), apply one rule to the whole repo:
NOTHING IS WRITTEN DOWN UNLESS SOMETHING ENFORCES IT (practice-helm
CHARTER.md §2). After this run every file is data, verify.sh, or output
verify.sh generates and checks — plus README.md, the one hand-written file,
rewritten for a reader who arrives cold. Task status and dated findings
live in practice-helm queue/, never here. Facts (self-contained; the README
text and the tenant lines below were drafted by the practice on 2026-10-20
and reviewed by the operator before the fire — write them exactly, do not
add, "improve" or reorder):
(0) UNTOUCHED, byte for byte: rows/*.jsonl, packets/<id>/**, sessions/<id>/
source/**, sessions/<id>/packet/**, packets/SHA256SUMS, sessions/SHA256SUMS,
LICENSE, .github/**. Checks (a)–(h) and their printed lines stay
byte-identical except as (3) says for the CONTROLS preface.
(1) DELETE: ROADMAP.md (status duplicated the helm's queue and went
stale), rows/README.md, packets/README.md, sessions/README.md (unchecked
prose; what a reader needs moves into README.md per (6)).
(2) ADD instances.jsonl at the repo root, exactly these four lines, sorted
by instance, keys exactly instance, repo, about:
 {"about": "the professional site of the practice that runs the other three", "instance": "artemis", "repo": "https://github.com/wcorbett36/artemis_home"}
 {"about": "the engine: the harness that commissions, runs and audits delegated work, and its satellite repos", "instance": "kestrel", "repo": "https://github.com/wcorbett36/kestrel-team"}
 {"about": "a product that took governed deliveries from the engine", "instance": "korlith", "repo": "https://github.com/wcorbett36/korlith"}
 {"about": "a product that took governed deliveries from the engine", "instance": "lark", "repo": "https://github.com/wcorbett36/lark-press"}
Add check (i) after (h): every line parses, has exactly those three keys
with non-empty strings, repo matches ^https://github\.com/[^/]+/[^/]+$,
lines sorted by instance with no duplicate; the set of instance values
equals the set of rows/*.jsonl stems. On failure `FAIL (i) instances:
<detail>`; on success `ok   (i) instances: every rows file names a listed
tenant and every listed tenant has a rows file (4)`.
(3) CONTROLS preface: in verify.sh controls_markdown() change "it is an
ARGUED mapping, reviewed by the operator, not a certification claim" to
"it is an ARGUED mapping, not a certification claim" (the review is the
operator's act and is recorded in the helm, not claimed here); nothing
else in the table or the text changes; regenerate CONTROLS.md with
`./verify.sh --controls --markdown > CONTROLS.md`; (h) still prints
`(7 checks)`. Checks (i) and (j) get no control row: like (h) they are
structural.
(4) ADD check (j) after (i): README.md contains exactly one block
`<!-- verify:begin -->` NEWLINE "```text" NEWLINE <lines> NEWLINE "```"
NEWLINE `<!-- verify:end -->`, and <lines> equals, byte for byte, this
run's own output: every `ok   …` line printed for (a)–(i), then (j)'s own
ok line, then the PASS line (compute all three before printing, compare,
then print). Implement by collecting printed lines in ok(). On mismatch
`FAIL (j) readme: README.md's verify block differs from this run's output:
line <n>: <that line>`; on success `ok   (j) readme: the quoted verifier
output in README.md matches this run`. The PASS line is unchanged.
(5) TRIM sessions/0070-cloud-run-audit/RESULT.md to what check (f) reads
and what makes that output reproducible: keep the H1, the opening
paragraph (session id, model, turns, seconds, target, branch, tip, the
verifier's repo and commit, "run as:"), the command block, "Full output
(stdout and stderr), raw:" with its text block, and the
`packet-verifier exit: 1` line. Delete the sections "The six checks",
"The headline" and "What a vendor session cannot supply" (dated findings;
they are recorded in practice-helm queue/0002's Record).
(6) REWRITE README.md to exactly the text between the BEGIN README and
END README markers, with the verify block filled from a real run (the
two FAIL blocks are reproduced in (8)):
BEGIN README
# governed-delegation-record

A record of work that AI agents delivered under governance, published so the governance can
be checked rather than described. It holds the delivery ledger of one small ecosystem of
agent-run projects, the evidence packets behind those deliveries, one vendor cloud session
mapped into an auditable packet, and a verifier that fails when any of it disagrees with
itself.

Four tenants appear in the ledger. **kestrel** is the engine: the harness that commissions,
runs and audits delegated work, with its satellite repos. **lark** and **korlith** are two
products that took governed deliveries from it. **artemis** is the professional site of the
practice that runs the other three. `instances.jsonl` names each with its repository, and
the verifier refuses a ledger file with no listed tenant.

## Check it yourself

```bash
./verify.sh
```

Bash and `python3 -I`, standard library only; no install, no network. Exit 0 when the record
is internally consistent, exit 1 naming the first failure. Its output on this commit — and
check (j) fails if this block stops matching what it prints:

<!-- verify:begin -->
```text
<the run's output, per (4)>
```
<!-- verify:end -->

Strip the PR reference from a delivered row (here the korlith one) and it fails:

```text
FAIL (b) rows: every delivered row has a pull-request pr_url: rows/korlith.jsonl:2 run-1789581310 is delivered but pr_url is null
```

Flip the mapped vendor session's decision to `allow` when its trusted-host audit said FAIL
and it fails:

```text
FAIL (f) session 0070-cloud-run-audit: sessions/0070-cloud-run-audit/packet/corr-f39865b445dc0115/decision_traces.jsonl:1 policy.decision 'allow' != 'deny' (audit verdict FAIL)
```

## What it holds

- `rows/` — one file per tenant. Each line is one ledger row projected to seven fields:
  `thread_id`, `timestamp`, `instance`, `executor`, `outcome`, `delivery`, `pr_url`. Goals,
  costs, token counts and session ids are not projected; they live, verbatim, in the packets.
  A resumed run is a second row with the same `thread_id`, counted as one run.
- `packets/` — evidence packets exactly as the engine exported them: provenance, the run's
  full ledger rows, its PR references, the task as commissioned, and the transcripts. Never
  edited; a packet that cannot be published as-is is excluded, not changed.
- `sessions/` — a run executed by a vendor cloud agent. `source/` is what the commissioning
  side holds about it (the task, the vendor's run report and log, the trusted-host audit),
  byte-verbatim; `packet/` is that run mapped into the
  [Agent Audit Packet](https://github.com/artemis-owl/agent-audit-packet) layout;
  `RESULT.md` is that packet verifier's raw output over it.
- `CONTROLS.md` — per check, the NIST AI RMF, ISO/IEC 42001, OWASP Agentic Top 10 and EU AI
  Act Art. 12 item it evidences. An argued mapping, not a certification claim; generated from
  the verifier's own table, and check (h) fails if the two differ by a byte.
- `SHA256SUMS` in `packets/` and `sessions/` pin every packet file and every session source
  file. `./verify.sh --write-sums` regenerates them and checks nothing; plain `./verify.sh`
  never writes.

## The vendor session

The one mapped session reported `1187 passed` and `result: success`. The trusted-host audit
re-ran the same gate on the same commit and got `1 failed, 1186 passed`, so the recorded
decision is `deny`: five pushes happened, and the policy that judges them did not allow
them. The packet verifier closes its first three checks on that session and cannot run the
fourth, because a vendor's log does not say which decision each action was taken under.

Intent plane: practice-helm. Apache-2.0.
END README
(7) .agent-context/README.md is a template with {{placeholders}}; replace
its whole body with: H1 ".agent-context/ — read before touching this
repo"; "## Verification gate" with the fenced command `./verify.sh` and
one line: exit 0 and the output quoted, CI runs it on every push; "##
Conventions" with exactly four bullets: (1) nothing is written down
unless something enforces it (practice-helm CHARTER.md §2): a file here
is data, verify.sh, or output verify.sh generates and checks; README.md
is the one exception; task status and findings live in practice-helm
queue/, never here; (2) rows/, packets/<id>/ and sessions/<id>/source/
are never edited; any rename or addition under them needs `./verify.sh
--write-sums`; (3) never commit a TASK.md — the cloud audit refuses any
TASK.md in the tip tree; (4) never touch .github/ — containment forbids
it; CI changes are attended commits.
(8) DONE when, on your branch: `./verify.sh` exits 0 printing (a)–(h)
as before, then the (i) and (j) ok lines, then the PASS line (QUOTE THE
FULL OUTPUT); the README verify block is that output byte for byte; the
two README FAIL blocks are reproduced by making each stated edit, running
`./verify.sh`, confirming the FAIL line is byte-identical to the README's
(quote both), then restoring with `git checkout -- <file>`; applying the
audit mutation above (rows: 73 → 74 in README.md) makes `./verify.sh`
exit 1 with the (j) FAIL line naming the differing line (quote it, then
`git checkout -- README.md`); `git status --short` shows exactly: D
ROADMAP.md, D rows/README.md, D packets/README.md, D sessions/README.md,
A instances.jsonl, M verify.sh, M CONTROLS.md, M README.md, M
.agent-context/README.md, M sessions/0070-cloud-run-audit/RESULT.md —
nothing else; `git diff --stat main -- rows packets/run-1786647187
sessions/0070-cloud-run-audit/source sessions/0070-cloud-run-audit/packet
packets/SHA256SUMS sessions/SHA256SUMS LICENSE .github` is empty; no new
dependencies. Stack: bash + python3 -I stdlib only.
