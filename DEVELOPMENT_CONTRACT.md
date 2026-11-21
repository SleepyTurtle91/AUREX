# AUREX Development Contract

This document defines non-negotiable engineering constraints. Changes that violate this contract must be redesigned or explicitly resolved through an amended contract and an Architecture Decision Record.

## 1. Dependency direction

- Domain code must not depend on UI, Android framework, database, network or device-specific implementations.
- Feature modules may depend on approved shared/core contracts.
- Core/shared modules must not depend on feature modules.
- Infrastructure implements interfaces defined at appropriate inner boundaries.
- Dependency injection assembles implementations at application boundaries.

## 2. Financial correctness

- Never represent money using Float or Double.
- Use exact decimal representations and explicit rounding policies.
- Currency, scale, rounding mode and rounding point must be deliberate.
- Tax, discounts, allocation, refunds, tenders and settlement rules require tests.
- Preserve source values and calculation context where auditability requires it.
- Never assume one country's tax or cash-rounding rules are universal.

## 3. Data integrity

- Persist business operations transactionally.
- Financial and inventory mutations must have traceable records.
- Define transaction identity and idempotency for retryable operations.
- Avoid destructive schema changes without a migration and recovery plan.
- Consider tenant, company, branch, location and terminal scope in data ownership.
- Define conflict behavior per domain; do not apply one global last-write-wins policy.

## 4. Offline-first behavior

- A supported local workflow must not require cloud availability to complete unless its business or regulatory requirement explicitly demands it.
- Use durable outboxes or equivalent mechanisms for deferred delivery.
- Retry safely with idempotency.
- Distinguish local persistence success from remote synchronization success.
- Surface synchronization state without blocking unrelated local operations.

## 5. Security and privacy

- Apply least privilege.
- Do not store secrets in source control.
- Do not log credentials, tokens, payment secrets or unnecessary personal data.
- Define authorization at the use-case/domain boundary, not only by hiding UI controls.
- Record security-sensitive actions with appropriate audit metadata.
- Encrypt sensitive data at rest and in transit where the threat model requires it.

## 6. Testing

- Unit-test domain rules and financial calculations.
- Test transactional persistence and migrations.
- Test retry, idempotency and synchronization conflict cases.
- Add integration tests for external adapters.
- Critical business paths require automated regression coverage.

## 7. Maintainability

- Prefer immutable domain models and explicit state transitions.
- Use descriptive names and small, cohesive abstractions.
- Avoid hidden global state and service-locator patterns in domain logic.
- Keep public APIs minimal and documented.
- Add dependencies only with a clear capability need and maintenance rationale.

## 8. Delivery integrity

- Do not claim a build, test, security audit or hardware validation passed unless evidence exists.
- Keep CI reproducible.
- Keep changes small enough to review.
- No pull request may be merged without explicit project-owner approval.
