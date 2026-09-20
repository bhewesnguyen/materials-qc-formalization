#!/usr/bin/env python3
"""Exercise the trust gate against actual Lean negative fixtures.

Fixtures are written outside release modules and never edit the real proofs.
Run after the pinned dependencies are available. JSON retains command evidence.
"""

from __future__ import annotations

import argparse
import json
from pathlib import Path
import sys
from typing import Any

from verify import (GateFailure, Recorder, audit_lean_file, parse_axiom_output,
                    require, resolve_lake, utc_now)


def lean_message(text: str) -> str:
    return json.dumps({"severity": "information", "data": text}) + "\n"


def run_tests(root: Path, output_dir: Path, recorder: Recorder) -> list[dict[str, Any]]:
    fixtures = output_dir / "fixtures"
    fixtures.mkdir(parents=True, exist_ok=True)
    results: list[dict[str, Any]] = []

    def probe(label: str, body: str, names: list[str], forbidden: str | None = None) -> None:
        path = fixtures / (label.replace("-", "_") + ".lean")
        path.write_text(body + "\n" + "\n".join("#print axioms " + n for n in names) + "\n",
                        encoding="utf-8")
        try:
            axioms = audit_lean_file(recorder, path, names, label=label)
        except GateFailure as error:
            require(forbidden is not None, f"Positive fixture {label} was rejected: {error}")
            require(forbidden in str(error), f"Fixture {label} failed for the wrong reason: {error}")
            results.append({"case": label, "status": "passed", "expected": "reject",
                            "observed_reason": str(error)})
        else:
            require(forbidden is None, f"Unsafe fixture {label} was unexpectedly accepted")
            results.append({"case": label, "status": "passed", "expected": "accept", "axioms": axioms})

    probe("allowed-control", "theorem GateFixture.allowed : True := True.intro",
          ["GateFixture.allowed"])
    probe("allowed-propext", "theorem GateFixture.ext (p q : Prop) (h : p ↔ q) : p = q := propext h",
          ["GateFixture.ext"])
    probe("direct-axiom", "axiom GateFixture.bad : False\n"
          "theorem GateFixture.direct : False := GateFixture.bad",
          ["GateFixture.direct"], "GateFixture.bad")
    probe("transitive-axiom", "axiom GateFixture.hidden : False\n"
          "theorem GateFixture.helper : False := GateFixture.hidden\n"
          "theorem GateFixture.indirect : False := GateFixture.helper",
          ["GateFixture.indirect"], "GateFixture.hidden")
    probe("sorry-proof", "theorem GateFixture.unfinished : False := by sorry",
          ["GateFixture.unfinished"], "sorryAx")
    probe("missing-export", "theorem GateFixture.present : True := True.intro",
          ["GateFixture.absent"], "failed with exit code")
    probe("false-premise-axiom-control", "theorem GateFixture.vacuous (h : False) : True := False.elim h",
          ["GateFixture.vacuous"])

    baseline = fixtures / "contract_baseline.lean"
    baseline.write_text("theorem GateFixture.target : True := True.intro\n"
                        "example : True := GateFixture.target\n", encoding="utf-8")
    recorder.lean("signature-control", baseline)
    results.append({"case": "signature-control", "status": "passed", "expected": "accept"})
    weakened = fixtures / "contract_false_premise.lean"
    weakened.write_text("theorem GateFixture.target (h : False) : True := False.elim h\n"
                        "example : True := GateFixture.target\n", encoding="utf-8")
    record = recorder.lean("signature-false-premise", weakened, json_output=True, check=False)
    require(record["exit_code"] != 0, "Independent signature accepted an added False premise")
    require("type mismatch" in record["stdout"].lower(),
            "False-premise fixture failed without the expected type mismatch")
    results.append({"case": "signature-false-premise", "status": "passed", "expected": "reject",
                    "exit_code": record["exit_code"]})

    good = lean_message("'GateFixture.allowed' does not depend on any axioms")
    malformed = [
        ("missing-report", "", ["GateFixture.allowed"], "Missing axiom reports"),
        ("duplicate-report", good + good, ["GateFixture.allowed"], "Duplicate axiom report"),
        ("extra-report", good, ["GateFixture.other"], "Unexpected axiom report"),
        ("malformed-report", lean_message("unrecognized axiom report"),
         ["GateFixture.allowed"], "Unrecognized information"),
        ("malformed-axiom-list", lean_message("'GateFixture.allowed' depends on axioms: [propext,, Classical.choice]"),
         ["GateFixture.allowed"], "Empty or malformed axiom list"),
        ("whitelist-substring", lean_message("'GateFixture.allowed' depends on axioms: [Classical.choiceBogus]"),
         ["GateFixture.allowed"], "Forbidden transitive axioms"),
    ]
    for label, output, names, expected_reason in malformed:
        try:
            parse_axiom_output(output, names)
        except GateFailure as error:
            require(expected_reason in str(error), f"Parser fixture {label} failed for the wrong reason: {error}")
            results.append({"case": label, "status": "passed", "expected": "reject",
                            "observed_reason": str(error)})
        else:
            raise GateFailure(f"Parser accepted {label}")
    return results


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--root", type=Path, default=Path(__file__).resolve().parents[1])
    parser.add_argument("--lake", default="lake")
    parser.add_argument("--output-dir", type=Path, default=Path("evidence/selftest-latest"))
    args = parser.parse_args(argv)
    root = args.root.resolve()
    output_dir = args.output_dir if args.output_dir.is_absolute() else root / args.output_dir
    output_dir.mkdir(parents=True, exist_ok=True)
    summary: dict[str, Any] = {"schema_version": 1, "started_at": utc_now(), "status": "failed"}
    recorder = None
    try:
        recorder = Recorder(root, output_dir, resolve_lake(args.lake))
        summary["tests"] = run_tests(root, output_dir, recorder)
        summary["status"] = "passed"
        code = 0
    except (GateFailure, OSError, ValueError, KeyError, TypeError) as error:
        summary["error"] = str(error)
        code = 1
    summary["finished_at"] = utc_now()
    summary["commands"] = recorder.commands if recorder else []
    (output_dir / "gate_tests.json").write_text(json.dumps(summary, indent=2) + "\n", encoding="utf-8")
    print(f"Stage 0 gate tests: {summary['status']}")
    if "error" in summary:
        print(summary["error"], file=sys.stderr)
    print(output_dir / "gate_tests.json")
    return code


if __name__ == "__main__":
    raise SystemExit(main())
