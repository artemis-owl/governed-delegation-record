# .agent-context/ — copy into each product repo

Everything an executor must know before touching this repo, injected into
every delegated task's prompt. Keep it to what a careful new contributor would
need on day one:

## Verification gate (charter §1, spelled as commands)

```
{{exact test command(s) — e.g. venv/bin/python -m pytest -q}}
```

Nothing is "done" without this passing and its real output quoted.

## Conventions

- {{code style / structure norms that are not obvious from reading the code}}
- {{where task lifecycle lives — e.g. ROADMAP.md statuses; agents update
  statuses, humans set scope and priority}}
- {{anything that has bitten before — the findings a fresh agent would
  otherwise rediscover at full turn price}}
