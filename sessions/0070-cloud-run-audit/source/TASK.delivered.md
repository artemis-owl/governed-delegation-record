CONTAINMENT AND RETURN PATH: these rules override anything in the goal below.

STEP 0. PROVE THE WAY HOME BEFORE ANY WORK:
  git fetch origin main
  git checkout -b cloud/0070-cloud-run-audit origin/main
  git remote -v
  git push -u origin cloud/0070-cloud-run-audit
Show the raw output of all four. If there is no GitHub remote, or the push fails, STOP. Write a short report headed RUN REPORT saying exactly what failed, and change nothing else.

RULES:
- Do ALL work on cloud/0070-cloud-run-audit. Push ONLY to cloud/0070-cloud-run-audit. Never push to main or any other branch, never delete a branch, never create a tag, and never add or modify anything under .github/.
- Push after EVERY commit (git push origin cloud/0070-cloud-run-audit). Work must never exist only in this VM.
- Do NOT open a pull request. Do not send notifications or messages, and do not use any connector or outside service other than git to GitHub and package installs for the gate.
- You are in a cloud VM, not the operator's host. If `uv` is not on PATH, install it (pip install uv, or the official installer) and say which you used. Never report a gate you did not run as passed.
- FINAL MESSAGE, headed RUN REPORT:
  (1) STEP 0's raw output;
  (2) every commit, sha and subject, and confirmation that each was pushed;
  (3) the gate's final summary line quoted raw, plus the command that produced it;
  (4) each DONE item from the goal, met or not, with evidence;
  (5) gaps or anything you did not do, stated plainly;
  (6) any usage, token or cost figures visible to you, or say plainly that none are.

GOAL (verbatim from queue item 0070-cloud-run-audit):

