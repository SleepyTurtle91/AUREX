# ADR 0005: Room 3 Kotlin Multiplatform Persistence Evaluation

- **Status:** Proposed
- **Date:** 2026-11-21

## Context

AUREX is offline-first and is expected to share domain and data-access contracts across Android first, with JVM desktop and iOS considered later. Persistence must provide transactional writes, explicit schema evolution, deterministic queries, and a practical test strategy. The first app slice currently has no database dependency.

Room 3.0 is now a stable KMP line. Version 3.0.3 is the latest stable release in the release notes as of this ADR. Unlike Room 2.x, Room 3 uses the `androidx.room3` package and Maven group, is Kotlin/KSP-first, and uses the multiplatform SQLite Driver APIs.

## Proposed evaluation path

Evaluate the following combination in an isolated proof of concept before adding it to production application code:

- Room: `androidx.room3:room3-runtime:3.0.3` and `androidx.room3:room3-compiler:3.0.3`.
- SQLite: `androidx.sqlite:sqlite-bundled:2.7.1`, using `BundledSQLiteDriver`.
- KSP: `com.google.devtools.ksp:2.3.12`.
- Room Gradle Plugin: `androidx.room3` version `3.0.3`, with a checked-in schema directory.
- Current baseline: Kotlin 2.4.21, AGP 8.13.2, Gradle 8.13 and JDK 17.

The current KSP documentation lists KSP 2.3.12 as compatible with Kotlin Gradle Plugin 2.3.20–2.4.x, AGP 8.13.0 or later, Gradle 8.13 or later, and JDK 17 or later. This matches the existing AUREX toolchain without requiring an AGP or Gradle upgrade.

## POC implementation boundary

Keep the POC isolated from production domain models and workflows. It should prove the Room compiler and generated constructor, Android database builder, SQLite driver, queries, transactions, schema output, and migration path. Do not create an early production repository abstraction solely to wrap Room.

The candidate structure should follow the KMP model:

- Room entities, database declaration and suspend/Flow DAOs in `commonMain`.
- KSP processor configuration only for the currently configured Android target (`kspAndroid`). Add processor configurations for iOS or JVM only when those targets are actually introduced.
- Android database path creation in `androidMain` using `Context.getDatabasePath`.
- Shared Room configuration in common code with `BundledSQLiteDriver` and a coroutine context.
- Checked-in Room schema JSON files managed by the Room Gradle Plugin.

## Acceptance criteria

The POC passes only when all of the following are demonstrated:

1. KSP generates the Room implementation and the Android target compiles cleanly.
2. A database can be opened, written, closed, reopened and read back with values preserved.
3. A Flow query emits expected changes after insert, update and delete operations.
4. A versioned schema migration preserves existing data and matches the committed schema exports.
5. A failed write transaction rolls back rather than leaving partial state.
6. The database can be cleared/recreated in tests without corrupting another test's data.
7. The POC can be removed cleanly without leaving Room or SQLite dependencies in the application foundation if it fails.

The first test environment is Android. Desktop and iOS compatibility must be checked before calling the persistence decision cross-platform production-ready.

## Alternatives considered

- **SQLDelight:** a strong KMP alternative with compile-time checked SQL and generated Kotlin APIs. Keep it as a comparison option if Room's schema/migration or KSP path proves awkward.
- **Raw `androidx.sqlite` APIs:** useful for a minimal driver test but lower-level; Android documentation recommends Room for feature-rich database access.
- **Room 2.x:** rejected for a new KMP implementation. Room 3 is the KMP-focused successor with a new package and driver API.

## Consequences

- This ADR does not approve Room for production use yet.
- No database schema, domain entity or persistence boundary should be considered final based solely on the POC.
- Schema versioning, migrations, backup/restore, encryption requirements and offline data ownership remain separate design work.

## References

- [Room 3 release notes](https://developer.android.com/jetpack/androidx/releases/room3)
- [Set up Room database for KMP](https://developer.android.com/kotlin/multiplatform/room)
- [Set up SQLite for KMP](https://developer.android.com/kotlin/multiplatform/sqlite)
- [KSP overview and compatibility](https://kotlinlang.org/docs/ksp-overview.html)
- [KSP with Kotlin Multiplatform](https://kotlinlang.org/docs/ksp-multiplatform.html)

## Related decisions

- [ADR 0001: Domain-oriented modular architecture](0001-domain-oriented-modular-architecture.md)
- [ADR 0002: Offline-first local continuity](0002-offline-first-local-continuity.md)
- [ADR 0004: Kotlin Multiplatform platform strategy](0004-kotlin-multiplatform-platform-strategy.md)
