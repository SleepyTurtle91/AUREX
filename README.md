# AUREX

**Business. Connected.**

AUREX is a personal, modular business software ecosystem designed to bring commerce operations, accounting, inventory, and multi-branch management together through a shared and reliable platform.

AUREX is an independent project. It is not a rename or continuation of FlashPOS, and it is not a direct fork of ExtroPOSv2. Earlier projects may be consulted as reference material, but AUREX is developed from a clean foundation.

## Current implementation

The first Android/KMP foundation is being established on the `foundation/kmp-android-poc` branch.

- Kotlin Multiplatform and Compose Multiplatform
- Android-first application target
- Koin dependency injection
- Common application logic and common tests
- Dependency versions centralized in the Gradle version catalog

See [Foundation POC](docs/FOUNDATION_POC.md) for setup and acceptance criteria. GitHub Actions runs the initial Android CI checks; see [CI documentation](docs/CI.md).

## Product ecosystem

| Product | Responsibility | Status |
|---|---|---|
| AUREX Core | Shared business domains, identity, configuration, events and contracts | Planned |
| AUREX POS | Retail and food & beverage point of sale | Planned |
| AUREX Books | Accounting and financial management | Planned |
| AUREX Stock | Inventory, purchasing and procurement | Planned |
| AUREX Cloud | Central administration and multi-branch management | Planned |
| AUREX Sync | Reliable local and remote data synchronization | Planned |

Product names describe intended capabilities, not a promise that every product will ship as a separate application. Boundaries will be validated through architecture decisions.

## Foundational principles

1. **Domain-first:** model business rules before screens and infrastructure.
2. **Offline-first:** local operations must remain reliable without internet access.
3. **Financial precision:** use exact decimal arithmetic for money; never use binary floating-point for financial values.
4. **Auditability:** important business decisions and financial mutations must be traceable.
5. **Modularity:** shared capabilities have explicit contracts and dependency direction.
6. **Branch-aware:** tenant, company, branch, location and terminal scope must be explicit in the domain model.
7. **Interoperability:** integrations are adapters around stable domain contracts.
8. **Testability:** critical rules are verified independently of UI and infrastructure.
9. **Incremental delivery:** establish a small verified foundation before expanding product scope.

## Documentation

- [Project vision](docs/PRODUCT_VISION.md)
- [Architecture principles](docs/ARCHITECTURE.md)
- [Technical architecture](docs/TECHNICAL_ARCHITECTURE.md)
- [Development contract](DEVELOPMENT_CONTRACT.md)
- [Roadmap](ROADMAP.md)
- [ADR index](docs/adr/README.md)
- [Project governance](CONTRIBUTING.md)
