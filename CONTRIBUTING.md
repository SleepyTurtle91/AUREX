# Project Governance and Contribution Guide

## Working model

AUREX is developed incrementally. Changes should be reviewable, tested and consistent with the documented architecture.

## Change workflow

1. Confirm the requirement and its acceptance criteria.
2. Inspect the existing implementation and relevant architecture decisions.
3. Create or update an issue for non-trivial work.
4. Implement on a focused branch.
5. Run the relevant tests and checks.
6. Open a pull request with context, scope, test evidence and known limitations.
7. Review and explicitly approve before merging.

No contributor or automation may merge a pull request without explicit owner approval.

## Required pull request content

- Why the change is needed.
- What changed and what did not change.
- Business rules affected.
- Database or migration impact.
- Security, privacy and audit implications.
- Tests executed and their results.
- Screenshots or recordings for UI changes, where useful.
- Rollback or recovery considerations for risky changes.

## Engineering expectations

- Keep changes focused.
- Avoid speculative abstractions and unnecessary dependencies.
- Preserve domain boundaries.
- Do not silently change established business rules.
- Never commit credentials, signing keys, tokens or production customer data.
- Document material architectural decisions as ADRs.
- Do not mark work complete without implementation and verification evidence.

## Decision authority

The project owner has final authority over product scope, architecture decisions, releases and merges. A recommendation or automated check is not an approval.
