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

## Physical-device smoke test

1. Enable USB debugging on an Android phone or tablet and connect it to the development computer.
2. Accept the USB debugging authorization prompt on the device.
3. Run the repository's one-command install and launch helper:

```bash
./scripts/android-smoke-test.sh
```

The script always rebuilds the debug APK from the current checkout, installs it with ADB, and sends the launch intent so a stale APK cannot be installed by accident. When multiple Android devices are connected, set `ANDROID_SERIAL` to the intended device serial before running the script. Confirm that the welcome screen displays AUREX, `Business. Connected.`, and the foundation status message.

## Continuous integration

GitHub Actions has successfully verified the checked-in Gradle Wrapper, smoke-test script syntax, Android unit-test variant (including `commonTest`), debug APK assembly and artifact upload on commit `bbcf097ff1aaeca0300bf2fe4d90b0ef20b930b9` (run [44868709823](https://github.com/SleepyTurtle91/AUREX/actions/runs/44868709823)). See [CI documentation](CI.md).

## Acceptance checklist

- [x] Gradle Wrapper is committed with verified JAR and distribution checksums.
- [ ] Gradle project imports without sync errors.
- [x] Common test passes in the Android debug unit-test variant.
- [x] Android debug APK builds in CI.
- [ ] App launches on a physical Android device using `scripts/android-smoke-test.sh`.
- [ ] Shared Compose screen renders.
- [ ] Koin resolves `FoundationStatus` from common code.
- [ ] Room KMP database proof-of-concept passes separately.
- [x] GitHub Actions CI completes successfully on a pull request (verified on 2026-11-21; see latest wrapper-based workflow run 44868709823).

Do not mark an item complete without a recorded build or device-test result.
