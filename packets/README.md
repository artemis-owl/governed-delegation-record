# packets/ — evidence packets, never edited

Each directory is one evidence packet exactly as `spawner evidence export` wrote it (kestrel-team
`docs/evidence_packet_contract.md`): `provenance.yaml`, `ledger_rows.jsonl` (the run's full ledger
rows, byte-verbatim), `pr_refs.txt`, `queue_item.md` and `transcripts/`. Nothing inside a packet
directory is ever modified; a packet that cannot be published as-is is excluded, not edited.

`SHA256SUMS` at this level (written by the verifier's `--write-sums`, checked on every run) covers
every file under every packet directory, so a changed byte anywhere fails the gate.

| Packet | Instance | Outcome / delivery | PR | Copied from |
| :--- | :--- | :--- | :--- | :--- |
| `run-1786647187/` | kestrel | done / delivered | https://github.com/wcorbett36/kestrel-team/pull/15 | kestrel-helm `evidence/exports/run-1786647187/`, 2026-10-18, `diff -r` clean |
