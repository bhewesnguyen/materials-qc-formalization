#!/usr/bin/env python3
"""Reproduce the Stage 0 release and enforce its declaration trust policy.

This is an ordinary reproducibility gate, not a malicious-code verifier. Run
after dependencies and their pinned build artifacts have been obtained.
"""

from __future__ import annotations

import argparse
import datetime as dt
import hashlib
import json
import os
from pathlib import Path
import re
import shutil
import subprocess
import sys
import time
from typing import Any


ALLOWED_AXIOMS = frozenset({"propext", "Classical.choice", "Quot.sound"})
NAME_RE = re.compile(r"[A-Za-z_][A-Za-z0-9_']*(?:\.[A-Za-z_][A-Za-z0-9_']*)*")
AXIOMS_RE = re.compile(r"'([^']+)' depends on axioms:\s*\[([^\]]*)\]\s*", re.S)
NO_AXIOMS_RE = re.compile(r"'([^']+)' does not depend on any axioms\s*", re.S)


class GateFailure(RuntimeError):
    """An expected, evidence-bearing validation failure."""


def require(condition: bool, message: str) -> None:
    if not condition:
        raise GateFailure(message)


def utc_now() -> str:
    return dt.datetime.now(dt.timezone.utc).isoformat()


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def resolve_lake(value: str) -> str:
    result = shutil.which(value)
    if result is None and Path(value).is_file():
        result = os.path.abspath(value)
    require(result is not None, f"Lake executable was not found: {value}")
    # Preserve the final executable name: elan can dispatch via a `lake`
    # symlink, and following it to `elan` would change the invoked command.
    return os.path.abspath(result)


class Recorder:
    """Record each real process, including commands that return nonzero."""

    def __init__(self, root: Path, output_dir: Path, lake: str):
        self.root = root.resolve()
        self.output_dir = output_dir.resolve()
        self.output_dir.mkdir(parents=True, exist_ok=True)
        self.lake = lake
        self.commands: list[dict[str, Any]] = []
        self.env = dict(os.environ)
        self.env["PATH"] = str(Path(lake).parent) + os.pathsep + self.env.get("PATH", "")

    def run(self, label: str, argv: list[str], *, check: bool = True) -> dict[str, Any]:
        started = utc_now()
        tick = time.monotonic()
        try:
            result = subprocess.run(
                argv, cwd=self.root, env=self.env, text=True,
                stdout=subprocess.PIPE, stderr=subprocess.PIPE, check=False,
            )
            code, stdout, stderr = result.returncode, result.stdout, result.stderr
        except OSError as error:
            code, stdout, stderr = 127, "", str(error)
        stem = f"{len(self.commands) + 1:02d}-{label}"
        stdout_name, stderr_name = stem + ".stdout.log", stem + ".stderr.log"
        (self.output_dir / stdout_name).write_text(stdout, encoding="utf-8")
        (self.output_dir / stderr_name).write_text(stderr, encoding="utf-8")
        record = {
            "label": label, "argv": argv, "cwd": str(self.root),
            "started_at": started, "duration_seconds": round(time.monotonic() - tick, 3),
            "exit_code": code, "stdout_file": stdout_name, "stderr_file": stderr_name,
            "stdout": stdout, "stderr": stderr,
        }
        self.commands.append(record)
        self.save_commands()
        if check:
            require(code == 0, f"Command {label!r} failed with exit code {code}; see {stem} logs")
        return record

    def lean(self, label: str, path: Path, *, json_output: bool = False,
             check: bool = True) -> dict[str, Any]:
        argv = [self.lake, "env", "lean"]
        if json_output:
            argv.append("--json")
        argv.append(str(path.resolve()))
        return self.run(label, argv, check=check)

    def save_commands(self) -> None:
        (self.output_dir / "commands.json").write_text(
            json.dumps(self.commands, indent=2) + "\n", encoding="utf-8")


def strip_lean_comments(text: str) -> str:
    """Strip nested block and line comments while preserving string literals.

    This supports ordinary source inspection; it is not a Lean parser or a
    defense against deliberately adversarial source syntax.
    """
    result: list[str] = []
    depth = 0
    in_string = False
    escaped = False
    index = 0
    while index < len(text):
        pair = text[index:index + 2]
        char = text[index]
        if depth:
            if pair == "/-":
                depth += 1
                result.extend("  ")
                index += 2
                continue
            if pair == "-/":
                depth -= 1
                result.extend("  ")
                index += 2
                continue
            result.append("\n" if char == "\n" else " ")
        elif in_string:
            result.append(char)
            if escaped:
                escaped = False
            elif char == "\\":
                escaped = True
            elif char == '"':
                in_string = False
        elif pair == "/-":
            depth = 1
            result.extend("  ")
            index += 2
            continue
        elif pair == "--":
            end = text.find("\n", index)
            if end == -1:
                result.extend(" " * (len(text) - index))
                break
            result.extend(" " * (end - index))
            index = end
            continue
        else:
            result.append(char)
            if char == '"':
                in_string = True
        index += 1
    require(depth == 0, "Unclosed Lean block comment while inspecting source")
    return "".join(result)


