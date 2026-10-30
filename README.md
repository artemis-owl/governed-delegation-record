# governed-delegation-record

A record of work that AI agents delivered under governance, published so the governance can
be checked rather than described. It holds the delivery ledger of one small ecosystem of
agent-run projects, the evidence packets behind those deliveries, one vendor cloud session
mapped into an auditable packet, and a verifier that fails when any of it disagrees with
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
ok   (a) rows: every line is a well-formed projected row (75 rows in 5 files: artemis 1, kestrel 62, korlith 2, lark 8, practice 2)
ok   (b) rows: every delivered row has a pull-request pr_url (60 delivered)
ok   (c) rows: resumed runs counted, not failed (1: run-1788467602)
ok   (d) packet cloud-0004-legibility-pass: provenance and 1 ledger row(s) match rows/
ok   (d) packet cloud-0004-legibility-pass: pr_refs.txt and provenance runs[].pr_url agree with the packet rows (none)
ok   (d) packet cloud-0005-record-urls-to-artemis-owl: provenance and 1 ledger row(s) match rows/
ok   (d) packet cloud-0005-record-urls-to-artemis-owl: pr_refs.txt and provenance runs[].pr_url agree with the packet rows (https://github.com/artemis-owl/governed-delegation-record/pull/7)
ok   (d) packet run-1786647187: provenance and 1 ledger row(s) match rows/; ledger_rows.jsonl:1 has no instance, searched rows/kestrel.jsonl
ok   (d) packet run-1786647187: pr_refs.txt and provenance runs[].pr_url agree with the packet rows (https://github.com/artemis-owl/kestrel-team/pull/15)
ok   (e) packets: SHA256SUMS covers every packet file and every sum matches (13 files)
ok   (f) session 0070-cloud-run-audit: corr-f39865b445dc0115 has 1 trace(s) and 5 evidence record(s); every trace's decision is 'deny' for audit verdict FAIL; RESULT.md records the packet verifier's exit
ok   (g) sessions: SHA256SUMS covers every source/ file and every sum matches (7 files)
ok   (h) controls: CONTROLS.md matches the verifier's control table (7 checks)
ok   (i) instances: every rows file names a listed tenant and every listed tenant has a rows file (5)
ok   (j) readme: the quoted verifier output in README.md matches this run
PASS: record is internally consistent — rows: 75, delivered: 60, packets: 3, resumed runs: 1, sessions: 1
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

## What it holds

- `rows/` — one file per tenant. Each line is one ledger row projected to seven fields:
  `thread_id`, `timestamp`, `instance`, `executor`, `outcome`, `delivery`, `pr_url`. Goals,
  costs, token counts and session ids are not projected; they live, verbatim, in the packets.
  A resumed run is a second row with the same `thread_id`, counted as one run.
  A run executed on the vendor's cloud path carries a `cloud-<item>` thread id; its row and packet
  are what `spawner cloud ingest` wrote from the trusted-host audit.
  The pull requests the rows reference live in private repositories; the verifier checks that
  every delivered row names one, not that a reader can open it.
- `packets/` — evidence packets exactly as the engine exported them: provenance, the run's
  full ledger rows, its PR references, the task as commissioned, and the transcripts. Never
  edited; a packet that cannot be published as-is is excluded, not changed. One exception, stated here so it can
  be checked: paths under the operator's home directory are shortened to `~`, and repository URLs name
  the organization the repositories moved to; no other byte is changed.
- `sessions/` — a run executed by a vendor cloud agent. `source/` is what the commissioning
  side holds about it (the task, the vendor's run report and log, the trusted-host audit),
  byte-verbatim except that same `~` shortening, and repository URLs name the organization the
  repositories moved to; `packet/` is that run mapped into the
  [Agent Audit Packet](https://github.com/artemis-owl/agent-audit-packet) layout;
  `RESULT.md` is that packet verifier's raw output over it.
- `CONTROLS.md` — per check, the NIST AI RMF, ISO/IEC 42001, OWASP Agentic Top 10 and EU AI
  Act Art. 12 item it evidences. An argued mapping, not a certification claim; generated from
  the verifier's own table, and check (h) fails if the two differ by a byte.
- `SHA256SUMS` in `packets/` and `sessions/` pin every packet file and every session source
  file. `./verify.sh --write-sums` regenerates them and checks nothing; plain `./verify.sh`
  never writes.

## The vendor session

The one mapped session reported `1187 passed` and `result: success`. The trusted-host audit
re-ran the same gate on the same commit and got `1 failed, 1186 passed`, so the recorded
decision is `deny`: five pushes happened, and the policy that judges them did not allow
them. The packet verifier closes its first three checks on that session and cannot run the
fourth, because a vendor's log does not say which decision each action was taken under.

Intent plane: practice-helm. Apache-2.0.
