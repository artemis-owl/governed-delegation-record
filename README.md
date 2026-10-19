# governed-delegation-record

**Status: in progress, private until the first proof (practice-helm decisions/0001, chartered 2026-10-18).**

The governed-delegation record: the delivered rows of an ecosystem's agent-run ledgers (reduced to
id, date, instance, outcome, pull-request reference), the evidence packets that back them, and a
verifier that fails when any delivered row lacks a PR reference, when any packet's ledger rows
disagree with the ledger, or when a mapped vendor session fails the packet's checks.

It is the receipts behind an applied governance case study, published as an object a platform
leader can hand to an auditor, not as an essay. Its verifier is the same discipline as the
[Agent Audit Packet](https://github.com/artemis-owl/agent-audit-packet): one script, run in CI,
quoted output, nothing "done" without it.

## Verify it

```bash
./verify.sh
```

Bash and `python3 -I`, standard library only; no install, no network. Exit 0 when the record is
internally consistent, exit 1 naming the first failure. Output on this commit:

```text
ok   (a) rows: every line is a well-formed projected row (73 rows in 4 files: artemis 1, kestrel 62, korlith 2, lark 8)
ok   (b) rows: every delivered row has a pull-request pr_url (59 delivered)
ok   (c) rows: resumed runs counted, not failed (1: run-1788467602)
ok   (d) packet run-1786647187: provenance and 1 ledger row(s) match rows/; ledger_rows.jsonl:1 has no instance, searched rows/kestrel.jsonl
ok   (d) packet run-1786647187: pr_refs.txt and provenance runs[].pr_url agree with the packet rows (https://github.com/wcorbett36/kestrel-team/pull/15)
ok   (e) packets: SHA256SUMS covers every packet file and every sum matches (6 files)
ok   (f) session 0070-cloud-run-audit: corr-f39865b445dc0115 has 1 trace(s) and 5 evidence record(s); every trace's decision is 'deny' for audit verdict FAIL; RESULT.md records the packet verifier's exit
ok   (g) sessions: SHA256SUMS covers every source/ file and every sum matches (7 files)
PASS: record is internally consistent — rows: 73, delivered: 59, packets: 1, resumed runs: 1, sessions: 1
```

Strip the PR reference from a delivered row (here the korlith one) and it fails:

```text
FAIL (b) rows: every delivered row has a pull-request pr_url: rows/korlith.jsonl:2 run-1789581310 is delivered but pr_url is null
```

Flip the mapped vendor session's decision to `allow` when its trusted-host audit said FAIL and it fails:

```text
FAIL (f) session 0070-cloud-run-audit: sessions/0070-cloud-run-audit/packet/corr-f39865b445dc0115/decision_traces.jsonl:1 policy.decision 'allow' != 'deny' (audit verdict FAIL)
```

`./verify.sh --write-sums` regenerates `packets/SHA256SUMS` and `sessions/SHA256SUMS` (and checks nothing); plain
`./verify.sh` never writes.

## Layout

```text
rows/              one file per ledger instance, each row projected to seven public fields (rows/README.md)
packets/           evidence packets, byte-verbatim and never edited (packets/README.md)
packets/SHA256SUMS sums of every file under every packet directory, checked on every run
sessions/          vendor cloud-run sessions: source/ byte-verbatim, packet/corr-*/ in the Agent Audit
                   Packet layout, RESULT.md with the packet verifier's output (sessions/README.md)
sessions/SHA256SUMS sums of every file under every sessions/<id>/source/, checked on every run
verify.sh          the gate
```

Intent plane: practice-helm (`decisions/0001`, `CHARTER.md` §1). Apache-2.0.
