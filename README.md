# governed-delegation-record

A record of work that AI agents delivered under governance, published so the governance can
be checked rather than described. It holds the delivery ledger of one small ecosystem of
agent-run projects, the evidence packets behind those deliveries, three vendor cloud sessions
mapped into auditable packets, and a verifier that fails when any of it disagrees with
itself.

Five tenants appear in the ledger. **kestrel** is the engine: the harness that commissions,
runs and audits delegated work, with its satellite repos. **lark** and **korlith** are two
products that took governed deliveries from it. **artemis** is the professional site of the
practice that runs the other three. **practice** is the professional practice that runs the other
four; this record is its product, and its two rows are the first runs that reached the ledger from
the vendor's cloud path. `instances.jsonl` names each with its repository, and
the verifier refuses a ledger file with no listed tenant.

## Check it yourself

```bash
./verify.sh
```

Bash and `python3 -I`, standard library only; no install, no network. Exit 0 when the record
is internally consistent, exit 1 naming the first failure. Its output on this commit — and
check (j) fails if this block stops matching what it prints:

<!-- verify:begin -->
```text
ok   (a) rows: every line is a well-formed projected row (94 rows in 5 files: artemis 7, kestrel 75, korlith 2, lark 8, practice 2)
ok   (b) rows: every delivered row has a pull-request pr_url (72 delivered)
ok   (c) rows: resumed runs counted, not failed (1: run-1788467602)
ok   (d) packet cloud-0002-downloads-page-links-the-record: provenance and 1 ledger row(s) match rows/
ok   (d) packet cloud-0002-downloads-page-links-the-record: pr_refs.txt and provenance runs[].pr_url agree with the packet rows (none)
ok   (d) packet cloud-0003-downloads-page-links-the-record: provenance and 1 ledger row(s) match rows/
ok   (d) packet cloud-0003-downloads-page-links-the-record: pr_refs.txt and provenance runs[].pr_url agree with the packet rows (none)
ok   (d) packet cloud-0004-downloads-page-links-the-record: provenance and 1 ledger row(s) match rows/
ok   (d) packet cloud-0004-downloads-page-links-the-record: pr_refs.txt and provenance runs[].pr_url agree with the packet rows (https://github.com/artemis-owl/artemis_home/pull/17)
ok   (d) packet cloud-0004-legibility-pass: provenance and 1 ledger row(s) match rows/
ok   (d) packet cloud-0004-legibility-pass: pr_refs.txt and provenance runs[].pr_url agree with the packet rows (none)
ok   (d) packet cloud-0005-a-gate-nobody-ran-passed: provenance and 1 ledger row(s) match rows/
ok   (d) packet cloud-0005-a-gate-nobody-ran-passed: pr_refs.txt and provenance runs[].pr_url agree with the packet rows (https://github.com/artemis-owl/artemis_home/pull/18)
ok   (d) packet cloud-0005-record-urls-to-artemis-owl: provenance and 1 ledger row(s) match rows/
ok   (d) packet cloud-0005-record-urls-to-artemis-owl: pr_refs.txt and provenance runs[].pr_url agree with the packet rows (https://github.com/artemis-owl/governed-delegation-record/pull/7)
ok   (d) packet cloud-0007-the-boundary-is-chief-editor-not-sole-author: provenance and 1 ledger row(s) match rows/
ok   (d) packet cloud-0007-the-boundary-is-chief-editor-not-sole-author: pr_refs.txt and provenance runs[].pr_url agree with the packet rows (none)
ok   (d) packet cloud-0008-the-provenance-check-lands-green: provenance and 1 ledger row(s) match rows/
ok   (d) packet cloud-0008-the-provenance-check-lands-green: pr_refs.txt and provenance runs[].pr_url agree with the packet rows (https://github.com/artemis-owl/artemis_home/pull/19)
ok   (d) packet cloud-0072-ruling-contract-and-helm-doctor: provenance and 1 ledger row(s) match rows/
ok   (d) packet cloud-0072-ruling-contract-and-helm-doctor: pr_refs.txt and provenance runs[].pr_url agree with the packet rows (none)
ok   (d) packet cloud-0076-cloud-instance-flag-portable: provenance and 1 ledger row(s) match rows/
ok   (d) packet cloud-0076-cloud-instance-flag-portable: pr_refs.txt and provenance runs[].pr_url agree with the packet rows (none)
ok   (d) packet cloud-0077-containment-accounts-for-known-refs: provenance and 1 ledger row(s) match rows/
ok   (d) packet cloud-0077-containment-accounts-for-known-refs: pr_refs.txt and provenance runs[].pr_url agree with the packet rows (none)
ok   (d) packet cloud-0078-connector-scan-reads-the-api-log: provenance and 1 ledger row(s) match rows/
ok   (d) packet cloud-0078-connector-scan-reads-the-api-log: pr_refs.txt and provenance runs[].pr_url agree with the packet rows (none)
ok   (d) packet cloud-0079-cloud-ingest-never-accepts-silence: provenance and 1 ledger row(s) match rows/
ok   (d) packet cloud-0079-cloud-ingest-never-accepts-silence: pr_refs.txt and provenance runs[].pr_url agree with the packet rows (https://github.com/artemis-owl/kestrel-team/pull/39)
ok   (d) packet cloud-0080-a-gate-is-one-argv: provenance and 1 ledger row(s) match rows/
ok   (d) packet cloud-0080-a-gate-is-one-argv: pr_refs.txt and provenance runs[].pr_url agree with the packet rows (https://github.com/artemis-owl/kestrel-team/pull/40)
ok   (d) packet cloud-0081-the-scan-counts-calls-not-mentions: provenance and 1 ledger row(s) match rows/
ok   (d) packet cloud-0081-the-scan-counts-calls-not-mentions: pr_refs.txt and provenance runs[].pr_url agree with the packet rows (https://github.com/artemis-owl/kestrel-team/pull/41)
ok   (d) packet cloud-0082-the-scan-reads-call-lines-only: provenance and 1 ledger row(s) match rows/
ok   (d) packet cloud-0082-the-scan-reads-call-lines-only: pr_refs.txt and provenance runs[].pr_url agree with the packet rows (https://github.com/artemis-owl/kestrel-team/pull/42)
ok   (d) packet cloud-0083-containment-accounts-for-the-operators-merge: provenance and 1 ledger row(s) match rows/
ok   (d) packet cloud-0083-containment-accounts-for-the-operators-merge: pr_refs.txt and provenance runs[].pr_url agree with the packet rows (https://github.com/artemis-owl/kestrel-team/pull/43)
ok   (d) packet cloud-0084-a-connector-call-is-a-called-tool: provenance and 1 ledger row(s) match rows/
ok   (d) packet cloud-0084-a-connector-call-is-a-called-tool: pr_refs.txt and provenance runs[].pr_url agree with the packet rows (https://github.com/artemis-owl/kestrel-team/pull/44)
ok   (d) packet cloud-0085-a-squash-without-a-pr-is-the-runs-own-push: provenance and 1 ledger row(s) match rows/
ok   (d) packet cloud-0085-a-squash-without-a-pr-is-the-runs-own-push: pr_refs.txt and provenance runs[].pr_url agree with the packet rows (https://github.com/artemis-owl/kestrel-team/pull/45)
ok   (d) packet cloud-0086-toolsearch-is-a-pinned-tool: provenance and 1 ledger row(s) match rows/
ok   (d) packet cloud-0086-toolsearch-is-a-pinned-tool: pr_refs.txt and provenance runs[].pr_url agree with the packet rows (https://github.com/artemis-owl/kestrel-team/pull/46)
ok   (d) packet cloud-0087-a-sha-the-task-names-is-a-reference: provenance and 1 ledger row(s) match rows/
ok   (d) packet cloud-0087-a-sha-the-task-names-is-a-reference: pr_refs.txt and provenance runs[].pr_url agree with the packet rows (https://github.com/artemis-owl/kestrel-team/pull/47)
ok   (d) packet run-1786647187: provenance and 1 ledger row(s) match rows/; ledger_rows.jsonl:1 has no instance, searched rows/kestrel.jsonl
ok   (d) packet run-1786647187: pr_refs.txt and provenance runs[].pr_url agree with the packet rows (https://github.com/artemis-owl/kestrel-team/pull/15)
ok   (e) packets: SHA256SUMS covers every packet file and every sum matches (116 files)
ok   (f) session 0007-the-boundary-is-chief-editor-not-sole-author: corr-d08f7d5b44d1d6ac has 1 trace(s) and 1 evidence record(s); every trace's decision is 'deny' for audit verdict FAIL; RESULT.md records the packet verifier's exit
ok   (f) session 0008-the-provenance-check-lands-green-audit-1: corr-3647e23e77b854e6 has 1 trace(s) and 2 evidence record(s); every trace's decision is 'deny' for audit verdict FAIL; RESULT.md records the packet verifier's exit
ok   (f) session 0070-cloud-run-audit: corr-f39865b445dc0115 has 1 trace(s) and 5 evidence record(s); every trace's decision is 'deny' for audit verdict FAIL; RESULT.md records the packet verifier's exit
ok   (g) sessions: SHA256SUMS covers every source/ file and every sum matches (19 files)
ok   (h) controls: CONTROLS.md matches the verifier's control table (7 checks)
ok   (i) instances: every rows file names a listed tenant and every listed tenant has a rows file (5)
ok   (k) redaction: no home path and no e-mail address in rows/, packets/ or sessions/ (169 files)
ok   (j) readme: the quoted verifier output and the overhead table in README.md match this run
PASS: record is internally consistent — rows: 94, delivered: 72, packets: 22, resumed runs: 1, sessions: 3
```
<!-- verify:end -->

