#!/usr/bin/env bash
set -euo pipefail

if git ls-files --error-unmatch .env >/dev/null 2>&1; then
  echo "ERROR: .env is tracked by git. Keep local secrets out of the repository."
  exit 1
fi

echo "Local secret checks passed."
