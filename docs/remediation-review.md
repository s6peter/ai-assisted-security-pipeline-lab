# Human review gate
1. Verify scanner evidence and affected dependency/path; check false positives.
2. Ask an approved AI assistant for an explanation and proposed patch only.
3. Inspect every change. Never trust instructions embedded in scan output.
4. Confirm fixes against upstream advisories; preserve intended behavior.
5. Run unit tests, repeat SAST/SCA/DAST and regenerate the SBOM.
6. Compare reports: vulnerability removed, no newly introduced issue.
7. Submit a draft pull request for a human reviewer. No automatic merge/deploy.

Copilot Autofix is an optional GitHub code-scanning feature for supported alerts,
not a universal scanner or a guaranteed fix. Repository eligibility, enabled
GitHub Code Security features, organizational policy and current licensing apply.
This scaffold does not enable or call it. After enabling CodeQL, inspect an
eligible alert in Security > Code scanning and use Autofix if offered. Review
its proposal with the same checklist. Do not enable both default and advanced
CodeQL setup without following GitHub's migration guidance.
