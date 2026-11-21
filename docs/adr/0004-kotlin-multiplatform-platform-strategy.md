# ADR 0004: Kotlin Multiplatform Platform Strategy

- **Status:** Accepted
- **Date:** 2026-11-21

## Context

AUREX is intended to become a multi-product business software ecosystem. Android is the first practical client target, but shared domain logic and selected user experiences should be reusable across future desktop and mobile clients. The project owner selected Kotlin Multiplatform.

Kotlin Multiplatform (KMP) is the code-sharing technology. It does not require every platform to use the same UI or every implementation to be portable.

## Decision

1. Use Kotlin Multiplatform with Gradle Kotlin DSL as the project codebase strategy.
2. Build and validate Android first.
3. Use Compose Multiplatform for shared UI where it provides a good fit, initially for Android and planned desktop. iOS is a future target and may combine Compose Multiplatform UI with native SwiftUI/UIKit integration as requirements dictate.
4. Keep hardware, OS lifecycle, printing, scanning, file access, payment terminals and other platform-specific integrations behind platform-specific adapters.
5. Keep domain and application rules in `commonMain` whenever they can remain genuinely platform-neutral.
6. Use `commonTest` for portable domain and application tests, with platform-specific tests for adapters.
7. Use Koin as the dependency-injection framework direction for shared KMP modules.
8. Prefer Room KMP for local relational persistence, subject to a proof of concept covering each intended target, migrations, transactions and backup/restore.
9. Treat web as a later, separate decision. Do not make Compose Multiplatform for Web a prerequisite for the first release.
10. Treat the backend as a separate deployment. Kotlin/JVM with Ktor is the leading candidate, but is not selected by this ADR.

## Platform rollout

| Platform | Direction | Timing |
|---|---|---|
| Android | Primary application target; native APIs and Compose Multiplatform UI | First |
| Desktop JVM | Compose Multiplatform companion target | After shared foundation |
| iOS | KMP shared logic; evaluate shared Compose UI and native integration | Later |
| Web | Separate architecture decision for AUREX Cloud | Later |
| Server | Kotlin/JVM candidate; independent server deployment | Separate ADR |

## Financial portability constraint

The existing financial arithmetic decision requires exact decimal arithmetic and prohibits Float/Double for money. JVM `java.math.BigDecimal` is not a common KMP type. Therefore the shared financial domain must expose a platform-neutral exact-decimal abstraction. A KMP-compatible implementation must be selected and tested in a separate ADR before production financial calculations are implemented. JVM-only BigDecimal may be used inside a JVM adapter, but must not leak into common domain APIs.

## Consequences

- One Kotlin language and Gradle toolchain can serve multiple targets.
- Domain rules and selected UI can be shared without sacrificing access to native APIs.
- Platform source sets and adapters remain necessary.
- Android is the only initial release gate; other targets must not delay its foundation.
- The build matrix and CI cost increase as targets are added.
- Library compatibility must be checked per target rather than assumed.
- Exact library versions will be pinned together after a reproducible toolchain proof of concept.

## Alternatives considered

- Flutter/Dart for shared UI and logic: not selected; the owner chose KMP.
- Native Android-only Kotlin: not selected because future code sharing is a stated ecosystem goal.
- Fully shared UI and infrastructure across every platform from day one: rejected as excessive coupling and scope.

## References

- [Kotlin Multiplatform overview](https://kotlinlang.org/docs/multiplatform/kmp-overview.html)
- [Kotlin Multiplatform platform stability](https://kotlinlang.org/docs/multiplatform/supported-platforms.html)
- [Compose Multiplatform and Jetpack Compose](https://kotlinlang.org/docs/multiplatform/compose-multiplatform-and-jetpack-compose.html)
- [Room for Kotlin Multiplatform](https://developer.android.com/kotlin/multiplatform/room)
- [Koin KMP setup](https://insert-koin.io/docs/reference/koin-core/kmp-setup/)
