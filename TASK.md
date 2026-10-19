CONTAINMENT AND RETURN PATH: these rules override anything in the goal below.

STEP 0. PROVE THE WAY HOME BEFORE ANY WORK:
  git fetch origin main
  git checkout -b cloud/0003-controls-map origin/main
  git remote -v
  git push -u origin cloud/0003-controls-map
Show the raw output of all four. If there is no GitHub remote, or the push fails, STOP. Write a short report headed RUN REPORT saying exactly what failed, and change nothing else.

RULES:
- Do ALL work on cloud/0003-controls-map. Push ONLY to cloud/0003-controls-map. Never push to main or any other branch, never delete a branch, never create a tag, and never add or modify anything under .github/.
- Push after EVERY commit (git push origin cloud/0003-controls-map). Work must never exist only in this VM.
- Do NOT open a pull request. Do not send notifications or messages, and do not use any connector or outside service other than git to GitHub and package installs for the gate.
- You are in a cloud VM, not the operator's host. If `uv` is not on PATH, install it (pip install uv, or the official installer) and say which you used. Never report a gate you did not run as passed.
- FINAL MESSAGE, headed RUN REPORT:
  (1) STEP 0's raw output;
  (2) every commit, sha and subject, and confirmation that each was pushed;
  (3) the gate's final summary line quoted raw, plus the command that produced it;
  (4) each DONE item from the goal, met or not, with evidence;
  (5) gaps or anything you did not do, stated plainly;
  (6) any usage, token or cost figures visible to you, or say plainly that none are.

GOAL (verbatim from queue item 0003-controls-map):

In governed-delegation-record (READ .agent-context/README.md, README.md,
ROADMAP.md and verify.sh FIRST), deliver the project's THIRD PROOF (ROADMAP
item 3; practice-helm decisions/0001 decision 5): make the verifier say,
per check, which control each check evidences — `./verify.sh --controls`
— and ship CONTROLS.md generated from the same table, gated so the two
cannot drift. Facts (self-contained; the mapping below was drafted by the
practice on 2026-10-19 from steering's docs/control-map.md and the
standards named; it is an ARGUED mapping, reviewed by the operator, not a
certification claim — write exactly these codes, do not add or "correct"
any):
(0) THE CHECKS as verify.sh prints them today, letters (a)–(g): (a) rows:
every line is a well-formed projected row; (b) rows: every delivered row
has a pull-request pr_url; (c) rows: resumed runs counted, not failed;
(d) packet <id>: provenance and ledger rows match rows/, and pr_refs.txt
and provenance runs[].pr_url agree with the packet rows; (e) packets:
SHA256SUMS covers every packet file and every sum matches; (f) session
<id>: trace and evidence records parse, every trace's decision matches the
audit verdict, RESULT.md records the packet verifier's exit; (g) sessions:
SHA256SUMS covers every source/ file and every sum matches. Keep every
existing check and its output byte-identical.
(1) THE MAPPING, one row per check, four columns, exactly:
 a | NIST AI RMF GOVERN 1.5 | ISO/IEC 42001 7.5 Documented information; A.6.2.8 AI system recording of event logs | OWASP ASI10 Rogue Agents | EU AI Act Art. 12(1)
   rationale: every governed run leaves an automatic, well-formed record over the system's lifetime; an agent run with no row is the rogue the inventory would miss.
 b | NIST AI RMF MANAGE 4.1 | ISO/IEC 42001 A.6.2.6 AI system operation and monitoring; 9.1 Monitoring, measurement, analysis and evaluation | OWASP ASI05 Unexpected Code Execution | EU AI Act Art. 12(2)(c)
   rationale: a delivery exists only as a reviewable pull request, never as code that ran into main; the deployer can monitor what was changed and by which run.
 c | NIST AI RMF MEASURE 3.1 | ISO/IEC 42001 10.2 Nonconformity and corrective action | OWASP ASI08 Cascading Failures | EU AI Act Art. 12(2)(a)
   rationale: a resumed run is a contained failure kept visible as a second row, not collapsed into a clean story; the situations that may present risk stay identifiable.
 d | NIST AI RMF MEASURE 2.8 | ISO/IEC 42001 A.7.5 Data provenance; A.6.2.8 AI system recording of event logs | OWASP ASI09 Human-Agent Trust Exploitation | EU AI Act Art. 12(2)(b)
   rationale: the evidence packet, the ledger and the PR reference agree with each other, so a reader trusts the record, not the agent's report of itself; this is the post-market monitoring data.
 e | NIST AI RMF MEASURE 2.7 | ISO/IEC 42001 7.5.3 Control of documented information | OWASP ASI04 Agentic Supply Chain Vulnerabilities | EU AI Act Art. 12(1)
   rationale: packet bytes are hash-covered; a changed byte anywhere fails the gate, so the record's integrity holds over its lifetime.
 f | NIST AI RMF MANAGE 2.4 | ISO/IEC 42001 9.2 Internal audit; A.6.2.6 AI system operation and monitoring | OWASP ASI02 Tool Misuse and Exploitation | EU AI Act Art. 12(2)(a)
   rationale: a vendor session's actions are judged by a trusted-host audit after the fact (containment, gate, mutation, connector scan); a deny verdict is recorded as a deny, and the mapped decision cannot disagree with it.
 g | NIST AI RMF MEASURE 2.7 | ISO/IEC 42001 7.5.3 Control of documented information | OWASP ASI04 Agentic Supply Chain Vulnerabilities | EU AI Act Art. 12(1)
   rationale: the vendor-run source files are hash-covered exactly as packets are.