def imported_modules(path: Path) -> set[str]:
    result: set[str] = set()
    clean = strip_lean_comments(path.read_text(encoding="utf-8"))
    for line in clean.splitlines():
        match = re.fullmatch(r"\s*(?:public\s+|meta\s+)?import\s+(.+?)\s*", line)
        if match:
            for item in match.group(1).split():
                if item in {"all", "meta"}:
                    continue
                require(NAME_RE.fullmatch(item) is not None,
                        f"Unsupported import syntax in {path.name}: {line.strip()}")
                result.add(item)
    return result


def module_path(root: Path, name: str) -> Path:
    return root.joinpath(*name.split(".")).with_suffix(".lean")


def validate_manifest(data: Any) -> dict[str, Any]:
    require(isinstance(data, dict), "Export manifest must be a JSON object")
    require(data.get("schema_version") == 1, "Expected export manifest schema_version 1")
    require(isinstance(data.get("lean_version"), str) and
            re.fullmatch(r"\d+\.\d+\.\d+(?:-[A-Za-z0-9.]+)?", data["lean_version"]) is not None,
            "Manifest lean_version is invalid")
    require(isinstance(data.get("mathlib_commit"), str) and
            re.fullmatch(r"[0-9a-f]{40}", data["mathlib_commit"]) is not None,
            "Manifest mathlib_commit must be a complete lowercase SHA-1")
    for field in ("release_modules", "exports"):
        names = data.get(field)
        require(isinstance(names, list) and bool(names), f"Manifest {field} must be nonempty")
        require(all(isinstance(n, str) and NAME_RE.fullmatch(n) for n in names),
                f"Manifest {field} contains an unsupported Lean name")
        require(len(set(names)) == len(names), f"Manifest {field} contains duplicates")
    contract_exports = data.get("contract_exports", data["exports"])
    require(isinstance(contract_exports, list) and bool(contract_exports) and
            all(isinstance(n, str) and NAME_RE.fullmatch(n) for n in contract_exports),
            "Manifest contract_exports must be a nonempty list of Lean names")
    require(len(set(contract_exports)) == len(contract_exports),
            "Manifest contract_exports contains duplicates")
    require(set(contract_exports) <= set(data["exports"]),
            "Manifest contract_exports must be a subset of exports")
    require(all(n.startswith("FormalScience.") for n in data["release_modules"]),
            "Release modules must be below FormalScience")
    contract = data.get("contract_file")
    require(isinstance(contract, str) and bool(contract), "Manifest contract_file is missing")
    require(not Path(contract).is_absolute() and ".." not in Path(contract).parts,
            "Manifest contract_file must be a project-relative path")
    return data


def parse_axiom_output(stdout: str, expected: list[str]) -> dict[str, list[str]]:
    """Parse Lean --json diagnostics and enforce complete, unique axiom reports."""
    require(len(set(expected)) == len(expected), "Expected exports contain duplicates")
    wanted = set(expected)
    found: dict[str, list[str]] = {}
    for line in stdout.splitlines():
        if not line.strip():
            continue
        try:
            message = json.loads(line)
        except json.JSONDecodeError as error:
            raise GateFailure(f"Non-JSON axiom output: {line[:160]}") from error
        require(isinstance(message, dict) and isinstance(message.get("data"), str),
                "Malformed Lean JSON diagnostic")
        severity = message.get("severity")
        require(severity in {"information", "warning"},
                f"Unexpected Lean diagnostic severity in axiom query: {severity}")
        if severity == "warning":
            # Warnings remain in raw evidence. They cannot conceal a missing report.
            continue
        content = message["data"]
        match = AXIOMS_RE.fullmatch(content)
        empty = NO_AXIOMS_RE.fullmatch(content)
        require(match is not None or empty is not None,
                f"Unrecognized information in axiom query: {content[:160]}")
        name = (match or empty).group(1)  # type: ignore[union-attr]
        require(name in wanted, f"Unexpected axiom report for {name}")
        require(name not in found, f"Duplicate axiom report for {name}")
        axioms = [] if empty else [part.strip() for part in match.group(2).split(",")]
        require(empty is not None or all(axioms), f"Empty or malformed axiom list for {name}")
        require(all(NAME_RE.fullmatch(a) for a in axioms), f"Malformed axiom list for {name}")
        require(len(set(axioms)) == len(axioms), f"Duplicate axiom names for {name}")
        found[name] = sorted(axioms)
    missing = wanted - set(found)
    require(not missing, f"Missing axiom reports: {sorted(missing)}")
    forbidden = {name: sorted(set(axioms) - ALLOWED_AXIOMS)
                 for name, axioms in found.items() if set(axioms) - ALLOWED_AXIOMS}
    require(not forbidden, "Forbidden transitive axioms: " + json.dumps(forbidden, sort_keys=True))
    return {name: found[name] for name in expected}


