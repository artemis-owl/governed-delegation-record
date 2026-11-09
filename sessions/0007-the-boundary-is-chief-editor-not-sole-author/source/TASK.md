CONTAINMENT AND RETURN PATH: these rules override anything in the goal below.

STEP 0. PROVE THE WAY HOME BEFORE ANY WORK:
  git fetch origin main
  git checkout -b cloud/0007-the-boundary-is-chief-editor-not-sole-author origin/main
  git remote -v
  git push -u origin cloud/0007-the-boundary-is-chief-editor-not-sole-author
Show the raw output of all four. If there is no GitHub remote, or the push fails, STOP. Write a short report headed RUN REPORT saying exactly what failed, and change nothing else.

RULES:
- Do ALL work on cloud/0007-the-boundary-is-chief-editor-not-sole-author. Push ONLY to cloud/0007-the-boundary-is-chief-editor-not-sole-author. Never push to main or any other branch, never delete a branch, never create a tag, and never add or modify anything under .github/.
- Push after EVERY commit (git push origin cloud/0007-the-boundary-is-chief-editor-not-sole-author). Work must never exist only in this VM.
- Do NOT open a pull request. Do not send notifications or messages, and do not use any connector or outside service other than git to GitHub and package installs for the gate.
- You are in a cloud VM, not the operator's host. If `uv` is not on PATH, install it (pip install uv, or the official installer) and say which you used. Never report a gate you did not run as passed.
- FINAL MESSAGE, headed RUN REPORT:
  (1) STEP 0's raw output;
  (2) every commit, sha and subject, and confirmation that each was pushed;
  (3) the gate's final summary line quoted raw, plus the command that produced it;
  (4) each DONE item from the goal, met or not, with evidence;
  (5) gaps or anything you did not do, stated plainly;
  (6) any usage, token or cost figures visible to you, or say plainly that none are.

GOAL (verbatim from queue item 0007-the-boundary-is-chief-editor-not-sole-author):

In artemis_home (gate `npm test`), make the repo's stated boundary match
the loop it runs, and make the gate enforce the part that matters. READ
CLAUDE.md, docs/editorial-loop.md and ROADMAP.md lines 87–93 FIRST. Three
files change: `CLAUDE.md`, `ROADMAP.md`, and one new check wired into
`npm test`. No content file changes.

Facts (seat, 2026-11-02). CLAUDE.md lines 8–13 say "Agents capture, the
operator writes. … You never author into `content/`, never write in the
house voice, never publish." docs/editorial-loop.md step 5 (amended
2026-08-06) has agents assemble a draft into `content/` in the assumed
voice with piece-level provenance and `draft = true`; the operator enters
at steps 7–9 (chief-editor spot-edit, fact gate, publish checklist).
Three pieces have shipped by that route, the latest
`content/field-notes/a-gate-nobody-ran-passed.md` (PR #18, merged
`cbb9d1a`, still `draft = true`, provenance paragraph at its foot:
"Agent-drafted under the editorial loop … it awaits the chief-editor
spot-edit"). ROADMAP.md lines 87–93 file this exact finding as Proposed
(2026-08-17): restate the boundary as "the operator is chief editor, not
sole author". ROADMAP.md line 40 (the workflow-evidence stub) carries the
superseded sentence "agents may write docs/lab, only the operator writes
content/". Nothing in `npm test` today refuses an agent draft published
without the operator's pass: `scripts/check-voice.mjs` reads published
pieces for voice, `scripts/check-content.mjs` validates frontmatter enums.

Do this. (1) CLAUDE.md "The one boundary that matters" (8–13) becomes,
exactly: "**The operator is chief editor, not sole author.** You may work
on site *machinery* (templates, scripts, checks), draft capture-side
material in `docs/lab/`, and draft into `content/` only under
`docs/editorial-loop.md`: in the assumed voice, from a lab note and
interview fragments, with the piece's provenance paragraph and
`draft = true`. The voice gate, the fact gate, `docs/publish-checklist.md`,
the flip to `draft = false` and the merge are the operator's alone; you
never publish. `npm run check:provenance` refuses a published piece whose
provenance says it was agent-drafted and does not say who spot-edited it."
(2) `scripts/check-provenance.mjs`, new: for every `content/**/*.md` whose
frontmatter has `draft = false` and whose body contains the phrase
"Agent-drafted under the editorial loop", require the frontmatter key
`spotEdited = "<name>, <yyyy-mm-dd>"`; print `Provenance check passed for
N agent-drafted pieces.` on success, else list each offender as `<path>:
agent-drafted and published without spotEdited` and exit 1. Wire it as
`"check:provenance": "node ./scripts/check-provenance.mjs"` in
package.json and add it to the `test` script after `check:content`.
`docs/content-model.md` gains the `spotEdited` key in the frontmatter
table with one line: "required when a published piece's provenance says
agent-drafted". (3) ROADMAP.md: the Proposed item at 87–93 gets
`**Status:** Done` and one dated line naming this queue item; line 40's
sentence gains " *(superseded 2026-11-02: see CLAUDE.md, the boundary)*"
in place, the historical text kept. Scope: `CLAUDE.md`, `ROADMAP.md`,
`package.json`, `scripts/check-provenance.mjs`, `docs/content-model.md`;
nothing under `content/`. Run `npm test`; quote its last lines. One
commit on `cloud/0007-…`. RUN REPORT: the CLAUDE.md diff, the check's
output on the tree as committed (`passed for 0 agent-drafted pieces` is
expected: the one agent-drafted piece is still a draft), and the check's
output with `a-gate-nobody-ran-passed.md` flipped to `draft = false` and
flipped back (the declared mutation, run by hand: one offender, exit 1).
