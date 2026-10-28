#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
PYTHONPATH=src python -m gbt_flow_canvas info
PYTHONPATH=src python -m gbt_flow_canvas check --payload '{}'
PYTHONPATH=src python -m gbt_flow_canvas run   --payload '{}'
