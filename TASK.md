CONTAINMENT AND RETURN PATH: these rules override anything in the goal below.

STEP 0. PROVE THE WAY HOME BEFORE ANY WORK:
  git fetch origin main
  git checkout -b cloud/0005-record-urls-to-artemis-owl origin/main
  git remote -v
  git push -u origin cloud/0005-record-urls-to-artemis-owl
Show the raw output of all four. If there is no GitHub remote, or the push fails, STOP. Write a short report headed RUN REPORT saying exactly what failed, and change nothing else.

RULES:
- Do ALL work on cloud/0005-record-urls-to-artemis-owl. Push ONLY to cloud/0005-record-urls-to-artemis-owl. Never push to main or any other branch, never delete a branch, never create a tag, and never add or modify anything under .github/.
- Push after EVERY commit (git push origin cloud/0005-record-urls-to-artemis-owl). Work must never exist only in this VM.
- Do NOT open a pull request. Do not send notifications or messages, and do not use any connector or outside service other than git to GitHub and package installs for the gate.
- You are in a cloud VM, not the operator's host. If `uv` is not on PATH, install it (pip install uv, or the official installer) and say which you used. Never report a gate you did not run as passed.
- FINAL MESSAGE, headed RUN REPORT:
  (1) STEP 0's raw output;
  (2) every commit, sha and subject, and confirmation that each was pushed;
  (3) the gate's final summary line quoted raw, plus the command that produced it;
  (4) each DONE item from the goal, met or not, with evidence;
  (5) gaps or anything you did not do, stated plainly;
  (6) any usage, token or cost figures visible to you, or say plainly that none are.

GOAL (verbatim from queue item 0005-record-urls-to-artemis-owl):

In governed-delegation-record (READ README.md, verify.sh and
.agent-context/README.md FIRST), rewrite every repository URL from the
operator's personal account to the organization those repositories now live
under, for the SIX that moved and no others: `github.com/wcorbett36/<r>/` →
`github.com/artemis-owl/<r>/` for r in kestrel-team, kestrel-scoop,
kestrel-gateway, kestrel-proof, trust-steering, artemis_home. lark-press and
korlith stay under wcorbett36 (practice-helm decisions/0009: the hobby
lane is personal). Governing records: decisions/0008 decision 3 as narrowed
by 0009 decision 3. DO NOT START unless each of these six URLs returns the
repository (HTTP 200 or a redirect that lands on artemis-owl/<name>):
https://github.com/artemis-owl/{kestrel-team,kestrel-scoop,kestrel-gateway,kestrel-proof,trust-steering,artemis_home}.
If any does not, STOP and report which under RUN REPORT; the transfers are
the operator's act and this item waits on them. Facts (verified 2026-10-22
on main after PR #4 and the home-path redaction):
(1) Occurrences of `wcorbett36`: rows/*.jsonl 59 (every `pr_url`; of these,
rows/lark.jsonl 6 and rows/korlith.jsonl 1 are hobby-lane URLs and STAY),
packets/run-1786647187/ 4 (ledger_rows.jsonl, pr_refs.txt, provenance.yaml
runs[].pr_url; all kestrel-team), sessions/0070-cloud-run-audit/source/ 11
(audit.json and audit.log clone URLs, kestrel-team; check RESULT.md and
packet/ too and rewrite any), instances.jsonl 4 (rewrite the artemis and
kestrel lines; the korlith and lark lines STAY), README.md 1 (the quoted
(d) ok line inside the verify block). After the rewrite `git grep -c
wcorbett36` must print exactly: rows/korlith.jsonl:1, rows/lark.jsonl:6,
instances.jsonl:2, and nothing else.
(2) The rewrite is a byte substitution of those six owner/repo prefixes; no
other byte in rows/, packets/, sessions/ changes. Then `./verify.sh --write-sums`
(packets/SHA256SUMS and sessions/SHA256SUMS regenerate; nothing else is
written), then regenerate the README verify block from a real run: replace
the block between `<!-- verify:begin -->` and `<!-- verify:end -->` with
the `ok` lines (a)–(i), then (j)'s own ok line, then the PASS line, exactly
as check (j) specifies; the only line that changes is (d)'s, which now
names https://github.com/artemis-owl/kestrel-team/pull/15.
(3) The README's "never edited" exception sentence (home paths shortened
to `~`) gains six words so it stays true: "paths under the operator's home
directory are shortened to `~`, and repository URLs name the organization
the repositories moved to; no other byte is changed." Apply the same
wording to the sessions bullet's exception. Nothing else in README changes.
(4) UNTOUCHED: .github/**, LICENSE, CONTROLS.md, verify.sh, .agent-context/.
Checks (a)–(j) and their printed lines are byte-identical except (d)'s URL.
(5) DONE when: `./verify.sh` exits 0 and its full output is QUOTED; the
mutation above (one letter in instances.jsonl's kestrel repo URL) makes
`./verify.sh` exit 1 — it must fail at (i) only if the URL shape breaks,
otherwise at (j) because the README block no longer matches; quote the
FAIL line either way, then `git checkout -- instances.jsonl`;
`git grep -c wcorbett36` prints exactly the three hobby-lane counts above;
`git status --short` shows only rows/artemis.jsonl and rows/kestrel.jsonl, the three packet files, packets/SHA256SUMS, the session
source files that carried the string, sessions/SHA256SUMS, instances.jsonl,
README.md. One PR; merge is the operator's.
