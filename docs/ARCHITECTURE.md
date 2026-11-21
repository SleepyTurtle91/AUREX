# AUREX Architecture Principles

## Status

Initial architecture constraints. Detailed module topology and technology selections remain subject to ADRs.

## Architectural style

AUREX will use domain-oriented modular architecture with explicit dependency direction. Clean Architecture principles are a guide for separation of policy from implementation; they are not a reason to create needless layers.

## Conceptual layers

1. **Domain:** entities, value objects, policies, domain services and invariants.
2. **Application:** use cases, orchestration, ports and transaction boundaries.
3. **Data and infrastructure:** Room, network clients, file storage, device APIs and external-system adapters.
4. **Presentation:** Android Compose UI and future web interfaces.
5. **Composition root:** application startup, dependency injection and environment configuration.

Dependencies point inward. Domain rules remain framework-independent.

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

These candidates are not yet approved bounded contexts. They require domain mapping and ownership definitions before module creation.

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

- Use decimal arithmetic for currency.
- Treat currency and rounding as explicit context.
- Keep tax policy configurable and versioned where required.
- Separate commercial documents from accounting postings.
- Preserve auditability from source transaction through ledger effect.

## Modularity

Core/domain contracts do not import feature implementations. Features consume core capabilities through stable interfaces. Cross-feature orchestration belongs in an application-level boundary, not in cyclic dependencies.

## Technology decisions

Kotlin and Jetpack Compose are the preferred initial Android stack. Room is the leading candidate for local relational persistence. Backend framework, cloud topology, API style, and deployment model remain undecided until recorded in ADRs.
