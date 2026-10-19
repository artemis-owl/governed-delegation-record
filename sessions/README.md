# sessions/ — vendor-run sessions, mapped to the packet's schemas

Each `sessions/<item_id>/` holds one run that a vendor cloud agent executed under the kestrel
delegation contract (kestrel-helm decisions/0023): `source/` is what the operator's side holds
about it, byte-verbatim and never edited — the vendor's RUN REPORT and condensed log as the
run-log API returned them, the prepared task (`prepared.json`, `TASK.delivered.md` — the delivered task file, renamed because the cloud audit refuses any `TASK.md` in a tip tree — and `refs_before.txt`),
and the trusted-host audit (`audit.json`, `audit.log`, from `spawner cloud audit`). `packet/`
is that run mapped into the Agent Audit Packet layout (decision traces, evidence, policy
metadata, schemas, observability pointers; github.com/artemis-owl/agent-audit-packet), and
`RESULT.md` is the packet verifier's output over it, quoted both ways: which of its checks
close on a vendor session, which cannot, and why.

`SHA256SUMS` at this level covers every file under every `source/`, checked by `./verify.sh`.
