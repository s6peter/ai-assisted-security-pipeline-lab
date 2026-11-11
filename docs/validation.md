# Validation record — November 11, 2026

Executed on Peter's so4 Linux computer, only in this isolated lab:
- Python unit test: 1 passed (loopback health response).
- Shell syntax: `bash -n scripts/scan.sh` passed.
- Both workflow YAML files parsed; every external action has a full 40-character SHA.
- Trivy 0.72.0 actual container scan: 5 findings on the intentionally old requests
  metadata fixture. Database downloaded successfully during this run.
- Syft 1.49.0 actual container scan: CycloneDX JSON, 2 components.
- ZAP baseline actual container scan: 3 URLs, 4 warning groups, 0 fail groups,
  64 pass groups. Exit code 2 retained in reports/zap-exit-code.txt. Warnings:
  missing X-Content-Type-Options; server version disclosure; cacheable content;
  missing/invalid Cross-Origin-Resource-Policy. This is not a clean security verdict.
- Review packet generated locally; no AI API request or automated fix executed.
- Temporary localhost app stopped after DAST; no existing Jenkins or VM changed.

Not run: GitHub-hosted Actions, CodeQL analysis, Copilot Autofix, AI model calls,
production deployments, or compatibility tests for the scan-only dependency.
YAML parsing is not a substitute for an actual GitHub workflow run.
Reports are ignored by git and remain on so4 for review.

Scanner containers are digest pinned. Trivy's vulnerability database is current
at run time rather than pinned; counts can change on a subsequent scan. This is
expected. Downloaded scanner images remain in Docker's image cache.
