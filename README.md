# Peter's AI-assisted security learning lab

Learn the pipeline one stage at a time:

`Code → tests → SAST + SCA + DAST + SBOM → review findings → optional AI proposal → human review → re-test`

## What each tool does
| Stage | Tool | What it examines |
|---|---|---|
| SAST | GitHub CodeQL | Python source without running the app |
| SCA | Trivy | Known vulnerabilities in dependency metadata |
| DAST | OWASP ZAP baseline | The running localhost demo's HTTP behavior |
| SBOM | Syft / CycloneDX JSON | An inventory, not itself a vulnerability verdict |
| AI assistance | Local review-packet generator; optionally Copilot Autofix | Explain evidence and propose changes, never approve them |

**This is a scaffold, not a production security gate.** The main workflow records
findings rather than failing on severity. It still fails on scanner execution
errors. It does not deploy, merge, open PRs, or send data to an AI service.

## Start here (Linux, Python 3, Docker)
Run these from this project directory, one at a time:

```bash
python3 -m unittest discover -s tests -v
bash scripts/scan.sh sca
bash scripts/scan.sh sbom
bash scripts/scan.sh dast
python3 scripts/review_packet.py
```

Open `reports/zap.html` in your browser. Read `reports/trivy.json`,
`reports/sbom.cdx.json`, and `reports/ai-review-packet.md` in VS Code.
DAST starts and stops its own server on `127.0.0.1:18765`. If that port is busy,
the script stops rather than scanning the existing service. Docker host networking
here assumes Linux. Nothing is exposed on your LAN.

## Understand the sample
- `app/server.py`: small stdlib-only Python app. No external services or credentials.
- It deliberately omits some defense-in-depth HTTP headers for the ZAP exercise.
- `fixtures/dependencies/requirements.txt`: **scan-only** old requests dependency.
  Do not install it. It is unrelated to the running stdlib app.
- SCA and SBOM describe the declared fixture, not a fully resolved installed
  application or OS image. SBOM completeness requires scanning your final built
  artifact as a later exercise. No zero-CVE or full-coverage claim is made.
- CodeQL may find nothing in this small sample. A clean scan is not proof of safety.

## GitHub Actions
`.github/workflows/security.yml` runs on main pushes, pull requests, or manually.
It publishes reports as a seven-day artifact visible to repository readers.
Only synthetic lab files belong in this repository. Actions are immutable-SHA
pinned and Docker scanner images are digest pinned. Pins need deliberate updates.
No `pull_request_target`, privileged checkout, AI secret, or write-capable checkout
credential is used. Never add real company source or reports without authorization.

`.github/workflows/codeql.yml` is **manual only**, so unsupported private-repository
code scanning does not break the core learning pipeline. Check repository Code
Security eligibility, organizational policy, and licensing before enabling it.
In Actions choose **Optional CodeQL SAST → Run workflow** when eligible. If default
CodeQL setup already exists, choose one setup mode rather than duplicating it.
CodeQL and Copilot Autofix have not been run or enabled by creating these files.

## Your first remediation exercise
1. Run the scanners and save baseline reports outside the ignored reports folder
   if you want to retain a comparison (never commit private reports).
2. Pick one requests advisory. Read its installed/fixed-version evidence.
3. Use the local review packet with an approved AI assistant only after inspecting
   what will be shared. No automatic redaction can guarantee privacy.
4. Update the **fixture** to a supported release after checking upstream guidance.
5. Re-run Trivy and Syft and compare results. This fixture exercise is not an
   application compatibility test because the app does not use requests.
6. Add appropriate HTTP headers to the app, extend tests, and repeat ZAP.
7. Review a proposed patch as a human. See `docs/remediation-review.md`.

For a real dependency change, also run application integration/regression tests,
review breaking changes, and rescan the built image. AI is a helper, not a security
oracle. ZAP baseline is limited crawling/passive analysis, not a full pentest or
authenticated DAST suite. Only scan systems you own or are authorized to test.

## Reference documentation
- https://docs.github.com/en/code-security/code-scanning
- https://docs.github.com/en/code-security/code-scanning/managing-code-scanning-alerts/about-autofix-for-codeql-code-scanning
- https://trivy.dev/latest/docs/
- https://oss.anchore.com/docs/guides/sbom/
- https://www.zaproxy.org/docs/docker/baseline-scan/

See `docs/validation.md` for what actually ran and what remains unverified.
