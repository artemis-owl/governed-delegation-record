# .agent-context/ — read before touching this repo

## Verification gate

```
./verify.sh
```

Exit 0 and the output quoted; CI runs it on every push.

## Conventions

- Nothing is written down unless something enforces it (practice-helm CHARTER.md §2): a file here is data, verify.sh, or output verify.sh generates and checks; README.md is the one exception; task status and findings live in practice-helm queue/, never here.
- rows/, packets/<id>/ and sessions/<id>/source/ are never edited; any rename or addition under them needs `./verify.sh --write-sums`.
- Never commit a TASK.md — the cloud audit refuses any TASK.md in the tip tree.
- Never touch .github/ — containment forbids it; CI changes are attended commits.