def audit_lean_file(recorder: Recorder, path: Path, expected: list[str], *,
                    label: str = "axiom-audit") -> dict[str, list[str]]:
    record = recorder.lean(label, path, json_output=True)
    require(not record["stderr"].strip(), "Unexpected stderr from axiom query; see recorded output")
    return parse_axiom_output(record["stdout"], expected)


def verify(root: Path, manifest_path: Path, recorder: Recorder) -> dict[str, Any]:
    try:
        manifest = validate_manifest(json.loads(manifest_path.read_text(encoding="utf-8")))
    except (OSError, json.JSONDecodeError) as error:
        raise GateFailure(f"Cannot read export manifest: {error}") from error

    expected_toolchain = "leanprover/lean4:v" + manifest["lean_version"]
    toolchain_path = root / "lean-toolchain"
    require(toolchain_path.read_text(encoding="utf-8").strip() == expected_toolchain,
            "lean-toolchain disagrees with the export manifest")
    version = recorder.run("lean-version", [recorder.lake, "env", "lean", "--version"])
    match = re.search(r"\bLean \(version ([^,\s)]+)", version["stdout"])
    require(match is not None and match.group(1) == manifest["lean_version"],
            "Actual Lean version disagrees with the export manifest")
    recorder.run("lake-version", [recorder.lake, "--version"])

    lock_path = root / "lake-manifest.json"
    require(lock_path.is_file(), "lake-manifest.json is missing; acquire the pinned dependencies first")
    lock = json.loads(lock_path.read_text(encoding="utf-8"))
    mathlib_entries = [entry for entry in lock.get("packages", []) if entry.get("name") == "mathlib"]
    require(len(mathlib_entries) == 1, "Lake manifest must contain exactly one mathlib package")
    require(mathlib_entries[0].get("rev") == manifest["mathlib_commit"],
            "Locked Mathlib revision disagrees with the export manifest")
    packages_dir = root / lock.get("packagesDir", ".lake/packages")
    mathlib_dir = packages_dir / "mathlib"
    head = recorder.run("mathlib-head", ["git", "-C", str(mathlib_dir), "rev-parse", "HEAD"])
    require(head["stdout"].strip() == manifest["mathlib_commit"],
            "Checked-out Mathlib HEAD disagrees with the export manifest")
    dirty = recorder.run("mathlib-tracked-status", ["git", "-C", str(mathlib_dir),
                          "status", "--porcelain", "--untracked-files=no"])
    require(not dirty["stdout"].strip(), "Mathlib has tracked modifications; the pin alone is insufficient")
    dependencies = [{
        "name": "mathlib", "type": "git", "url": mathlib_entries[0].get("url"),
        "locked_revision": mathlib_entries[0]["rev"],
        "checked_out_head": head["stdout"].strip(), "tracked_clean": True,
    }]
    for index, entry in enumerate(lock.get("packages", []), start=1):
        if entry.get("type") != "git" or entry.get("name") == "mathlib":
            continue
        name, revision = entry.get("name"), entry.get("rev")
        require(isinstance(name, str) and bool(name) and
                len(Path(name).parts) == 1 and name not in {".", ".."},
                "Lake manifest contains an invalid git package name")
        require(isinstance(revision, str) and re.fullmatch(r"[0-9a-f]{40}", revision) is not None,
                f"Dependency {name} does not have a complete locked revision")
        package_dir = packages_dir / name
        package_head = recorder.run(f"dependency-{index:02d}-head",
                                    ["git", "-C", str(package_dir), "rev-parse", "HEAD"])
        require(package_head["stdout"].strip() == revision,
                f"Checked-out {name} HEAD disagrees with lake-manifest.json")
        package_status = recorder.run(f"dependency-{index:02d}-tracked-status",
                                      ["git", "-C", str(package_dir), "status", "--porcelain",
                                       "--untracked-files=no"])
        require(not package_status["stdout"].strip(),
                f"Dependency {name} has tracked modifications; the pin alone is insufficient")
        dependencies.append({
            "name": name, "type": "git", "url": entry.get("url"),
            "locked_revision": revision, "checked_out_head": package_head["stdout"].strip(),
            "tracked_clean": True,
        })

    sources = {".".join(p.relative_to(root).with_suffix("").parts)
               for p in (root / "FormalScience").rglob("*.lean")}
    declared = set(manifest["release_modules"])
    require(sources == declared,
            f"Release module coverage mismatch: unlisted={sorted(sources-declared)}, "
            f"missing={sorted(declared-sources)}")
    umbrella = root / "FormalScience.lean"
    require(umbrella.is_file(), "FormalScience.lean umbrella is missing")
    reached: set[str] = set()
    pending = list(imported_modules(umbrella) & declared)
    while pending:
        name = pending.pop()
        if name not in reached:
            reached.add(name)
            pending.extend(imported_modules(module_path(root, name)) & declared)
    require(reached == declared, f"Umbrella omits release modules: {sorted(declared-reached)}")

    contract_path = root / manifest["contract_file"]
    require(contract_path.is_file(), "Independent contract module is missing")
    contract_text = strip_lean_comments(contract_path.read_text(encoding="utf-8"))
    absent = [name for name in manifest.get("contract_exports", manifest["exports"])
              if re.search(r"(?<![A-Za-z0-9_'.])" + re.escape(name) +
                           r"(?![A-Za-z0-9_'.])", contract_text) is None]
    require(not absent, f"Contract file does not mention these fully qualified exports: {absent}")

    recorder.run("build-release", [recorder.lake, "build", *manifest["release_modules"], "FormalScience"])
    # Explicit elaboration rechecks delivered release sources even if Lake's
    # incremental build regarded their existing artifacts as current.
    for index, name in enumerate(manifest["release_modules"], start=1):
        recorder.lean(f"release-source-{index:02d}", module_path(root, name))
    recorder.lean("independent-contracts", contract_path)

    signatures = recorder.output_dir / "Signatures.lean"
    signatures.write_text("import FormalScience\n\nset_option pp.universes true\n"
                          "set_option pp.explicit true\n\n" +
                          "\n".join("#check @" + name for name in manifest["exports"]) + "\n",
                          encoding="utf-8")
    recorder.lean("export-signatures", signatures, json_output=True)

    query = recorder.output_dir / "AxiomQueries.lean"
    query.write_text("import FormalScience\n\n" +
                     "\n".join("#print axioms " + name for name in manifest["exports"]) + "\n",
                     encoding="utf-8")
    axiom_report = audit_lean_file(recorder, query, manifest["exports"])
    paths = [toolchain_path, root / "lakefile.toml", lock_path, manifest_path, umbrella,
             contract_path, root / "scripts/verify.py", root / "scripts/test_verify.py"]
    paths.extend(module_path(root, name) for name in manifest["release_modules"])
    hashes = {str(path.relative_to(root)) if path.is_relative_to(root) else str(path): sha256(path)
              for path in paths if path.is_file()}
    return {
        "manifest": manifest, "dependencies": dependencies,
        "allowed_axioms": sorted(ALLOWED_AXIOMS),
        "axioms": axiom_report, "source_sha256": hashes,
        "release_module_coverage": sorted(reached),
        "limitations": [
            "Ordinary reproducibility gate, not a verifier hardened against malicious source or binaries.",
            "Expected signatures and mathematical definitions still require human semantic review.",
            "The export manifest is a human-reviewed declaration list; source-module coverage is enforced.",
            "Passing does not establish complete positivity, Lindblad dynamics, or novelty.",
        ],
    }


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--root", type=Path, default=Path(__file__).resolve().parents[1])
    parser.add_argument("--manifest", type=Path, default=Path("exports.json"))
    parser.add_argument("--lake", default="lake", help="Lake on PATH or its absolute executable path")
    parser.add_argument("--output-dir", type=Path, default=Path("evidence/latest"))
    args = parser.parse_args(argv)
    root = args.root.resolve()
    output_dir = args.output_dir if args.output_dir.is_absolute() else root / args.output_dir
    manifest_path = args.manifest if args.manifest.is_absolute() else root / args.manifest
    output_dir.mkdir(parents=True, exist_ok=True)
    summary: dict[str, Any] = {"schema_version": 1, "started_at": utc_now(), "status": "failed"}
    recorder = None
    try:
        recorder = Recorder(root, output_dir, resolve_lake(args.lake))
        summary.update(verify(root, manifest_path.resolve(), recorder))
        summary["status"] = "passed"
        code = 0
    except (GateFailure, OSError, ValueError, KeyError, TypeError) as error:
        summary["error"] = str(error)
        code = 1
    summary["finished_at"] = utc_now()
    summary["commands"] = recorder.commands if recorder else []
    (output_dir / "verification.json").write_text(json.dumps(summary, indent=2) + "\n", encoding="utf-8")
    print(f"Stage 0 verification: {summary['status']}")
    if "error" in summary:
        print(summary["error"], file=sys.stderr)
    print(output_dir / "verification.json")
    return code


if __name__ == "__main__":
    raise SystemExit(main())
