---
size_class: task
risk_grade: medium
failure_policy: medium
mode: delegated
group: abort-path
status: delivered
target_repo: https://github.com/artemis-owl/kestrel-team
team: claude_squad
goal: |
  In kestrel-team (Python; the agent-dispatch governor), make drain/spawn
  confirmations safe without a tty. Facts (all real, self-contained;
  incident evidence: run-1786402322, 2026-08-10):
  (1) THE INCIDENT: `spawner drain` was fired programmatically with both
  confirmations piped (`printf 'y\ny\n' | spawner drain 0026 …`). The
  parent process's stdin buffering consumed BOTH lines at the first
  typer.confirm (the drain preview), so the spawned run's HITL breakpoint
  read EOF, aborted, and the abort path destroyed finished work (see the
  companion abort-path item). Programmatic firing is a legitimate
  operator-attended pattern; today it fails late and destructively.
  (2) THE FIX, fail-closed and explicit:
  (a) EARLY REFUSAL: when stdin is not a tty and no explicit consent flag
  is passed, `spawner drain` refuses at startup — before any preview
  consumption or spawn — with a message naming the flag. A piped drain must
  fail in the first second, not at the last gate.
  (b) EXPLICIT CONSENT FLAG: add `--yes` to `spawner drain`, meaning:
  auto-confirm the drain preview AND every forwarded spawn HITL for the
  selected items. Print a loud one-line notice per auto-confirmed gate so
  the transcript shows each gate was consumed by the flag. This is still
  operator-fired and attended-by-authorization (ADR-0009's rung-2 posture);
  it is NOT unattended scheduling — document that boundary in docs/drain.md.
  (c) TTY PASSTHROUGH: when stdin IS a tty, behavior is unchanged
  (interactive confirms).
  (3) GUARDRAILS: unit tests for: non-tty without --yes refuses before
  reading the queue's confirm (exit nonzero, clear message); --yes drains
  without prompting and the HITL is auto-confirmed with the notice printed;
  tty path unchanged (prompt still issued). Update docs/drain.md (command
  surface + the rung boundary note). Mark the ROADMAP finding ("Drain
  confirmations require a tty…") Completed with a delivery note. Run the
  full test suite and quote real output.
  (4) POSTURE (standing, operator 2026-08-07): any defect or adjacent
  finding encountered mid-run is filed in ROADMAP.md as *proposed* —
  identified, considered, addressed; never skipped silently.
---

# Brief 0028 — non-tty drain confirmations: early refusal + explicit --yes (queue item; abort-path group)

- **Status:** Commissioned — queued *(2026-08-13; closes the tty-only
  confirmations finding from the retest incident.)*
- **Owning repo:** kestrel-team
- **Record:**
  - 2026-08-13 — Shaped and queued (operator "proceed with plan" ruling).
    Sequenced after 0027 in queue order; different seam (drain CLI command
    surface vs the abort handler), shaped separately to keep each run
    single-purpose.
