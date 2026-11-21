# AUREX

**Business. Connected.**

AUREX is a personal, modular business software ecosystem designed to bring commerce operations, accounting, inventory, and multi-branch management together through a shared and reliable platform.

AUREX is an independent project. It is not a rename or continuation of FlashPOS, and it is not a direct fork of ExtroPOSv2. Earlier projects may be consulted as reference material, but AUREX is developed from a clean foundation.

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

## Technology direction

AUREX uses **Kotlin Multiplatform (KMP)** as its codebase strategy.

- **Android first:** Kotlin with Compose Multiplatform UI and native Android integration where required.
- **Desktop:** Compose Multiplatform/JVM is a planned companion target, useful for administration workflows and development.
- **iOS:** a future target; platform-specific integrations will remain native where appropriate.
- **Web:** not part of the initial client commitment. AUREX Cloud's web experience will be decided separately.
- **Backend:** Kotlin/JVM with Ktor is the leading candidate, but remains a separate deployment and architecture decision.

The initial shared layer will contain domain rules, application use cases, contracts and suitable data logic. Platform-specific hardware, lifecycle, storage paths and operating-system APIs belong in platform source sets or adapters.

See [Technical Architecture](docs/TECHNICAL_ARCHITECTURE.md) and [ADR 0004](docs/adr/0004-kotlin-multiplatform-platform-strategy.md).

## Documentation

- [Project vision](docs/PRODUCT_VISION.md)
- [Architecture principles](docs/ARCHITECTURE.md)
- [Technical architecture](docs/TECHNICAL_ARCHITECTURE.md)
- [Development contract](DEVELOPMENT_CONTRACT.md)
- [Roadmap](ROADMAP.md)
- [ADR index](docs/adr/README.md)
- [Project governance](CONTRIBUTING.md)

## Current phase

**Phase 0 — Foundation and product definition.**

No production application modules have been committed yet. The KMP direction is selected; detailed dependency versions, module boundaries, financial arithmetic implementation and backend topology must be validated before application code begins.

## Legacy references

- [ExtroPOSv2](https://github.com/SleepyTurtle91/ExtroPOSv2) — reference implementation only.
- FlashPOS — separate commercial product; not part of this repository.

## License

No open-source license has been selected yet. Until one is added, all rights are reserved by the repository owner.
