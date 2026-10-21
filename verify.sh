#!/usr/bin/env bash
# verify.sh — the gate for governed-delegation-record.
#
#   ./verify.sh               check the record; exit 0 when internally consistent,
#                             exit 1 naming the first failure otherwise. Writes nothing.
#   ./verify.sh --write-sums  (re)write packets/SHA256SUMS and sessions/SHA256SUMS and exit 0
#                             without checking.
#   ./verify.sh --controls    print, per check, the controls it evidences and exit 0 without
#                             checking; add --markdown for the table CONTROLS.md is generated from.
#
# Stack: bash + python3 -I, standard library only. No network, no dependencies.
set -euo pipefail
cd "$(dirname "$0")"
exec python3 -I - "$@" <<'PY'
import hashlib
import json
import re
import sys
from pathlib import Path

KEYS = ("thread_id", "timestamp", "instance", "executor", "outcome", "delivery", "pr_url")
THREAD_RE = re.compile(r"^run-\d+$")
TS_RE = re.compile(r"^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}(\.\d+)?(Z|[+-]\d{2}:\d{2})?$")
PR_RE = re.compile(r"^https://github\.com/[^/]+/[^/]+/pull/\d+$")
OUTCOMES = {"done", "retry-cap", "timebox", "aborted"}
DELIVERIES = {"delivered", "undelivered", "skipped"}

ROWS = Path("rows")
PACKETS = Path("packets")
SUMS = PACKETS / "SHA256SUMS"
SESSIONS = Path("sessions")
SESSION_SUMS = SESSIONS / "SHA256SUMS"
VERIFIER_EXIT_RE = re.compile(r"^packet-verifier exit: \d+$", re.M)
CONTROLS_MD = Path("CONTROLS.md")
INSTANCE_KEYS = ("instance", "repo", "about")
REPO_RE = re.compile(r"^https://github\.com/[^/]+/[^/]+$")

# The control map: one row per check, letter -> (title as printed, NIST AI RMF, ISO/IEC 42001,
# OWASP Agentic Top 10, EU AI Act, rationale). An argued mapping, not a certification claim.
CONTROLS = [
    ("a", "rows: every line is a well-formed projected row",
     "NIST AI RMF GOVERN 1.5",
     "ISO/IEC 42001 7.5 Documented information; A.6.2.8 AI system recording of event logs",
     "OWASP ASI10 Rogue Agents",
     "EU AI Act Art. 12(1)",
     "every governed run leaves an automatic, well-formed record over the system's lifetime; "
     "an agent run with no row is the rogue the inventory would miss."),
    ("b", "rows: every delivered row has a pull-request pr_url",
     "NIST AI RMF MANAGE 4.1",
     "ISO/IEC 42001 A.6.2.6 AI system operation and monitoring; 9.1 Monitoring, measurement, analysis and evaluation",
     "OWASP ASI05 Unexpected Code Execution",
     "EU AI Act Art. 12(2)(c)",
     "a delivery exists only as a reviewable pull request, never as code that ran into main; "
     "the deployer can monitor what was changed and by which run."),
    ("c", "rows: resumed runs counted, not failed",
     "NIST AI RMF MEASURE 3.1",
     "ISO/IEC 42001 10.2 Nonconformity and corrective action",
     "OWASP ASI08 Cascading Failures",
     "EU AI Act Art. 12(2)(a)",
     "a resumed run is a contained failure kept visible as a second row, not collapsed into a "
     "clean story; the situations that may present risk stay identifiable."),
    ("d", "packet <id>: provenance and ledger rows match rows/, and pr_refs.txt and provenance "
          "runs[].pr_url agree with the packet rows",
     "NIST AI RMF MEASURE 2.8",
     "ISO/IEC 42001 A.7.5 Data provenance; A.6.2.8 AI system recording of event logs",
     "OWASP ASI09 Human-Agent Trust Exploitation",
     "EU AI Act Art. 12(2)(b)",
     "the evidence packet, the ledger and the PR reference agree with each other, so a reader "
     "trusts the record, not the agent's report of itself; this is the post-market monitoring data."),
    ("e", "packets: SHA256SUMS covers every packet file and every sum matches",
     "NIST AI RMF MEASURE 2.7",
     "ISO/IEC 42001 7.5.3 Control of documented information",
     "OWASP ASI04 Agentic Supply Chain Vulnerabilities",
     "EU AI Act Art. 12(1)",
     "packet bytes are hash-covered; a changed byte anywhere fails the gate, so the record's "
     "integrity holds over its lifetime."),
    ("f", "session <id>: trace and evidence records parse, every trace's decision matches the "
          "audit verdict, RESULT.md records the packet verifier's exit",
     "NIST AI RMF MANAGE 2.4",
     "ISO/IEC 42001 9.2 Internal audit; A.6.2.6 AI system operation and monitoring",
     "OWASP ASI02 Tool Misuse and Exploitation",
     "EU AI Act Art. 12(2)(a)",
     "a vendor session's actions are judged by a trusted-host audit after the fact (containment, "
     "gate, mutation, connector scan); a deny verdict is recorded as a deny, and the mapped "
     "decision cannot disagree with it."),
    ("g", "sessions: SHA256SUMS covers every source/ file and every sum matches",
     "NIST AI RMF MEASURE 2.7",
     "ISO/IEC 42001 7.5.3 Control of documented information",
     "OWASP ASI04 Agentic Supply Chain Vulnerabilities",
     "EU AI Act Art. 12(1)",
     "the vendor-run source files are hash-covered exactly as packets are."),
]
FRAMEWORKS = ("NIST AI RMF", "ISO/IEC 42001", "OWASP", "EU AI Act")


