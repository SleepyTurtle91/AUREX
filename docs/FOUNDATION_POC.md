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
| Compose Multiplatform | 1.11.1 | Stable release; uses Jetpack Compose 1.11.2, retaining the API 36 / AGP 8.13 toolchain |
| Android Gradle Plugin | 8.13.2 | Conservative supported AGP line |
| Gradle | 8.13 | Compatible baseline |
| Koin | 4.2.2 | Stable KMP DI line |
| Android compile SDK | 36 | Current Android API baseline |
| Android min SDK | 26 | Avoid carrying legacy device support in the initial POC |

Compose Multiplatform 1.12.x maps to Jetpack Compose 1.12.x, which requires compile SDK 37 and AGP 9. This POC deliberately stays on Compose Multiplatform 1.11.1 with AGP 8.13.2 and compile SDK 36, avoiding a wider toolchain migration before the Android foundation has a verified baseline. Kotlin 2.4.21 supports the selected Gradle and AGP range. Versions are centralized in `gradle/libs.versions.toml`; revalidate the matrix before upgrades.

## Local setup

Use JDK 17 or newer and Android SDK Platform 36.

The Gradle Wrapper is committed and pins Gradle 8.13 with a verified distribution checksum. No system Gradle installation is required. This foundation currently declares Android as its only target, so run the Android debug unit-test variant; an aggregate `allTests` task is not generated for this module configuration.

```bash
./gradlew --version
./gradlew :composeApp:tasks
./gradlew :composeApp:testDebugUnitTest
./gradlew :composeApp:assembleDebug
```

Install the debug APK on a connected Android device:

```bash
adb install -r composeApp/build/outputs/apk/debug/composeApp-debug.apk
```

The Android application ID is `com.aurex.app`.

## Continuous integration

GitHub Actions is configured in `.github/workflows/android-ci.yml` to run common/platform tests and assemble a debug APK for pull requests and pushes. The first green run is still required before CI is considered verified. See [CI documentation](CI.md).

## Acceptance checklist

- [x] Gradle Wrapper is committed with verified JAR and distribution checksums.
- [ ] Gradle project imports without sync errors.
- [ ] Common test passes.
- [ ] Android debug APK builds.
- [ ] App launches on a physical Android device.
- [ ] Shared Compose screen renders.
- [ ] Koin resolves `FoundationStatus` from common code.
- [ ] Room KMP database proof-of-concept passes separately.
- [x] GitHub Actions CI completes successfully on a pull request (verified on 2026-11-21; see workflow run 44867686852).

Do not mark an item complete without a recorded build or device-test result.
