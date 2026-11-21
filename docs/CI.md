# AUREX Continuous Integration

## Provider

GitHub Actions is the project's initial CI provider. Use GitHub-hosted Linux runners; do not introduce self-hosted infrastructure for the foundation phase.

## Initial workflow

Workflow: `.github/workflows/android-ci.yml`

Triggers:
- Pull requests targeting `main`.
- Pushes to `main` (feature branches are validated through their pull requests, avoiding duplicate runs).
- Manual dispatch.

Checks:
1. Set up JDK 17 and Android SDK Platform 36.
2. Verify the checked-in Gradle Wrapper JAR against Gradle's published SHA-256 checksum.
3. Use the pinned Gradle 8.13 distribution through `./gradlew`; its distribution SHA-256 is pinned in `gradle/wrapper/gradle-wrapper.properties`.
4. Run Android host-side unit tests, including the `commonTest` source set, with `./gradlew :composeApp:testDebugUnitTest`.
5. Validate the Android device smoke-test helper with `bash -n scripts/android-smoke-test.sh`.
6. Run the Android Compose launch test on a GitHub-hosted API 36 emulator with `./gradlew :composeApp:connectedDebugAndroidTest`.
7. Build the Android debug APK with `./gradlew :composeApp:assembleDebug`.
8. Upload the debug APK as a seven-day workflow artifact.

The workflow uses GitHub-hosted runners and does not require deployment credentials, signing keys or paid external services. The Gradle setup action caches wrapper distributions and dependencies.

## Cost and security rules

- Prefer GitHub-hosted runners while the project remains small.
- Keep workflow permissions read-only unless a specific job needs more.
- Never expose signing credentials or production secrets to pull-request workflows.
- Cache Gradle dependencies through the official setup action.
- Cancel superseded runs on the same branch.
- Keep artifact retention short for disposable debug builds.
- Do not publish releases or deploy infrastructure from pull-request workflows.
- Verify the Wrapper JAR checksum whenever the Wrapper binary changes.

## Current limitations

- First successful Android CI validation: commit `c838407734dcdcded0f04a2a2424698bd361d984` (2026-11-21).
- Latest CI validation: commit `c40b4574b41d6b361535bdd67603bb74114eea9f`, workflow run [44869019001](https://github.com/SleepyTurtle91/AUREX/actions/runs/44869019001) (2026-11-21). Wrapper JAR checksum verification, smoke-test script syntax check, Android unit tests, debug APK assembly and artifact upload all passed.
- The emulator UI smoke test verifies Activity startup, process-level Koin initialization and the visible Compose welcome screen. Physical-device validation remains a separate local acceptance step because a hosted emulator cannot prove behavior on the owner's actual Android hardware.

## Future improvements

Only add these when they provide real value:
- Static analysis and formatting checks.
- Dependency vulnerability and license checks.
- Release signing and publishing after a secure release process is defined.