PRINTED = []


def ok(what):
    line = f"ok   {what}"
    PRINTED.append(line)
    print(line)


def fail(what, detail):
    print(f"FAIL {what}: {detail}")
    sys.exit(1)


def packet_dirs():
    return sorted(p for p in PACKETS.iterdir() if p.is_dir())


def expected_sums():
    lines = []
    for d in packet_dirs():
        for f in sorted(p for p in d.rglob("*") if p.is_file()):
            rel = f.relative_to(PACKETS).as_posix()
            lines.append(f"{hashlib.sha256(f.read_bytes()).hexdigest()}  {rel}")
    return sorted(lines, key=lambda l: l.split("  ", 1)[1])


def session_dirs():
    return sorted(p for p in SESSIONS.iterdir() if p.is_dir()) if SESSIONS.is_dir() else []


def expected_session_sums():
    lines = []
    for d in session_dirs():
        for f in sorted(p for p in (d / "source").rglob("*") if p.is_file()):
            rel = f.relative_to(SESSIONS).as_posix()
            lines.append(f"{hashlib.sha256(f.read_bytes()).hexdigest()}  {rel}")
    return sorted(lines, key=lambda l: l.split("  ", 1)[1])


def check_sums(what, sums, want, label, owner):
    if not sums.is_file():
        fail(what, f"{sums} missing (run ./verify.sh --write-sums)")
    have = sums.read_text(encoding="utf-8").splitlines()
    want_by_path = {l.split("  ", 1)[1]: l for l in want}
    for n, line in enumerate(have, 1):
        m = re.match(r"^([0-9a-f]{64})  (\S.*)$", line)
        if not m:
            fail(what, f"{label}:{n} is not a `sha256  path` line: {line!r}")
        if m.group(2) not in want_by_path:
            fail(what, f"{label}:{n} lists {m.group(2)!r}, not a file under any {owner}")
        if want_by_path[m.group(2)] != line:
            fail(what, f"{label}:{n} sum mismatch for {m.group(2)}")
    paths = [l.split("  ", 1)[1] for l in have]
    for p in sorted(set(want_by_path) - set(paths)):
        fail(what, f"{p} is not listed")
    if len(paths) != len(set(paths)):
        fail(what, "a path is listed more than once")
    if paths != sorted(paths):
        fail(what, "lines are not in sorted path order")
    return len(have)


