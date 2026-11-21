# AUREX Technical Architecture

## 1. Selected direction

AUREX uses Kotlin Multiplatform (KMP) with Gradle Kotlin DSL. Android is the first target. Compose Multiplatform is the shared UI direction. Koin is the shared dependency-injection direction.

KMP is a code-sharing strategy, not a requirement to force all platform behavior into common code.

## 2. Platform rollout

| Target | Initial role | Status |
|---|---|---|
| Android | Primary operational client | First implementation |
| Desktop JVM | Companion administration and development target | Planned |
| iOS | Shared domain/application logic; evaluate shared UI and native integration | Later |
| Web | AUREX Cloud administration experience | Separate decision |
| Server JVM | API and synchronization services | Separate backend decision |

Do not add every target to the first build just because the toolchain supports it. Start with Android and common tests. Add desktop when it provides immediate development or product value. Add iOS when there is a defined product requirement and an available macOS/Xcode build environment.

## 3. Logical repository layout

The following is a target architecture, not a claim that these Gradle modules already exist:

```text
AUREX/
├── apps/
│   ├── androidApp/
│   ├── desktopApp/             # later
│   └── iosApp/                 # later; Xcode project
├── core/
│   ├── common/
│   ├── domain/
│   ├── application/
│   ├── model/
│   ├── financial/
│   ├── database/
│   ├── network/
│   ├── hardware/
│   └── synchronization/
├── features/
│   ├── identity/
│   ├── organization/
│   ├── catalog/
│   ├── sales/
│   ├── inventory/
│   ├── purchasing/
│   └── accounting/
├── backend/                    # separate JVM deployment, later
├── build-logic/
├── gradle/
└── docs/
```

Physical module names and boundaries must be validated against the domain map before they are created. Avoid one module per folder without a meaningful dependency or release boundary.

## 4. KMP source sets

- `commonMain`: platform-neutral business rules, use cases, contracts, serialization models and selected shared UI.
- `androidMain`: Android APIs, Android database builder, printer/scanner/payment device integrations and Android lifecycle.
- `iosMain`: Apple APIs, iOS database builder and native integrations.
- `jvmMain`: desktop/JVM-specific implementations.
- `commonTest`: shared domain and application tests.
- Platform test source sets: integration tests for platform-specific adapters.

Shared code must not expose Android Context, UIKit objects, JVM-only file APIs or other platform-specific types through common interfaces.

## 5. UI strategy

Use Compose Multiplatform for shared screens and reusable components where a consistent experience is desirable. Keep platform entry points and integrations native.

AUREX POS may require device-specific flows for receipt printers, barcode scanners, cash drawers, customer displays and payment terminals. These are accessed through explicit hardware interfaces with platform implementations. Do not put device SDK calls inside shared composables or domain use cases.

AUREX Cloud web UI is not committed to Compose Multiplatform Web. Select its frontend approach separately after the cloud administration requirements are understood.

## 6. Domain and application boundaries

- Domain modules own business invariants, entities, value objects and policies.
- Application modules own use cases, orchestration, ports and transaction boundaries.
- Data modules implement persistence and remote adapters.
- Feature modules own user-facing workflows and depend on shared contracts.
- Core modules must never depend on feature implementations.
- Cross-feature workflows belong in an explicit application-level coordinator, not cyclic feature dependencies.

## 7. Persistence and data access

Room KMP is the preferred relational persistence candidate. Before adopting it, prove:
- The selected target matrix is supported by the exact Room release.
- Database creation and file locations work on each target.
- Migrations are deterministic and tested.
- Transaction boundaries cover complete business operations.
- Backup, restore and corruption recovery are documented.
- Schema export and migration artifacts are checked into source control.

Use platform-specific database builders where required. Shared repositories should depend on domain-facing interfaces, not Room entities.

## 8. Dependency injection

Use Koin for shared KMP dependency graphs. Keep platform-specific bindings in platform modules. Avoid resolving dependencies from domain objects or introducing service-locator access into business rules.

## 9. Networking and backend

Ktor Client is the leading multiplatform networking candidate. The backend is a separate process and deployment boundary. Ktor Server is the leading server candidate, but API design, authentication, tenant isolation, hosting and deployment topology require their own ADR.

Never treat client-side authorization as a substitute for server-side authorization.

## 10. Financial arithmetic

Money must use exact decimal arithmetic. Do not use Float or Double. The shared API must be platform-neutral; JVM-only BigDecimal cannot leak into common code. Select a KMP-compatible exact-decimal implementation in a dedicated ADR before implementing production financial calculations.

Money, currency, scale, rounding mode, rounding point, tax policy and calculation version must be explicit. Financial operations require deterministic cross-platform tests.

## 11. Build and quality strategy

- Use a Gradle version catalog to centralize dependency versions.
- Pin a compatible Kotlin, Compose, Android Gradle Plugin, Gradle and KSP/tooling matrix after a clean proof of concept.
- Do not copy version numbers from old projects without compatibility verification.
- Run common tests on every pull request.
- Run Android compile, unit and instrumented tests in CI as appropriate.
- Add desktop/iOS build jobs only when those targets are officially in scope.
- Keep secrets and signing material outside source control.
- Record actual build and test evidence; never infer success from source inspection.

## 12. Initial proof-of-concept exit criteria

Before building business features, demonstrate:
1. A clean Gradle KMP project imports in the chosen IDE.
2. Android app launches on a physical device.
3. A common domain module compiles for Android and common tests pass.
4. Compose Multiplatform screen renders on Android.
5. Koin resolves a shared use case through platform composition.
6. Room KMP database opens, writes, reads and migrates on the selected initial target.
7. A hardware interface can be implemented by an Android adapter without leaking Android types into common code.
8. CI can reproduce the Android build and common tests.

Only after these criteria pass should the repository establish its first production domain modules.
