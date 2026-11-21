# AUREX Roadmap

This roadmap is directional. A checkbox is only completed when implementation and verification evidence are available.

## Phase 0 — Foundation and product definition (current)
- [x] Establish AUREX identity and repository.
- [x] Define ecosystem product map.
- [x] Establish project governance and development contract.
- [x] Establish initial architecture principles and ADR process.
- [x] Select Kotlin Multiplatform as the codebase strategy.
- [x] Select Compose Multiplatform as the shared UI direction.
- [x] Select Koin as the shared dependency-injection direction.
- [ ] Define target users, business scenarios and non-goals.
- [ ] Define tenant, company, branch, location and terminal vocabulary.
- [ ] Define core domain map and bounded contexts.
- [ ] Define security, audit and data-retention baseline.
- [ ] Validate Room KMP on intended targets and test migration strategy.
- [ ] Select a multiplatform exact-decimal implementation for shared financial rules.
- [ ] Decide backend deployment topology and API boundaries.
- [ ] Pin a compatible Kotlin, Gradle, Compose and Android toolchain.
- [ ] Define CI build, test and quality gates.

## Phase 1 — Shared platform foundation
- [ ] Establish Gradle multi-module KMP build.
- [ ] Establish Android application target.
- [ ] Establish common domain and application modules.
- [ ] Establish commonTest and platform test conventions.
- [ ] Establish dependency injection and platform composition roots.
- [ ] Identity, authentication and authorization foundations.
- [ ] Tenant, company, branch, location and terminal model.
- [ ] Configuration and capability model.
- [ ] Audit trail and domain event contracts.
- [ ] Local persistence foundation and migration policy.
- [ ] Error, logging and diagnostics conventions.
- [ ] Financial primitives and tested decimal policies.

## Phase 2 — Commerce foundation
- [ ] Product and service catalog.
- [ ] Pricing, discounts and tax configuration.
- [ ] Inventory ledger and stock movements.
- [ ] Purchasing and supplier workflows.
- [ ] Sales transaction lifecycle.
- [ ] Tender, payment and settlement abstractions.
- [ ] Returns, refunds and voids.

## Phase 3 — AUREX POS
- [ ] Retail checkout.
- [ ] F&B ordering and table workflows.
- [ ] Kitchen routing and display workflow.
- [ ] Receipt and peripheral abstraction.
- [ ] Shift management and cash reconciliation.
- [ ] Offline operation and recovery verification.

## Phase 4 — AUREX Books
- [ ] Chart of accounts and accounting periods.
- [ ] Journals and double-entry posting model.
- [ ] Customer and supplier balances.
- [ ] Receivables and payables.
- [ ] Bank and payment reconciliation.
- [ ] Financial statements and audit trail.
- [ ] Integration contracts with POS, Stock and external systems.

## Phase 5 — AUREX Sync and AUREX Cloud
- [ ] Durable synchronization outbox/inbox.
- [ ] Idempotency and replay handling.
- [ ] Domain-specific conflict resolution.
- [ ] Branch transfers and centralized visibility.
- [ ] Cloud administration and observability.
- [ ] Backup, restore and disaster recovery.

## Phase 6 — Ecosystem expansion
- [ ] Consolidated reporting and analytics.
- [ ] External accounting and commerce integrations.
- [ ] Additional industry workflows.
- [ ] Public integration APIs and extension strategy.
- [ ] Deployment, upgrade and support tooling.

## Release policy
A milestone is not production-ready merely because screens or data models exist. It requires acceptance criteria, automated tests, data migration validation, security review appropriate to scope, and documented operational recovery.