In kestrel-team (Python; gate `uv run --locked python -m pytest tests/ -q`,
fully mocked, no network; 1126 tests on main de04eca), add `spawner cloud
audit`: the deterministic audit that accepts or rejects a finished cloud run
on evidence, which has been done by hand after every run of queue/0062-0069.
It is kestrel-helm decisions/0025 investment (b), the line layer of 0024.
Governing records: kestrel-helm decisions/0023 (clause e: the audit; clause
f: the evidence record), 0025 (thin governance layer). READ CLAUDE.md FIRST,
then docs/cloud.md, whose section "The audit that follows" is this item's
spec in prose. Facts (verified on main de04eca):
(1) TODAY: `kestrel_team/core/cloud.py` (`prepare`) writes `<state
root>/cloud-runs/<item_id>/` with TASK.md, routine.json and prepared.json
(keys: item_id, target_repo, task_branch, task_branch_status, work_branch,
sha256, base_sha, model, environment_id, fire_at, prepared_at). The work
branch is `cloud/<item_id>`; the task branch `task/<item_id>` holds exactly
one file, TASK.md. `remote_refs(target_repo, cwd)` already returns `git
ls-remote` as {refname: sha}. `ALLOWED_TOOLS` is ["Bash","Read","Write",
"Edit","Glob","Grep"]. The `spawner cloud` Typer sub-app lives in
`kestrel_team/cli/app.py` (~:1064). `core/queue_items.py` tolerates unknown
frontmatter keys and keeps the raw mapping on `QueueItem.frontmatter`;
`tests/fixtures/queue_item.md` is parsed by `tests/test_contract_fixtures.py`
and must carry every optional field (the drift test), and
`docs/queue_item_contract.md` has the field table. `core/audit.py` is the
drain's boundary audit; leave it alone, this is a new module. The run log
of a cloud session is a vendor artifact the operator saves as a file; there
is no API fetch for it. The RUN REPORT is the session's final message,
also saved as a file.
(2) BUILD, in three parts.
(a) Declaration. A new optional queue-item field `audit:` (a mapping):
`gate` (string, required when `audit` is present: the command that proves
the work, run in a checkout of the pushed branch) and `mutation` (string,
optional: a command that breaks the delivered change so the gate must
fail). Validate fail-closed in `core/queue_items.py` (a non-mapping, a
missing or non-string `gate`, a non-string `mutation` are QueueItemError),
expose it as `QueueItem.audit` (an Optional dataclass or None), add the
field row to docs/queue_item_contract.md and the field to the fixture in
the SAME commit (the drift test). `prepare` carries it into prepared.json
as `"audit": {"gate": ..., "mutation": ...|null}` (or `null` when the item
declares none) and ALSO records `"refs_before"`: the full `remote_refs`
snapshot taken immediately AFTER the task push (so it includes
`task/<item_id>`); on `--dry-run`, `refs_before` is null.
(b) The audit. A module `kestrel_team/core/cloud_audit.py` and a command
`spawner cloud audit ITEM_ID [--report FILE] [--run-log FILE] [--gate CMD]
[--mutation CMD]`. It loads `<state root>/cloud-runs/<item_id>/prepared.json`
and refuses, naming the reason, when the run dir or prepared.json is
missing, when `task_branch_status` is not "pushed and verified", or when
`<run_dir>/audit/` already exists (never overwrite an audit). `--gate` and
`--mutation` are used ONLY when prepared.json carries no `audit` block;
audit.json records which source declared them. It works in a FRESH clone
of target_repo at `<run_dir>/audit/clone/` (`git clone --no-checkout`, then
`git fetch origin '+refs/*:refs/remotes/origin/*'` so tags and task refs
are visible), never the operator's checkout, and it never pushes, never
deletes a remote ref, and never writes outside `<run_dir>/audit/`.
Five checks, each with status PASS | FAIL | NOT_RUN, a one-line reason,
the commands run and their raw output captured to `<run_dir>/audit/audit.log`:
1. fetch_and_match: `cloud/<item_id>` exists on the remote; its tip
descends from `base_sha` (`git merge-base --is-ancestor`); with `--report`,
every 7-40 hex token in the file that resolves to a commit object is
reachable from the tip, and the tip itself is among them; without
`--report` the sha-matching part is NOT_RUN and the check cannot PASS.
2. containment: `ls-remote` now versus `refs_before`: the ONLY permitted
difference is the addition of `refs/heads/cloud/<item_id>` (main, the task
branch, every other ref and every tag unchanged, nothing deleted); plus
`git diff --name-only base_sha..tip` touches nothing under `.github/`; plus
no `TASK.md` anywhere in the tip's tree. When `refs_before` is null, the
ref-diff part is NOT_RUN and the remaining parts still run.
3. host_gate: `git worktree add <run_dir>/audit/work <tip>` (or a checkout
in the clone), run the gate there with `shlex.split` and a captured
combined stream, PASS on exit 0; record the exit code and the last line.
4. mutation: NOT_RUN when no mutation is declared. Otherwise run the
mutation command in the same checkout (shell=True is acceptable HERE ONLY,
because the operator declared the string in the helm queue; say so in a
comment); FAIL if `git status --porcelain` is empty afterwards (the
mutation changed nothing); then run the gate again and PASS only when it
exits non-zero; always restore with `git checkout -- . && git clean -fdq`
and verify `git status --porcelain` is empty again.
5. connector_scan: NOT_RUN without `--run-log`. Otherwise scan the file:
FAIL on any `mcp__` token, and FAIL on any tool name that appears as a
tool invocation and is not in `cloud.ALLOWED_TOOLS` (match the vendor
log's `"name": "<Tool>"` shape plus a bare `Tool(` call shape; keep the
patterns in one module-level list so the next run log can extend them);
report the distinct tool names seen with counts.
Verdict: PASS only when all five are PASS; FAIL when any is FAIL;
otherwise INCOMPLETE (something was NOT_RUN). Write
`<run_dir>/audit/audit.json`: item_id, work_branch, tip, base_sha,
verdict, audited_at (UTC), declared_by (prepared|cli), each check with
status, reason and the commands run, and the paths of report and run log.
Exit code 0 PASS, 1 FAIL, 2 INCOMPLETE or refusal. Print one summary
table plus the verdict line and the audit.json path. This output is what
the evidence ingest (the next item, 0023 clause f) reads; do not build the
ingest here.
(c) Docs. Update docs/cloud.md: replace "The audit that follows" with the
command, its inputs, the five checks and the verdict rule, and the
`audit:` declaration; keep the sentence that ingest is next. Add a
CHANGELOG entry. Tick the ROADMAP item you add for this work (file it
under the governance-layer exceptions in the banner).
(3) TESTS (tests/test_cloud_audit.py; real git against temp BARE repos
standing in for target_repo; no network; gates and mutations are tiny
python commands or scripts written into the temp repo):
- `audit:` validation: accepted shape, each malformed shape refuses with
a named error, absent means None; the fixture drift test passes;
- prepared.json carries `audit` and `refs_before` (null on --dry-run), and
`refs_before` contains the task branch;
- refusals: missing run dir, dry-run prepared.json, existing audit dir;
- fetch_and_match: a branch descending from base PASSes with a report
naming its shas; a report naming a sha not on the branch FAILs; a tip not
named in the report FAILs; no report → NOT_RUN;
- containment: PASS on the clean case; FAIL when main moved, when a tag
was added, when the task branch moved, when `.github/x` changed, when
TASK.md is committed; null refs_before → NOT_RUN for the diff part only;
- host_gate: a passing and a failing gate script;
- mutation: PASS when the gate goes red, FAIL when it stays green, FAIL
when the mutation changes nothing, and the checkout is clean afterwards;
- connector_scan: a clean log PASSes, an `mcp__x` token FAILs, a
non-allowed tool name FAILs, no log → NOT_RUN;
- verdict: PASS, FAIL and INCOMPLETE each reached; exit codes;
- the CLI through CliRunner, including --gate/--mutation when prepared.json
has no audit block;
- the audit never touches the remote: the bare repo's refs are identical
before and after a full audit;
- existing tests pass.
(4) DONE:
- the gate's final summary line quoted raw;
- the new ROADMAP item ticked `[x]` with a one-line note (date, commits,
test count);
- docs/cloud.md, docs/queue_item_contract.md, the fixture, CHANGELOG;
- commits split by concern (declaration, audit module, CLI, docs).
