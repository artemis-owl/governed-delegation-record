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

(The verifier is the first proof and is not here yet. Until it is, this repository is a scaffold.)

## Layout (planned)

```text
rows/            delivered rows per ledger instance, redacted to the public fields
packets/         evidence packets, never edited, each with its provenance
sessions/        vendor-run sessions mapped to the packet's schemas, with what closes and what cannot
verify.sh        the gate
```

Intent plane: practice-helm (`decisions/0001`, `CHARTER.md` §1). Apache-2.0.