Strip the PR reference from a delivered row (here the korlith one) and it fails:

```text
FAIL (b) rows: every delivered row has a pull-request pr_url: rows/korlith.jsonl:2 run-1789581310 is delivered but pr_url is null
```

Flip the mapped vendor session's decision to `allow` when its trusted-host audit said FAIL
and it fails:

```text
FAIL (f) session 0070-cloud-run-audit: sessions/0070-cloud-run-audit/packet/corr-f39865b445dc0115/decision_traces.jsonl:1 policy.decision 'allow' != 'deny' (audit verdict FAIL)
```

## The overhead, measured

What governing the runs cost, counted from this record's own files and nothing else, at this
commit (`./verify.sh --overhead` prints it; check (j) fails if this block stops matching):

<!-- overhead:begin -->
```text
Governance overhead by tenant, computed from rows/, packets/ and sessions/ of this commit:
tenant    rows  done  delivered  delivered/rows  packets  ingest audit PASS  ingest audit not PASS  failed audits kept as sessions
artemis      7     5          4             57%        6                  4                      2                               2
kestrel     75    58         60             80%       14                  9                      4                               1
korlith      2     0          1             50%        0                  0                      0                               0
lark         8     6          6             75%        0                  0                      0                               0
practice     2     0          1             50%        2                  0                      2                               0
all         94    69         72             77%       22                 13                      8                               3
not measured here: time to delivery (a projected row carries one timestamp; every cloud packet's duration_seconds is 0.0) and interventions inside a run (the run logs hold them, uncounted)
```
<!-- overhead:end -->

