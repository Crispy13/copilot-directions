#!/usr/bin/env python3
"""Placeholder trigger-eval harness for the Copilot adaptation.

The source skill shipped an external description-trigger evaluation harness.
GitHub Copilot does not expose a public equivalent for that workflow, so this
adapted file fails fast instead of pretending the old automation still works.
"""

import argparse
import sys
from pathlib import Path


UNSUPPORTED_MESSAGE = (
    "scripts/run_eval.py is a placeholder in this Copilot adaptation. "
    "This workflow needs a host-specific external trigger-eval harness that "
    "is not bundled here. Use the manual description-review loop in SKILL.md "
    "or replace this file with an environment-specific evaluator."
)


def run_eval(*_args, **_kwargs):
    raise NotImplementedError(UNSUPPORTED_MESSAGE)


def main():
    parser = argparse.ArgumentParser(description="Run trigger evaluation for a skill description")
    parser.add_argument("--eval-set", required=True, help="Path to eval set JSON file")
    parser.add_argument("--skill-path", required=True, help="Path to skill directory")
    parser.add_argument("--description", default=None, help="Override description to test")
    parser.add_argument("--num-workers", type=int, default=10, help="Number of parallel workers")
    parser.add_argument("--timeout", type=int, default=30, help="Timeout per query in seconds")
    parser.add_argument("--runs-per-query", type=int, default=3, help="Number of runs per query")
    parser.add_argument("--trigger-threshold", type=float, default=0.5, help="Trigger rate threshold")
    parser.add_argument("--model", default=None, help="Model identifier for an external harness")
    parser.add_argument("--verbose", action="store_true", help="Print progress to stderr")
    args = parser.parse_args()

    skill_path = Path(args.skill_path)
    if not (skill_path / "SKILL.md").exists():
        print(f"Error: No SKILL.md found at {skill_path}", file=sys.stderr)
        sys.exit(1)

    print(UNSUPPORTED_MESSAGE, file=sys.stderr)
    sys.exit(2)


if __name__ == "__main__":
    main()
