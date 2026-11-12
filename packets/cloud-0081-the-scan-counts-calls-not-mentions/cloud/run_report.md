RUN REPORT of session cse_01Buwmo5xPv6TdqcTfZmRFkJ (https://claude.ai/code/session_01Buwmo5xPv6TdqcTfZmRFkJ), routine trig_011VBaZ9MYV2GkKDg5mFutzx. Read 2026-11-01 from the session page in the seat's browser pane; the "(1) STEP 0 raw output" code block, which the page renders without text, is taken from the same message in the API run log (RemoteTrigger get_run_log), where it is complete.

# RUN REPORT

The fix is done: `connector_scan` now counts only lines that are themselves tool calls. A `tool_result:` line that quotes `"name": "x"` or `tool_use X:` no longer counts. It is committed and pushed to `cloud/0081-the-scan-counts-calls-not-mentions`, and the full gate passes. TASK.md's sha256 matched (`393d1733…67e72ed`) before I started.

**(1) STEP 0 raw output**

```
From https://github.com/artemis-owl/kestrel-team
 * branch            main       -> FETCH_HEAD
   87db78c..6af0114  main       -> origin/main
Switched to a new branch 'cloud/0081-the-scan-counts-calls-not-mentions'
branch 'cloud/0081-the-scan-counts-calls-not-mentions' set up to track 'origin/main'.
origin	https://github.com/artemis-owl/kestrel-team (fetch)
origin	https://github.com/artemis-owl/kestrel-team (push)
remote:
remote: Create a pull request for 'cloud/0081-the-scan-counts-calls-not-mentions' on GitHub by visiting:
remote:      https://github.com/artemis-owl/kestrel-team/pull/new/cloud/0081-the-scan-counts-calls-not-mentions
remote:
To https://github.com/artemis-owl/kestrel-team
 * [new branch]      cloud/0081-the-scan-counts-calls-not-mentions -> cloud/0081-the-scan-counts-calls-not-mentions
branch 'cloud/0081-the-scan-counts-calls-not-mentions' set up to track 'origin/cloud/0081-the-scan-counts-calls-not-mentions'.
```

Base is `origin/main` at 6af0114, as the goal expects.

**(2) Commits**

- `c8c8a05890f3309de5c7719ab2e9e6982c99ddbe` "connector_scan: count tool calls, not tool mentions (helm queue/0081)". Pushed: `6af0114..c8c8a05  cloud/0081-the-scan-counts-calls-not-mentions -> cloud/0081-the-scan-counts-calls-not-mentions`, and `git status -sb` showed the branch level with origin.

**(3) Gate**

- Command: `uv run --locked python -m pytest tests/ -q`
- Final line: `1281 passed in 83.69s (0:01:23)`
- `uv` 0.11.32 was already installed at `/root/.local/bin/uv`; I installed nothing.

**(4) DONE items**

1. **Vendor-JSON pattern (`kestrel_team/core/cloud_audit.py`): met.** It is replaced with the exact text given, which needs `"type"\s*:\s*"tool_use"` before `"name"`.
2. **API condensed-log pattern: met.** It is replaced with the exact text given: anchored to the line start, timestamp optional, `re.MULTILINE`.
3. **Comment (lines 81–89): met.** It now says an invocation is a line that IS the call and describes the three shapes. It also has the required line: "A `tool_result` line, or any other text, that quotes `"name": "x"` or `tool_use X:` is a mention, not a call, and does not count."
4. **docs/cloud.md §5 connector_scan: met.** The sentence is replaced with the given text, re-wrapped to fit the list indent.
5. **Two new tests: met.** They sit after `test_connector_scan_api_tool_use_format` in `tests/test_cloud_audit.py` and use `_check`, `_audit`, `_log` and `CLEAN_LOG`.
   - `test_connector_scan_ignores_name_keys_in_tool_results` uses the artemis line verbatim and asserts PASS and `{"Bash": 2, "Read": 1}`.
   - `test_connector_scan_ignores_quoted_tool_use_in_tool_results` asserts PASS, the same `tools_seen`, and that `"WebFetch"` is not in the reason.
   - With the old patterns put back, both fail (`2 failed, 1 passed, 76 deselected`). With the new ones, they pass.
6. **No other test changed.** The four existing tests the goal names still pass under the full gate.

**(5) Gaps**

- The line numbers in the task's test file (730–735, 187–192) were a few lines off from the actual file. I placed the tests by their content, not by number.
- I did not make the "Mark Active" / roadmap commits from CLAUDE.md's task protocol. This is a queue item with no roadmap entry, and the goal says "Nothing else changes."
- As TASK.md instructs, I opened no PR, sent no notification, never pushed to the task branch, and did not commit TASK.md.

**(6) Usage or cost figures:** none are visible to me in this session.
