There is no rego: no policy engine decided this push before it happened.
The policy is the five checks of `spawner cloud audit` (fetch_and_match, containment, host_gate, mutation, connector_scan; kestrel-team docs/cloud.md), and bundle_hash is sha256 over the audit's declared gate string, a newline, and its mutation string.
