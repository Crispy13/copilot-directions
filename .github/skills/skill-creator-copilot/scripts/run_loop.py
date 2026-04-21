#!/usr/bin/env python3
"""Placeholder optimization loop for the Copilot adaptation.

The source skill bundled an automated description-optimization loop. GitHub
Copilot does not expose a bundled public external trigger-eval harness, so
this adapted file preserves the interface but exits with a clear message.
"""

import argparse
import sys
from pathlib import Path


UNSUPPORTED_MESSAGE = (
    "scripts/run_loop.py is a placeholder in this Copilot adaptation. "
    "It needs an environment-specific external harness for trigger evals and "
    "description rewriting, and no public Copilot implementation is bundled "
    "here. Use the manual loop in SKILL.md or replace this file with a "
    "host-specific implementation."
)


def run_loop(*_args, **_kwargs):
    raise NotImplementedError(UNSUPPORTED_MESSAGE)


def main():
    parser = argparse.ArgumentParser(description="Run eval + improve loop")
    parser.add_argument("--eval-set", required=True, help="Path to eval set JSON file")
    parser.add_argument("--skill-path", required=True, help="Path to skill directory")
    parser.add_argument("--description", default=None, help="Override starting description")
    parser.add_argument("--num-workers", type=int, default=10, help="Number of parallel workers")
    parser.add_argument("--timeout", type=int, default=30, help="Timeout per query in seconds")
    parser.add_argument("--max-iterations", type=int, default=5, help="Max improvement iterations")
    parser.add_argument("--runs-per-query", type=int, default=3, help="Number of runs per query")
    parser.add_argument("--trigger-threshold", type=float, default=0.5, help="Trigger rate threshold")
    parser.add_argument("--holdout", type=float, default=0.4, help="Fraction of eval set to hold out for testing (0 to disable)")
    parser.add_argument("--model", required=True, help="Model identifier for an external harness")
    parser.add_argument("--verbose", action="store_true", help="Print progress to stderr")
    parser.add_argument("--report", default="auto", help="Generate HTML report at this path (default: 'auto' for temp file, 'none' to disable)")
    parser.add_argument("--results-dir", default=None, help="Save outputs to a timestamped subdirectory here")
    args = parser.parse_args()

    skill_path = Path(args.skill_path)
    if not (skill_path / "SKILL.md").exists():
        print(f"Error: No SKILL.md found at {skill_path}", file=sys.stderr)
        sys.exit(1)

    print(UNSUPPORTED_MESSAGE, file=sys.stderr)
    sys.exit(2)


if __name__ == "__main__":
    main()
