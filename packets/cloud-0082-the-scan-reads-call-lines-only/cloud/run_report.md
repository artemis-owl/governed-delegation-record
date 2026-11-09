RUN REPORT of session cse_01Buwmo8LVkB2GuLwaEMLbEm (https://claude.ai/code/session_01Buwmo8LVkB2GuLwaEMLbEm), routine trig_01FNVu9CzGF7SUYfk6sdhdUB. Read 2026-11-02 from the session page in the seat's browser pane; the "(1) STEP 0 raw output" code block, which the page renders without text, is taken from the same message in the API run log (RemoteTrigger get_run_log), where it is complete.

# RUN REPORT

The change for queue item 0082 is committed and pushed to `cloud/0082-the-scan-reads-call-lines-only`, and the gate passes (`1284 passed`). I opened no PR and sent no notification, as TASK.md asked.

TASK.md was fetched from `origin/task/0082-the-scan-reads-call-lines-only`. Its sha256 is `3ce45f0d2c2c8515689e0e258525763721a437cc97db2a91dd460bf0dbea6d02`, which matches the expected value.

**(1) STEP 0 raw output**

```
From https://github.com/artemis-owl/kestrel-team
 * branch            main       -> FETCH_HEAD
   87db78c..a5ec494  main       -> origin/main
Switched to a new branch 'cloud/0082-the-scan-reads-call-lines-only'
branch 'cloud/0082-the-scan-reads-call-lines-only' set up to track 'origin/main'.
origin	https://github.com/artemis-owl/kestrel-team (fetch)
origin	https://github.com/artemis-owl/kestrel-team (push)
remote:
remote: Create a pull request for 'cloud/0082-the-scan-reads-call-lines-only' on GitHub by visiting:
remote:      https://github.com/artemis-owl/kestrel-team/pull/new/cloud/0082-the-scan-reads-call-lines-only
remote:
To https://github.com/artemis-owl/kestrel-team
 * [new branch]      cloud/0082-the-scan-reads-call-lines-only -> cloud/0082-the-scan-reads-call-lines-only
branch 'cloud/0082-the-scan-reads-call-lines-only' set up to track 'origin/cloud/0082-the-scan-reads-call-lines-only'.
```

**(2) Commits**

- `821dcfc` "connector_scan: scan only the run log's call lines (helm queue/0082)". Pushed: `a5ec494..821dcfc  cloud/0082-the-scan-reads-call-lines-only -> cloud/0082-the-scan-reads-call-lines-only`. `git status` afterwards shows the branch level with its origin.

**(3) Gate**

- Command: `uv run --locked python -m pytest tests/ -q`
- Final line: `1284 passed in 75.58s (0:01:15)`
- `uv` was already installed at `/root/.local/bin/uv`, so I installed nothing.

**(4) DONE items**

1. **Met.** In `kestrel_team/core/cloud_audit.py`, the comment block, `API_NON_CALL_LINE` and `call_lines()` are added right after `TOOL_CALL_PATTERNS`, using the exact text from the task.
2. **Met.** `text = call_lines(text)` is the first statement after the `scan_run_log` docstring. Nothing else in the function changed.
3. **Met.** Line 78's comment now reads "A connector (MCP) tool on any call line of the run log is a containment breach."
4. **Met.** The clause is inserted after "Otherwise" in `docs/cloud.md` item 5, so the sentence reads as the task specifies. I re-wrapped the lines in that paragraph to fit the file's width.
5. **Met.** Three new tests sit right after `test_connector_scan_ignores_quoted_tool_use_in_tool_results`:
   - `test_connector_scan_ignores_mcp_token_in_tool_results`
   - `test_connector_scan_ignores_vendor_json_in_tool_results`
   - `test_connector_scan_ignores_assistant_text`

   They use the logs and assertions from the task, and all pass. No existing test was edited. `test_connector_scan_bare_mcp_mention_fails` and `test_connector_scan_api_format_mcp_tool_fails` still fail the scan as intended, and both pass in the gate run.

**(5) Gaps**

- **Base tree differs from the task's reference.** The task names the base tree as `c8c8a05`, but that object doesn't exist in this clone. The actual base is `origin/main` at `a5ec494` (0081 merged as #41), and its tree is `22a3caf`. Every line number in the task matched that tree, so I went ahead.
- **No roadmap commits.** CLAUDE.md asks for a "Mark … Active" commit and a ROADMAP toggle for each task. I made neither, because TASK.md says "Nothing else changes" and the earlier queue items (0078–0081) didn't touch ROADMAP either.
- **Not run:** `spawner doctor`, any real spawn, and any PR.

**(6) Usage and cost:** none are visible to me.
