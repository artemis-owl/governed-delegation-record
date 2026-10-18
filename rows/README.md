# rows/ — the ledgers, projected to their public fields

One file per ledger instance. Each line is one ledger row **projected** to seven fields and
nothing else: `thread_id`, `timestamp`, `instance`, `executor`, `outcome`, `delivery`, `pr_url`.
Fields absent from the source row are absent here (early kestrel rows predate `instance` and
`delivery`); nothing is inferred or added. Goals, token counts, costs, attempts and session ids are
not projected: they live in the source ledgers and, verbatim, in the evidence packets.

A resumed run appends a second row for the same `thread_id` (kestrel-team
`docs/evidence_packet_contract.md`, "The chain"); the verifier treats that as one run with two
rows, never as a duplicate.

| File | Source ledger | Rows | `delivery: delivered` |
| :--- | :--- | --: | --: |
| `kestrel.jsonl` | `~/.kestrel/runs.jsonl` | 62 | 51 |
| `lark.jsonl` | `~/.kestrel-lark/runs.jsonl` | 8 | 6 |
| `korlith.jsonl` | `~/.kestrel-korlith/runs.jsonl` | 2 | 1 |
| `artemis.jsonl` | `~/.kestrel-artemis/runs.jsonl` | 1 | 1 |
| **total** | | **73** | **59** |

Projected 2026-10-18 from the four `runs.jsonl` ledgers named above, by a stdlib-only script
(`python3 -I`), no LLM. Re-projecting from the same ledgers must reproduce these files byte for
byte; the verifier checks their shape, not their provenance.