(2) IMPLEMENT: one table in verify.sh (a single Python dict or list of
tuples, letters a–g → the four codes and the rationale, verbatim from (1)).
`./verify.sh --controls` prints, with no checks run and exit 0, a header
line then one line per check: `<letter>  <check title as printed in (0)>`
followed on the next line by `     NIST AI RMF: …  | ISO/IEC 42001: …  |
OWASP: …  | EU AI Act: …`. `./verify.sh --controls --markdown` prints the
same table as GitHub-flavoured markdown: a preface (exactly the stance
sentence in the parenthesis of this goal's opening paragraph, dated
2026-10-19, plus one sentence that the frameworks are outcome-level and
the sub-outcome codes are the practice's reading), then a table with
columns Check | NIST AI RMF | ISO/IEC 42001 | OWASP Agentic Top 10 (2026)
| EU AI Act | Why, one row per letter. CONTROLS.md IS that output, written
once with `./verify.sh --controls --markdown > CONTROLS.md`. Add check
(h): `CONTROLS.md` equals, byte for byte, what `--controls --markdown`
would print now; on mismatch, `FAIL (h) controls: CONTROLS.md differs from
verify.sh's table: <first differing line>`; on success, `ok   (h) controls:
CONTROLS.md matches the verifier's control table (7 checks)`. Keep the
usage line current; `--write-sums` unchanged; the PASS line unchanged.
(3) README.md: add a "Controls" section after "Verify it": two sentences
(what --controls prints; CONTROLS.md is generated and gated) and the
`./verify.sh --controls` output for checks a and b only, quoted. ROADMAP.md
item 3 → `done` with today's date and the (h) ok line; one Record line.
(4) DONE when, on your branch: `./verify.sh` exits 0 with `ok   (h) …` before
the PASS line (QUOTE THE FULL OUTPUT); `./verify.sh --controls` output
quoted in full; applying the audit mutation above (it changes ASI05 to
ASI06 in CONTROLS.md) makes `./verify.sh` exit 1 with the (h) FAIL line
naming the differing line (quote it, then `git checkout -- CONTROLS.md`);
no other file changes; no .github/ changes (CI runs ./verify.sh on every
push already); no new dependencies. Stack: bash + python3 -I stdlib only.
