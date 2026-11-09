CONTAINMENT AND RETURN PATH: these rules override anything in the goal below.

STEP 0. PROVE THE WAY HOME BEFORE ANY WORK:
  git fetch origin main
  git checkout -b cloud/0008-the-provenance-check-lands-green origin/main
  git remote -v
  git push -u origin cloud/0008-the-provenance-check-lands-green
Show the raw output of all four. If there is no GitHub remote, or the push fails, STOP. Write a short report headed RUN REPORT saying exactly what failed, and change nothing else.

RULES:
- Do ALL work on cloud/0008-the-provenance-check-lands-green. Push ONLY to cloud/0008-the-provenance-check-lands-green. Never push to main or any other branch, never delete a branch, never create a tag, and never add or modify anything under .github/.
- Push after EVERY commit (git push origin cloud/0008-the-provenance-check-lands-green). Work must never exist only in this VM.
- Do NOT open a pull request. Do not send notifications or messages, and do not use any connector or outside service other than git to GitHub and package installs for the gate.
- You are in a cloud VM, not the operator's host. If `uv` is not on PATH, install it (pip install uv, or the official installer) and say which you used. Never report a gate you did not run as passed.
- FINAL MESSAGE, headed RUN REPORT:
  (1) STEP 0's raw output;
  (2) every commit, sha and subject, and confirmation that each was pushed;
  (3) the gate's final summary line quoted raw, plus the command that produced it;
  (4) each DONE item from the goal, met or not, with evidence;
  (5) gaps or anything you did not do, stated plainly;
  (6) any usage, token or cost figures visible to you, or say plainly that none are.

GOAL (verbatim from queue item 0008-the-provenance-check-lands-green):

In artemis_home (gate `npm test`), land the provenance check that
queue/0007's run built and could not make green: cherry-pick its commit
and finish the roadmap bookkeeping, on a main where the operator has
already made the two edits only the operator can make. READ CLAUDE.md
FIRST — on this base it already reads "The operator is chief editor, not
sole author" — and ROADMAP.md lines 33–42 and 88–93.

Preconditions, on main before this item fires (the seat checks both and
quotes them in the Record): (a) `CLAUDE.md`'s boundary paragraph is the
chief-editor text (the operator's edit; a run's edit of CLAUDE.md is
refused by the harness as self-modification, 0007's RUN REPORT); (b)
`content/field-notes/a-runaway-token-bill-is-a-diagnosis-problem.md` and
`content/field-notes/finished-and-delivered-are-different-facts.md` carry
`spotEdited = "<name>, 2026-08-24"` in their frontmatter (the operator's
claim about their own spot-edit of 2026-08-24, commit `922630a`).

Facts (seat, 2026-11-02). Base: origin/main `a8f6fde` — the operator's
edits above plus 13 operator commits of 2026-10-13..20 (distribution
slots 3–4, newsletter, signals) rebased onto `cbb9d1a` and pushed
2026-11-02; `npm test` green on that tree from the seat (28 content
pieces, 17 published, 20 posts, metrics in sync). 0007's run pushed `9a9c528` on
`cloud/0007-the-boundary-is-chief-editor-not-sole-author`, kept on origin:
`scripts/check-provenance.mjs` (new), `package.json` (`check:provenance`
wired after `check:content` in `test`), `docs/content-model.md` (the
`spotEdited` line), `ROADMAP.md` (the Proposed item, now at 88–93, set
to `In Progress` with a dated partial line). The cherry-pick onto
`a8f6fde` conflicts in exactly one line, `package.json`'s `"test"`
script: main added `check:metrics` after `check:distribution` while
`9a9c528` adds `check:provenance` after `check:content`. The seat's trial
resolved it as the union and the gate was green:
`"test": "npm run build && npm run test:links && npm run check:content && npm run check:provenance && npm run check:inventory && npm run check:distribution && npm run check:metrics && npm run voice:check"`. The check listed the two published
pieces above as offenders and exited 1, so the gate was red on that tree.
With `spotEdited` on both, the run's control showed `Provenance check
passed for 2 agent-drafted pieces.`, exit 0, and the declared mutation
(the draft piece flipped to `draft = false`) gave exactly one offender,
exit 1. Hugo: install it as queue/0004 did (`curl -fsSL -o /tmp/hugo.deb
https://github.com/gohugoio/hugo/releases/download/v0.157.0/hugo_extended_0.157.0_linux-amd64.deb`,
sha256 `7b01dbaf37b048df51804cdb645c7ab0cc311536de07775c7d4fa82cb3569f2e`,
`dpkg -i`); if the harness refuses the download, run every `npm run`
step of `test` but `build` and `test:links` one by one, quote each, and
say so — the seat's audit runs the full gate.

Do this. (1) `git cherry-pick 9a9c528` (origin's
`cloud/0007-the-boundary-is-chief-editor-not-sole-author`). Expect the
one `package.json` conflict above and resolve it to exactly the union
line quoted in the Facts, then `git cherry-pick --continue`; any other
conflict, STOP and report. (2) `ROADMAP.md`: the item at 88–93 gets `**Status:** Done` and one more dated
line naming this queue item and the merge of the operator's two edits;
line 40's sentence ("agents may write docs/lab, only the operator writes
content/") gains " *(superseded 2026-11-02: see CLAUDE.md, the
boundary)*" in place, the historical text kept. (3) `npm test`; quote its
last lines; `npm run check:provenance` alone must print `Provenance check
passed for 2 agent-drafted pieces.`. Scope: the cherry-picked files plus
`ROADMAP.md`; nothing under `content/`, nothing in `CLAUDE.md`. Two
commits on `cloud/0008-…` (the cherry-pick, the roadmap). RUN REPORT: the
gate lines, the check's line, the mutation run by hand (the draft piece
flipped and flipped back: one offender, exit 1).
