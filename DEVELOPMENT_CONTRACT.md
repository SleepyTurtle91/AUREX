# AUREX Development Contract

This document defines non-negotiable engineering constraints. Changes that violate this contract must be redesigned or explicitly resolved through an amended contract and an Architecture Decision Record.

## 1. Dependency direction

- Domain code must not depend on UI, Android framework, database, network or device-specific implementations.
- Feature modules may depend on approved shared/core contracts.
- Core/shared modules must not depend on feature modules.
- Infrastructure implements interfaces defined at appropriate inner boundaries.
- Dependency injection assembles implementations at application boundaries.
- Platform-specific code belongs in platform source sets or adapters, not in common domain code.

## 2. Kotlin Multiplatform boundaries

- Keep portable business rules in `commonMain` where feasible.
- Keep Android, iOS, desktop and other platform APIs in their respective source sets or adapter modules.
- Do not force code sharing where native behavior is materially better or required.
- Shared public APIs must avoid leaking platform-specific types.
- Add a target only when it has an owner, a build check and a meaningful use case.

## 3. Financial correctness

- Never represent money using Float or Double.
- Use exact decimal arithmetic and explicit rounding policies.
- The shared financial domain must not depend directly on JVM-only `java.math.BigDecimal`.
- Currency, scale, rounding mode and rounding point must be deliberate.
- Tax, discounts, allocation, refunds, tenders and settlement rules require tests.
- Preserve source values and calculation context where auditability requires it.
- Never assume one country's tax or cash-rounding rules are universal.

## 4. Data integrity

- Persist business operations transactionally.
- Financial and inventory mutations must have traceable records.
- Define transaction identity and idempotency for retryable operations.
- Avoid destructive schema changes without a migration and recovery plan.
- Consider tenant, company, branch, location and terminal scope in data ownership.
- Define conflict behavior per domain; do not apply one global last-write-wins policy.

## 5. Offline-first behavior

- A supported local workflow must not require cloud availability to complete unless its business or regulatory requirement explicitly demands it.
- Use durable outboxes or equivalent mechanisms for deferred delivery.
- Retry safely with idempotency.
- Distinguish local persistence success from remote synchronization success.
- Surface synchronization state without blocking unrelated local operations.

## 6. Security and privacy

- Apply least privilege.
- Do not store secrets in source control.
- Do not log credentials, tokens, payment secrets or unnecessary personal data.
- Define authorization at the use-case/domain boundary, not only by hiding UI controls.
- Record security-sensitive actions with appropriate audit metadata.
- Encrypt sensitive data at rest and in transit where the threat model requires it.

## 7. Testing

- Unit-test domain rules and financial calculations in commonTest where portable.
- Test platform adapters on their target platforms.
- Test transactional persistence and migrations.
- Test retry, idempotency and synchronization conflict cases.
- Add integration tests for external adapters.
- Critical business paths require automated regression coverage.

## 8. Maintainability

- Prefer immutable domain models and explicit state transitions.
- Use descriptive names and small, cohesive abstractions.
- Avoid hidden global state and service-locator patterns in domain logic.
- Keep public APIs minimal and documented.
- Add dependencies only with a clear capability need and maintenance rationale.

## 9. Delivery integrity

- Do not claim a build, test, security audit or hardware validation passed unless evidence exists.
- Keep CI reproducible across the targets actually supported by the project.
- Keep changes small enough to review.
- No pull request may be merged without explicit project-owner approval.
