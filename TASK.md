CONTAINMENT AND RETURN PATH: these rules override anything in the goal below.

STEP 0. PROVE THE WAY HOME BEFORE ANY WORK:
  git fetch origin main
  git checkout -b cloud/0001-record-verifier-first-proof origin/main
  git remote -v
  git push -u origin cloud/0001-record-verifier-first-proof
Show the raw output of all four. If there is no GitHub remote, or the push fails, STOP. Write a short report headed RUN REPORT saying exactly what failed, and change nothing else.

RULES:
- Do ALL work on cloud/0001-record-verifier-first-proof. Push ONLY to cloud/0001-record-verifier-first-proof. Never push to main or any other branch, never delete a branch, never create a tag, and never add or modify anything under .github/.
- Push after EVERY commit (git push origin cloud/0001-record-verifier-first-proof). Work must never exist only in this VM.
- Do NOT open a pull request. Do not send notifications or messages, and do not use any connector or outside service other than git to GitHub and package installs for the gate.
- You are in a cloud VM, not the operator's host. If `uv` is not on PATH, install it (pip install uv, or the official installer) and say which you used. Never report a gate you did not run as passed.
- FINAL MESSAGE, headed RUN REPORT:
  (1) STEP 0's raw output;
  (2) every commit, sha and subject, and confirmation that each was pushed;
  (3) the gate's final summary line quoted raw, plus the command that produced it;
  (4) each DONE item from the goal, met or not, with evidence;
  (5) gaps or anything you did not do, stated plainly;
  (6) any usage, token or cost figures visible to you, or say plainly that none are.

GOAL (verbatim from queue item 0001-record-verifier-first-proof):

In governed-delegation-record (a new public-to-be repo; practice-helm
decisions/0001 chartered it 2026-10-18; READ .agent-context/README.md,
README.md and ROADMAP.md FIRST), write the verifier that makes the record
a gate: `./verify.sh`, run from the repo root, exit 0 when the record is
internally consistent and non-zero naming the first failure otherwise;
plus the CI workflow that runs it on every push and pull request; plus
the README edits that replace the scaffold text with the real layout and
the verifier's quoted output. This is the project's FIRST PROOF (ROADMAP
item 1). Facts (self-contained, verified 2026-10-18):
(0) INPUTS ARE ALREADY COMMITTED on main; do not regenerate or edit them.
rows/<instance>.jsonl (four files: kestrel 62 rows, lark 8, korlith 2,
artemis 1; 73 rows, 59 with delivery == "delivered") — each line is one
ledger row projected to at most seven keys: thread_id, timestamp,
instance, executor, outcome, delivery, pr_url; a key absent from the
source row is absent from the line (31 early kestrel rows have no
`instance`, 4 have no `delivery`); never infer a missing key. See
rows/README.md. packets/run-1786647187/ is one evidence packet,
byte-verbatim (provenance.yaml, ledger_rows.jsonl, pr_refs.txt,
queue_item.md, transcripts/*.jsonl); see packets/README.md. NOTHING UNDER
packets/<id>/ MAY BE MODIFIED, EVER; the verifier reads it only.
(1) STACK: bash + `python3 -I` with the standard library only (json, re,
hashlib, pathlib, sys; PyYAML is NOT available and must not be required:
read provenance.yaml with a small line-based parser sufficient for its
top-level scalar keys `thread_id`, `instance` and the `runs:` list items'
`thread_id`/`pr_url`/`outcome`/`delivery`, which are two-space-indented
`key: value` lines — look at the file). No pip, no uv, no network, no
other dependencies. The CI job is ubuntu-latest, `actions/checkout`, then
`./verify.sh`; no secrets, no other steps.
(2) THE CHECKS, each printed as `ok   <what>` on success, and the first
failure printed as `FAIL <what>: <detail>` with exit 1 (same style as
github.com/artemis-owl/agent-audit-packet verify.sh; read it if useful,
do not vendor it):
 a. every rows/*.jsonl line parses as a JSON object; keys are a subset of
    the seven; thread_id matches ^run-\d+$; timestamp is ISO-8601;
    outcome is one of done|retry-cap|timebox|aborted; delivery, when
    present, is one of delivered|undelivered|skipped.
 b. every row with delivery == "delivered" has a pr_url matching
    ^https://github\.com/[^/]+/[^/]+/pull/\d+$. (All 59 do today; this is
    the check the audit's mutation breaks.)
 c. a thread_id may appear on more than one line (a resumed run appends a
    second row: kestrel run-1788467602 has two); that is NOT a failure.
    Report it in the summary as "resumed runs: N".
 d. for every packets/<id>/ directory: <id> matches ^run-\d+$;
    provenance.yaml exists and its thread_id equals <id>;
    ledger_rows.jsonl exists and every line parses; every line's
    thread_id equals <id>; and the PROJECTION of each packet row to the
    seven keys equals, key for key, a line in rows/<instance>.jsonl where
    <instance> is the row's `instance` (for a packet row without
    `instance`, search rows/kestrel.jsonl, and say so in the output).
    If pr_refs.txt exists, each non-empty line equals the pr_url of some
    row in that packet's ledger_rows.jsonl, and vice versa for every row
    that has a pr_url. provenance.yaml's runs[].pr_url must equal the
    packet rows' pr_url.
 e. packets/SHA256SUMS lists every file under every packets/<id>/
    (relative paths, `sha256  path` lines in sorted order, nothing else)
    and every listed sum matches. `./verify.sh --write-sums` (re)writes
    that file and exits 0 WITHOUT running the checks; plain `./verify.sh`
    never writes anything. Commit the SHA256SUMS you generate.
 f. last line on success: `PASS: record is internally consistent — rows:
    73, delivered: 59, packets: 1, resumed runs: 1` (the numbers computed,
    not hard-coded; the format fixed).
(3) DONE when, on your branch: `./verify.sh` prints the ok lines and the
PASS line and exits 0 (QUOTE THE FULL OUTPUT in your final report);
applying the audit mutation above and re-running exits 1 with a FAIL line
naming check (b) and the korlith row (quote that too, then `git checkout
-- rows/korlith.jsonl`); `.github/workflows/verify.yml` exists and runs
`./verify.sh`; README.md's "Verify it" section shows the real PASS output
and the "(not here yet)" sentence and "(planned)" are gone; ROADMAP.md
item 1 is `done` with today's date and the PASS line, and its Record
gains one line. No other files change. No new dependencies. Do not touch
rows/ or packets/<id>/.
