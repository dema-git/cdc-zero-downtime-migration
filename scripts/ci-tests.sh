#!/usr/bin/env bash
set -euo pipefail

echo "[ci-tests] Running tests inside Docker..."

export PYTHONPATH=/app

python -m pytest -q