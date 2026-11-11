#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
mkdir -p reports
TRIVY='aquasec/trivy@sha256:cffe3f5161a47a6823fbd23d985795b3ed72a4c806da4c4df16266c02accdd6f'
SYFT='anchore/syft@sha256:13b53ebabe3d215268c90cf8fb9b875f0183908245f376fd4b3a2cb69d21d484'
ZAP='ghcr.io/zaproxy/zaproxy@sha256:4f67b3e798fd4e23649265eac9ad84a67e883850c96691fc1743b2a6e1cc7ed0'
case "${1:-help}" in
sca)
  # Scan metadata only; never install the intentionally old dependencies.
  docker run --rm -v "$PWD/fixtures/dependencies:/src:ro" "$TRIVY" fs --scanners vuln --format json /src > reports/trivy.json
  ;;
sbom)
  docker run --rm -v "$PWD/fixtures/dependencies:/src:ro" "$SYFT" dir:/src -o cyclonedx-json > reports/sbom.cdx.json
  ;;
dast)
  # Linux host networking reaches only this lab's loopback-bound server.
  # Refuse to scan any pre-existing process occupying the selected port.
  python3 - <<'PY'
import socket
with socket.socket() as s: s.bind(('127.0.0.1', 18765))
PY
  python3 -m app.server > reports/app.log 2>&1 &
  app_pid=$!
  trap 'kill "$app_pid" 2>/dev/null || true' EXIT
  sleep 1
  kill -0 "$app_pid"
  # ZAP exit 1=findings, 2=warnings; 3+=execution failure. Preserve status.
  set +e
  docker run --rm --network host --user "$(id -u):$(id -g)" -v "$PWD/reports:/zap/wrk:rw" "$ZAP" zap-baseline.py -t http://127.0.0.1:18765 -m 1 -J zap.json -r zap.html
  status=$?
  set -e
  echo "$status" > reports/zap-exit-code.txt
  if (( status > 2 )); then exit "$status"; fi
  ;;
*) echo 'Usage: bash scripts/scan.sh {sca|sbom|dast}'; exit 2;;
esac
