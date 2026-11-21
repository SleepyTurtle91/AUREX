# AUREX Architecture Principles

## Status
Initial architecture constraints. The cross-platform strategy is selected in [ADR 0004](adr/0004-kotlin-multiplatform-platform-strategy.md). Detailed domain boundaries and dependency choices remain subject to further ADRs.

## Architectural style
AUREX uses domain-oriented modular architecture with explicit dependency direction. Clean Architecture principles guide separation of policy from implementation; they are not a reason to create needless layers.

## Conceptual layers
1. **Domain:** entities, value objects, policies, domain services and invariants.
2. **Application:** use cases, orchestration, ports and transaction boundaries.
3. **Data and infrastructure:** database, network clients, file storage, device APIs and external-system adapters.
4. **Presentation:** Compose Multiplatform UI and platform-native interfaces where needed.
5. **Composition root:** application startup, dependency injection and environment configuration.

Dependencies point inward. Domain rules remain framework-independent and should compile in common KMP source sets wherever practical.

## KMP source-set policy
- `commonMain`: portable domain and application rules, shared contracts, platform-neutral data logic and UI only when intentionally shared.
- `androidMain`: Android framework, Android hardware, Android lifecycle and Android-specific integrations.
- `iosMain`: Apple platform APIs and iOS-specific integrations.
- `jvmMain`: shared JVM implementations where appropriate, including desktop-specific infrastructure.
- `commonTest`: platform-neutral domain and application tests.
- Platform-specific tests verify adapters and integration behavior.

Do not move platform APIs into `commonMain` merely to force code sharing. Use interfaces, dependency inversion and narrow platform adapters.

## Initial domain candidates
- Identity and access
- Organization and tenancy
- Catalog and pricing
- Sales and returns
- Payments and settlement
- Inventory and procurement
- Accounting
- Tax and compliance
- Workforce and shifts
- Synchronization and integration
- Reporting and analytics
- Audit and diagnostics

These candidates are not yet approved bounded contexts. They require domain mapping and ownership definitions before physical module creation.

## Multi-organization vocabulary
The model must distinguish at least:
- Tenant: the top-level customer/data isolation boundary, if SaaS operation is adopted.
- Company: a legal or accounting entity.
- Branch: an operational business location.
- Location: a stock or operational sub-location within a branch.
- Terminal: a device or execution node.
- User and membership: an identity and its relationship to an organization.

Exact semantics, hierarchy and cardinality must be decided before schema implementation.

## Offline and synchronization model
- Local persistence is authoritative for supported local workflows.
- Remote delivery is asynchronous where practical.
- Every retryable mutation needs stable identity and idempotency semantics.
- Conflict rules are domain-specific.
- Sales and posted accounting records should not be casually overwritten by last-write-wins.
- Inventory quantity changes should be represented as traceable movements or events.
- Synchronization state must be observable and recoverable.

## Financial model
- Use exact decimal arithmetic for currency; never use binary floating-point.
- Keep the shared money abstraction independent of JVM-only numeric classes.
- Treat currency and rounding as explicit context.
- Keep tax policy configurable and versioned where required.
- Separate commercial documents from accounting postings.
- Preserve auditability from source transaction through ledger effect.

## Modularity
Core/domain contracts do not import feature implementations. Features consume core capabilities through stable interfaces. Cross-feature orchestration belongs in an application-level boundary, not in cyclic dependencies.

## Technology direction
- Kotlin Multiplatform is the selected code-sharing strategy.
- Compose Multiplatform is the selected shared UI direction for Android and planned desktop/iOS clients, while native platform APIs remain available through adapters.
- Koin is the selected dependency-injection direction for shared KMP modules.
- Room KMP is the preferred local relational database candidate; target-specific support and migration behavior must be validated in a proof of concept.
- Ktor is the preferred backend candidate, but server deployment and API architecture require a separate ADR.
- Exact library and plugin versions must be selected as a compatible, tested toolchain rather than copied from stale examples.
