RUN REPORT of session cse_01Buwmo7yHoPpzy9eEZutxD1 (https://claude.ai/code/session_01Buwmo7yHoPpzy9eEZutxD1), routine trig_01P41RrisHWSUXUw6xCtPx7b. Read 2026-10-30 from the session page in the seat's browser pane (signed in by the operator); the "(1) STEP 0 raw output" block, which the page renders without text, is taken from the same message in the API run log (RemoteTrigger get_run_log), where it is complete.

# RUN REPORT

The change is done and the full gate passes. The containment check in `cloud audit` no longer fails on ref changes it can explain. It is one commit, pushed to `cloud/0077-containment-accounts-for-known-refs`. TASK.md's sha256 matched `869e807d4fd21b6dd268131e36417e768a15d7beb97020d096a4b8bf6d4f7c88`.

**(1) STEP 0 raw output**

```
From https://github.com/artemis-owl/kestrel-team
 * branch            main       -> FETCH_HEAD
   025c423..79557d0  main       -> origin/main
Switched to a new branch 'cloud/0077-containment-accounts-for-known-refs'
branch 'cloud/0077-containment-accounts-for-known-refs' set up to track 'origin/main'.
origin	https://github.com/artemis-owl/kestrel-team (fetch)
origin	https://github.com/artemis-owl/kestrel-team (push)
remote:
remote: Create a pull request for 'cloud/0077-containment-accounts-for-known-refs' on GitHub by visiting:
remote:      https://github.com/artemis-owl/kestrel-team/pull/new/cloud/0077-containment-accounts-for-known-refs
remote:
To https://github.com/artemis-owl/kestrel-team
 * [new branch]      cloud/0077-containment-accounts-for-known-refs -> cloud/0077-containment-accounts-for-known-refs
branch 'cloud/0077-containment-accounts-for-known-refs' set up to track 'origin/cloud/0077-containment-accounts-for-known-refs'.
```

The base is `origin/main` at `79557d0`, which is queue/0076 merged as #35.

**(2) Commits**

- `65af10b` cloud audit: containment accounts for refs it can explain (helm queue/0077)
- Pushed: `79557d0..65af10b  cloud/0077-containment-accounts-for-known-refs -> cloud/0077-containment-accounts-for-known-refs`
- `git status` afterwards showed the branch level with its remote.

**(3) Gate**

- Command: `uv run --locked python -m pytest tests/ -q`
- Final line: `1229 passed in 71.11s (0:01:11)`
- `uv` 0.11.32 was already installed at `/root/.local/bin/uv`, so I did not install it.

**(4) DONE items**

- **Changes are accounted for and listed with a reason:** met. A ref change the audit can explain goes into `details["refs_accounted"]` with its reason and is not a FAIL. The decision is made by a new helper, `_account_for`, in `kestrel_team/core/cloud_audit.py`.
- **(a) Another prepared run's branches:** met. `OTHER_RUN_PREFIXES = ("refs/heads/task/", "refs/heads/cloud/")` is written once, as code. A ref under it counts only if its suffix names an item with a `prepared.json` under `cloud.cloud_runs_dir()`. That item must not be this run's own, and the suffix may not contain `/`, `.` or `..`.
- **(b) PR heads:** met. An added `refs/pull/<n>/head` counts. A moved one does not.
- **(c) Someone else's merge to the default branch:** met.
  - The default branch is read from the audit clone's `origin/HEAD`.
  - The old sha must be an ancestor of the new one (`merge-base --is-ancestor`).
  - The commits in `old..new` must share none with the work branch's `base..tip`.
- **Everything else still FAILs, naming each ref:** met. This run's own task branch moving still FAILs, and its existing test still passes.
- **A deleted ref is never accounted for:** met. Deleted refs are never passed to the helper.
- **Tests in `tests/test_cloud_audit.py`:** met.
  - Cases that PASS with the ref listed as accounted:
    - (a) `test_containment_other_prepared_runs_branches_are_accounted`
    - (b) `test_containment_pull_head_added_is_accounted`
    - (c) `test_containment_main_fast_forwarded_by_someone_else_is_accounted`
  - Cases that FAIL:
    - a `task/<id>` with no prepared run: `test_containment_task_branch_without_prepared_run_fails`
    - main moved to include a work commit: `test_containment_main_moved_to_include_a_work_commit_fails`
    - a deleted ref: `test_containment_deleted_other_run_branch_is_never_accounted`, plus the existing `test_containment_deleted_ref_fails`
- **`docs/cloud.md` and `CHANGELOG.md`:** met. The containment paragraph in `docs/cloud.md` is updated, and there is a new entry in `CHANGELOG.md` under Unreleased → Fixed.
- **Portable fixtures:** met. The fixtures use only git commands, with no `sed -i`. The 0076 portability test passes within the full run.

**(5) Gaps and judgement calls**

- Rewrote an existing test. The old `test_containment_main_moved_fails` pushed a fast-forward to main, which is now case (c) and passes. I changed it to rewrite main onto an unrelated root, which still FAILs.
- Case (c) depends on the clone knowing the default branch. If the remote's HEAD points at a branch that doesn't exist, the clone has no `origin/HEAD`. Case (c) then can't apply and the move FAILs, which is the cautious outcome. For this reason the test fixtures point the bare repo's HEAD at main.
- Case (c) also needs the work branch on the remote. If the work branch is missing, the main move FAILs.
- No `ROADMAP.md` entry or "Mark Active" commit. The goal said "Nothing else changes" and listed only the docs and changelog, so I followed it over CLAUDE.md's task protocol.
- No pull request opened and no notification sent, as TASK.md instructed.

**(6) Usage and cost**

No usage, token or cost figures are visible to me.
