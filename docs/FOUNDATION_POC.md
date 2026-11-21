# AUREX Foundation Proof of Concept

## Scope of this first slice

This branch establishes the smallest useful KMP application foundation:

- Kotlin Multiplatform with Android as the first target.
- Compose Multiplatform UI in `commonMain`.
- Koin dependency graph assembled at the Android application boundary.
- A platform-neutral application use case.
- A common unit test.
- Centralized dependency and plugin versions.

## Deliberately not included yet

- Room KMP: validate its KSP/compiler and Android database-builder setup in a separate, isolated step before making it a foundation dependency.
- Financial decimal implementation: requires its own compatibility and correctness evaluation.
- Cloud, remote API, authentication and synchronization.
- Desktop and iOS targets.
- Hardware integrations.

These are intentionally deferred to keep the first compile surface small and to avoid adding dependencies before their compatibility is demonstrated.

## Initial toolchain baseline

| Component | Version | Reason |
|---|---:|---|
| Kotlin / KMP | 2.4.21 | Stable Kotlin release |
| Compose Multiplatform | 1.12.2 | Stable release |
| Android Gradle Plugin | 8.13.2 | Conservative supported AGP line |
| Gradle | 8.13 | Compatible baseline |
| Koin | 4.2.2 | Stable KMP DI line |
| Android compile SDK | 36 | Current Android API baseline |
| Android min SDK | 26 | Avoid carrying legacy device support in the initial POC |

Versions are centralized in `gradle/libs.versions.toml`. Revalidate the matrix before upgrades.

## Local setup

Use JDK 17 or newer and Android SDK Platform 36.

If Gradle is installed locally, generate the wrapper from the repository root:

```bash
gradle wrapper --gradle-version 8.13 --distribution-type bin
```

Then verify:

```bash
./gradlew :composeApp:tasks
./gradlew :composeApp:allTests
./gradlew :composeApp:assembleDebug
```

Install the debug APK on a connected Android device:

```bash
adb install -r composeApp/build/outputs/apk/debug/composeApp-debug.apk
```

The Android application ID is `com.aurex.app`.

## Acceptance checklist

- [ ] Gradle project imports without sync errors.
- [ ] Common test passes.
- [ ] Android debug APK builds.
- [ ] App launches on a physical Android device.
- [ ] Shared Compose screen renders.
- [ ] Koin resolves `FoundationStatus` from common code.
- [ ] Room KMP database proof-of-concept passes separately.
- [ ] CI reproduces the build and common tests.

Do not mark an item complete without a recorded build or device-test result.
