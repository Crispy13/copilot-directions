#!/usr/bin/env python3
"""Placeholder description improver for the Copilot adaptation.

The source skill used an external model harness to iterate on skill
descriptions. GitHub Copilot does not expose a bundled public equivalent for
this workflow, so this adapted file fails fast with an explicit explanation.
"""

import argparse
import sys
from pathlib import Path


UNSUPPORTED_MESSAGE = (
    "scripts/improve_description.py is a placeholder in this Copilot adaptation. "
    "It needs an environment-specific external harness to score and rewrite "
    "skill descriptions, and no public Copilot implementation is bundled here. "
    "Use the manual description-improvement loop in SKILL.md or replace this "
    "file with a host-specific implementation."
)


def improve_description(*_args, **_kwargs):
    raise NotImplementedError(UNSUPPORTED_MESSAGE)


def main():
    parser = argparse.ArgumentParser(description="Improve a skill description based on eval results")
    parser.add_argument("--eval-results", required=True, help="Path to eval results JSON")
    parser.add_argument("--skill-path", required=True, help="Path to skill directory")
    parser.add_argument("--history", default=None, help="Path to history JSON (previous attempts)")
    parser.add_argument("--model", required=True, help="Model identifier for an external harness")
    parser.add_argument("--verbose", action="store_true", help="Print extra detail to stderr")
    args = parser.parse_args()

    skill_path = Path(args.skill_path)
    if not (skill_path / "SKILL.md").exists():
        print(f"Error: No SKILL.md found at {skill_path}", file=sys.stderr)
        sys.exit(1)

    print(UNSUPPORTED_MESSAGE, file=sys.stderr)
    sys.exit(2)


if __name__ == "__main__":
    main()