def read_jsonl(path, what):
    out = []
    for n, line in enumerate(path.read_text(encoding="utf-8").splitlines(), 1):
        try:
            obj = json.loads(line)
        except json.JSONDecodeError as e:
            fail(what, f"{path}:{n} does not parse as JSON ({e.msg})")
        if not isinstance(obj, dict):
            fail(what, f"{path}:{n} is not a JSON object")
        out.append((n, obj))
    return out


def project(row):
    return {k: row[k] for k in KEYS if k in row}


def read_provenance(path):
    """Line-based reader for the top-level scalars and the runs: list items."""
    def scalar(v):
        v = v.strip()
        if len(v) >= 2 and v[0] == v[-1] and v[0] in "'\"":
            return v[1:-1]
        return None if v in ("null", "~", "") else v

    top, runs, section = {}, [], None
    for line in path.read_text(encoding="utf-8").splitlines():
        if not line.strip() or line.lstrip().startswith("#"):
            continue
        if not line.startswith((" ", "-")):
            key, _, val = line.partition(":")
            section = key.strip()
            top[section] = scalar(val)
            continue
        if section != "runs":
            continue
        m = re.match(r"^(- |  )([A-Za-z_]+):(.*)$", line)
        if not m:
            continue
        if m.group(1) == "- ":
            runs.append({})
        if runs:
            runs[-1][m.group(2)] = scalar(m.group(3))
    return top, runs


def control_codes(row):
    """The four codes of a CONTROLS row, each without its framework prefix."""
    return [code[len(fw) + 1:] for fw, code in zip(FRAMEWORKS, row[2:6])]


def controls_text():
    out = ["Control map: per check, the control it evidences "
           "(argued mapping, 2026-10-19; not a certification claim)"]
    for row in CONTROLS:
        out.append(f"{row[0]}  {row[1]}")
        out.append("     " + "  | ".join(f"{fw}: {c}" for fw, c in zip(FRAMEWORKS, control_codes(row))))
    return "".join(l + "\n" for l in out)


def controls_markdown():
    out = [
        "# Controls",
        "",
        "The mapping below was drafted by the practice on 2026-10-19 from steering's "
        "docs/control-map.md and the standards named; it is an ARGUED mapping, not a "
        "certification claim. The frameworks are outcome-level; the sub-outcome "
        "codes are the practice's reading of them.",
        "",
        "| Check | NIST AI RMF | ISO/IEC 42001 | OWASP Agentic Top 10 (2026) | EU AI Act | Why |",
        "| :- | :- | :- | :- | :- | :- |",
    ]
    for row in CONTROLS:
        title = row[1].replace("<", "&lt;").replace(">", "&gt;")
        out.append("| " + " | ".join([f"({row[0]}) {title}", *control_codes(row), row[6]]) + " |")
    return "".join(l + "\n" for l in out)


def write_sums():
    SUMS.write_text("".join(l + "\n" for l in expected_sums()), encoding="utf-8")
    print(f"wrote {SUMS} ({len(expected_sums())} files)")
    want = expected_session_sums()
    SESSION_SUMS.write_text("".join(l + "\n" for l in want), encoding="utf-8")
    print(f"wrote {SESSION_SUMS} ({len(want)} files)")


