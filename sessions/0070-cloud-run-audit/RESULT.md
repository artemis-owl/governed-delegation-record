# 0070-cloud-run-audit — the packet verifier over a vendor session

Session `cse_01W6mixYaieBkixHXEvdpAdn` (claude-opus-5-5, 33 turns, 670 s; target
`wcorbett36/kestrel-team`, branch `cloud/0070-cloud-run-audit`, tip `a933123`) mapped into
`packet/corr-f39865b445dc0115/` and checked by the Agent Audit Packet's own verifier
(github.com/artemis-owl/agent-audit-packet at `cd4c2c6`, unmodified), run as:

```bash
cd /tmp/aap && ./verify.sh /home/user/governed-delegation-record/sessions/0070-cloud-run-audit/packet/corr-f39865b445dc0115
```

Full output (stdout and stderr), raw:

```text
packet: /home/user/governed-delegation-record/sessions/0070-cloud-run-audit/packet/corr-f39865b445dc0115
ok   schemas match SHA256SUMS
ok   1 decision trace(s), 5 evidence record(s) parse
ok   every trace cites the shipped policy bundle: sha256:2accc48376b4…
Traceback (most recent call last):
  File "<stdin>", line 22, in <module>
KeyError: 'policy_decision'
```

packet-verifier exit: 1