`ingest audit` is the trusted-host audit's verdict recorded in each packet's ledger row at ingest;
`failed audits kept as sessions` counts the audits that did not pass and were published under
`sessions/` rather than discarded. Every number here is recomputed from `rows/`, `packets/` and
`sessions/` on each run, so it is a fact about the commit you are reading, not a status.

## What it holds

- `rows/` — one file per tenant. Each line is one ledger row projected to seven fields:
  `thread_id`, `timestamp`, `instance`, `executor`, `outcome`, `delivery`, `pr_url`. Goals,
  costs, token counts and session ids are not projected; they live, verbatim, in the packets.
  A resumed run is a second row with the same `thread_id`, counted as one run.
  A run executed on the vendor's cloud path carries a `cloud-<item>` thread id; its row and packet
  are what `spawner cloud ingest` wrote from the trusted-host audit.
  The four kestrel cloud rows of 2026-10-29/30 read `undelivered` with no `pr_url` because each
  was ingested before its pull request was opened; the merges are recorded in the tenant's helm,
  not here.
  The artemis rows `cloud-0002` and `cloud-0003` read `undelivered` because those runs stopped at
  their environment precondition and shipped nothing; `cloud-0004` is the same item delivered.
  The pull requests the rows reference live in private repositories; the verifier checks that
  every delivered row names one, not that a reader can open it.
- `packets/` — evidence packets exactly as the engine exported them: provenance, the run's
  full ledger rows, its PR references, the task as commissioned, and the transcripts. Never
  edited; a packet that cannot be published as-is is excluded, not changed. The exceptions, stated here so they can
  be checked: paths under the operator's home directory are shortened to `~`, an e-mail address reads
  `redacted`, and repository URLs name the organization the repositories moved to; no other byte is
  changed. Check (k) fails on a home path or an e-mail address anywhere in the evidence.
- `sessions/` — runs executed by a vendor cloud agent, one directory each. `source/` is what the commissioning
  side holds about it (the task, the vendor's run report and log, the trusted-host audit),
  byte-verbatim except those same two redactions, and repository URLs name the organization the
  repositories moved to; `packet/` is that run mapped into the
  [Agent Audit Packet](https://github.com/artemis-owl/agent-audit-packet) layout;
  `RESULT.md` is that packet verifier's raw output over it.
- `CONTROLS.md` — per check, the NIST AI RMF, ISO/IEC 42001, OWASP Agentic Top 10 and EU AI
  Act Art. 12 item it evidences. An argued mapping, not a certification claim; generated from
  the verifier's own table, and check (h) fails if the two differ by a byte.
- `SHA256SUMS` in `packets/` and `sessions/` pin every packet file and every session source
  file. `./verify.sh --write-sums` regenerates them and checks nothing; plain `./verify.sh`
  never writes.

## The vendor sessions

The first mapped session reported `1187 passed` and `result: success`. The trusted-host audit
re-ran the same gate on the same commit and got `1 failed, 1186 passed`, so the recorded
decision is `deny`: five pushes happened, and the policy that judges them did not allow
them. The packet verifier closes its first three checks on that session and cannot run the
fourth, because a vendor's log does not say which decision each action was taken under.

The other two sessions are audits that did not pass, kept rather than discarded. In
`0007-the-boundary-is-chief-editor-not-sole-author` the work failed its own gate. In
`0008-the-provenance-check-lands-green-audit-1` the auditor failed: it read a commit the task had
named as one the run claimed; the engine fix that followed is why the same run's row reads
`delivered`. Both were mapped by the packet's `map-session.sh` and checked by its `verify.sh`,
whose per-check lines each `RESULT.md` quotes.

Intent plane: practice-helm. Apache-2.0.