def check():
    # (a) row shape
    what = "(a) rows: every line is a well-formed projected row"
    files = sorted(ROWS.glob("*.jsonl"))
    if not files:
        fail(what, "no rows/*.jsonl files")
    rows = {}
    for f in files:
        rows[f.stem] = []
        for n, r in read_jsonl(f, what):
            where = f"{f}:{n}"
            extra = sorted(set(r) - set(KEYS))
            if extra:
                fail(what, f"{where} has keys outside the seven: {', '.join(extra)}")
            if not isinstance(r.get("thread_id"), str) or not THREAD_RE.match(r["thread_id"]):
                fail(what, f"{where} thread_id {r.get('thread_id')!r} does not match ^run-\\d+$")
            if not isinstance(r.get("timestamp"), str) or not TS_RE.match(r["timestamp"]):
                fail(what, f"{where} timestamp {r.get('timestamp')!r} is not ISO-8601")
            if r.get("outcome") not in OUTCOMES:
                fail(what, f"{where} outcome {r.get('outcome')!r} not in {sorted(OUTCOMES)}")
            if "delivery" in r and r["delivery"] not in DELIVERIES:
                fail(what, f"{where} delivery {r['delivery']!r} not in {sorted(DELIVERIES)}")
            rows[f.stem].append((n, r))
    total = sum(len(v) for v in rows.values())
    ok(f"{what} ({total} rows in {len(files)} files: "
       + ", ".join(f"{k} {len(v)}" for k, v in rows.items()) + ")")

    # (b) delivered rows carry a PR reference
    what = "(b) rows: every delivered row has a pull-request pr_url"
    delivered = 0
    for inst, lines in rows.items():
        for n, r in lines:
            if r.get("delivery") != "delivered":
                continue
            delivered += 1
            pr = r.get("pr_url")
            if not isinstance(pr, str) or not PR_RE.match(pr):
                fail(what, f"rows/{inst}.jsonl:{n} {r['thread_id']} is delivered but pr_url is {json.dumps(pr)}")
    ok(f"{what} ({delivered} delivered)")

    # (c) resumed runs: a thread_id on more than one line is one run, not a duplicate
    seen = {}
    for inst, lines in rows.items():
        for _, r in lines:
            seen[r["thread_id"]] = seen.get(r["thread_id"], 0) + 1
    resumed = sorted(t for t, c in seen.items() if c > 1)
    ok(f"(c) rows: resumed runs counted, not failed ({len(resumed)}"
       + (f": {', '.join(resumed)}" if resumed else "") + ")")

    # (d) packets agree with themselves and with the rows
    dirs = packet_dirs()
    for d in dirs:
        pid = d.name
        what = f"(d) packet {pid}"
        if not THREAD_RE.match(pid):
            fail(what, "directory name does not match ^run-\\d+$")
        prov_path = d / "provenance.yaml"
        if not prov_path.is_file():
            fail(what, "provenance.yaml missing")
        top, runs = read_provenance(prov_path)
        if top.get("thread_id") != pid:
            fail(what, f"provenance.yaml thread_id {top.get('thread_id')!r} != {pid!r}")
        lr_path = d / "ledger_rows.jsonl"
        if not lr_path.is_file():
            fail(what, "ledger_rows.jsonl missing")
        prow = read_jsonl(lr_path, what)
        if not prow:
            fail(what, "ledger_rows.jsonl is empty")
        notes = []
        for n, r in prow:
            if r.get("thread_id") != pid:
                fail(what, f"ledger_rows.jsonl:{n} thread_id {r.get('thread_id')!r} != {pid!r}")
            inst = r.get("instance")
            if inst is None:
                inst = "kestrel"
                notes.append(f"ledger_rows.jsonl:{n} has no instance, searched rows/kestrel.jsonl")
            target = rows.get(inst)
            if target is None:
                fail(what, f"ledger_rows.jsonl:{n} instance {inst!r} has no rows/{inst}.jsonl")
            p = project(r)
            if not any(lr == p for _, lr in target):
                fail(what, f"ledger_rows.jsonl:{n} projection matches no line in rows/{inst}.jsonl: "
                           + json.dumps(p, sort_keys=True))
        ok(f"{what}: provenance and {len(prow)} ledger row(s) match rows/"
           + ("; " + "; ".join(notes) if notes else ""))

        row_prs = {r["pr_url"] for _, r in prow if r.get("pr_url")}
        refs_path = d / "pr_refs.txt"
        if refs_path.is_file():
            refs = [l for l in refs_path.read_text(encoding="utf-8").splitlines() if l.strip()]
            for ref in refs:
                if ref not in row_prs:
                    fail(what, f"pr_refs.txt line {ref!r} is not the pr_url of any packet row")
            for pr in sorted(row_prs - set(refs)):
                fail(what, f"packet row pr_url {pr!r} missing from pr_refs.txt")
        if not runs:
            fail(what, "provenance.yaml has no runs: items")
        prov_prs = {r.get("pr_url") for r in runs}
        packet_prs = {r.get("pr_url") for _, r in prow}
        if prov_prs != packet_prs:
            fail(what, f"provenance.yaml runs[].pr_url {sorted(map(str, prov_prs))} "
                       f"!= packet rows' pr_url {sorted(map(str, packet_prs))}")
        ok(f"{what}: pr_refs.txt and provenance runs[].pr_url agree with the packet rows "
           f"({', '.join(sorted(row_prs)) or 'none'})")

    # (e) packet bytes are pinned
    what = "(e) packets: SHA256SUMS covers every packet file and every sum matches"
    if not SUMS.is_file():
        fail(what, f"{SUMS} missing (run ./verify.sh --write-sums)")
    have = SUMS.read_text(encoding="utf-8").splitlines()
    want = expected_sums()
    want_by_path = {l.split("  ", 1)[1]: l for l in want}
    for n, line in enumerate(have, 1):
        m = re.match(r"^([0-9a-f]{64})  (\S.*)$", line)
        if not m:
            fail(what, f"SHA256SUMS:{n} is not a `sha256  path` line: {line!r}")
        if m.group(2) not in want_by_path:
            fail(what, f"SHA256SUMS:{n} lists {m.group(2)!r}, not a file under any packet directory")
        if want_by_path[m.group(2)] != line:
            fail(what, f"SHA256SUMS:{n} sum mismatch for {m.group(2)}")
    paths = [l.split("  ", 1)[1] for l in have]
    for p in sorted(set(want_by_path) - set(paths)):
        fail(what, f"{p} is not listed")
    if len(paths) != len(set(paths)):
        fail(what, "a path is listed more than once")
    if paths != sorted(paths):
        fail(what, "lines are not in sorted path order")
    ok(f"{what} ({len(have)} files)")

    # (f) mapped vendor sessions agree with their trusted-host audit
    sessions = session_dirs()
    for d in sessions:
        sid = d.name
        what = f"(f) session {sid}"
        audit_path = d / "source" / "audit.json"
        if not audit_path.is_file():
            fail(what, "source/audit.json missing")
        try:
            audit = json.loads(audit_path.read_text(encoding="utf-8"))
        except json.JSONDecodeError as e:
            fail(what, f"source/audit.json does not parse as JSON ({e.msg})")
        verdict = audit.get("verdict") if isinstance(audit, dict) else None
        if not isinstance(verdict, str) or not verdict:
            fail(what, "source/audit.json has no verdict")
        want_decision = "allow" if verdict == "PASS" else "deny"
        corr = sorted(p for p in (d / "packet").glob("corr-*") if p.is_dir())
        if len(corr) != 1:
            fail(what, f"expected exactly one packet/corr-*/ directory, found {len(corr)}")
        cdir = corr[0]
        counts = {}
        for name in ("decision_traces.jsonl", "evidence.jsonl"):
            path = cdir / name
            if not path.is_file():
                fail(what, f"{path} missing")
            recs = read_jsonl(path, what)
            for n, r in recs:
                if r.get("correlation_id") != cdir.name:
                    fail(what, f"{path}:{n} correlation_id {r.get('correlation_id')!r} != {cdir.name!r}")
                if name == "decision_traces.jsonl":
                    got = (r.get("policy") or {}).get("decision")
                    if got != want_decision:
                        fail(what, f"{path}:{n} policy.decision {got!r} != {want_decision!r} "
                                   f"(audit verdict {verdict})")
            counts[name] = len(recs)
        result = d / "RESULT.md"
        if not result.is_file():
            fail(what, "RESULT.md missing")
        if not VERIFIER_EXIT_RE.search(result.read_text(encoding="utf-8")):
            fail(what, "RESULT.md has no line matching ^packet-verifier exit: \\d+$")
        ok(f"{what}: {cdir.name} has {counts['decision_traces.jsonl']} trace(s) and "
           f"{counts['evidence.jsonl']} evidence record(s); every trace's decision is "
           f"{want_decision!r} for audit verdict {verdict}; RESULT.md records the packet verifier's exit")

    # (g) session sources are pinned
    what = "(g) sessions: SHA256SUMS covers every source/ file and every sum matches"
    n = check_sums(what, SESSION_SUMS, expected_session_sums(), "sessions/SHA256SUMS", "session source/ directory")
    ok(f"{what} ({n} files)")

    # (h) CONTROLS.md is the verifier's control table, byte for byte
    what = "(h) controls"
    if not CONTROLS_MD.is_file():
        fail(what, f"{CONTROLS_MD} missing (run ./verify.sh --controls --markdown > CONTROLS.md)")
    have_bytes, want = CONTROLS_MD.read_bytes(), controls_markdown()
    if have_bytes != want.encode("utf-8"):
        have = have_bytes.decode("utf-8", errors="replace").splitlines(keepends=True)
        want_lines = want.splitlines(keepends=True)
        n = next((i for i, (h, w) in enumerate(zip(have, want_lines)) if h != w),
                 min(len(have), len(want_lines)))
        line = repr(have[n].rstrip("\n")) if n < len(have) else "(end of file)"
        fail(what, f"{CONTROLS_MD} differs from verify.sh's table: line {n + 1}: {line}")
    ok(f"{what}: {CONTROLS_MD} matches the verifier's control table ({len(CONTROLS)} checks)")

    # (i) instances.jsonl names every tenant that has a rows file, and no other
    what = "(i) instances"
    inst_path = Path("instances.jsonl")
    if not inst_path.is_file():
        fail(what, "instances.jsonl missing")
    names = []
    for n, r in read_jsonl(inst_path, what):
        where = f"instances.jsonl:{n}"
        if sorted(r) != sorted(INSTANCE_KEYS):
            fail(what, f"{where} keys {sorted(r)} != {sorted(INSTANCE_KEYS)}")
        for k in INSTANCE_KEYS:
            if not isinstance(r[k], str) or not r[k]:
                fail(what, f"{where} {k} is not a non-empty string")
        if not REPO_RE.match(r["repo"]):
            fail(what, f"{where} repo {r['repo']!r} does not match ^https://github\\.com/[^/]+/[^/]+$")
        names.append(r["instance"])
    if len(names) != len(set(names)):
        fail(what, "an instance is listed more than once")
    if names != sorted(names):
        fail(what, "lines are not sorted by instance")
    if sorted(names) != sorted(rows):
        fail(what, f"listed instances {sorted(names)} != rows files {sorted(rows)}")
    ok(f"{what}: every rows file names a listed tenant and every listed tenant has a rows file ({len(names)})")

    # (j) README.md quotes this run's output, byte for byte
    what = "(j) readme"
    pass_line = (f"PASS: record is internally consistent — rows: {total}, delivered: {delivered}, "
                 f"packets: {len(dirs)}, resumed runs: {len(resumed)}, sessions: {len(sessions)}")
    j_ok = f"ok   {what}: the quoted verifier output in README.md matches this run"
    expected = PRINTED + [j_ok, pass_line]
    readme = Path("README.md")
    if not readme.is_file():
        fail(what, "README.md missing")
    blocks = re.findall(r"<!-- verify:begin -->\n```text\n(.*?)\n```\n<!-- verify:end -->",
                        readme.read_text(encoding="utf-8"), re.S)
    if len(blocks) != 1:
        fail(what, f"README.md has {len(blocks)} verify block(s), expected exactly one")
    got = blocks[0].split("\n")
    for n, (g, e) in enumerate(zip(got, expected), 1):
        if g != e:
            fail(what, f"README.md's verify block differs from this run's output: line {n}: {g}")
    if len(got) != len(expected):
        n = min(len(got), len(expected)) + 1
        line = got[n - 1] if n <= len(got) else "(end of block)"
        fail(what, f"README.md's verify block differs from this run's output: line {n}: {line}")
    print(j_ok)
    print(pass_line)


args = sys.argv[1:]
if args == ["--write-sums"]:
    write_sums()
elif args == ["--controls"]:
    sys.stdout.write(controls_text())
elif args == ["--controls", "--markdown"]:
    sys.stdout.write(controls_markdown())
elif not args:
    check()
else:
    print("usage: ./verify.sh [--write-sums | --controls [--markdown]]", file=sys.stderr)
    sys.exit(2)
PY
