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
2. Install Gradle 8.13 through the Gradle setup action.
3. Run `gradle :composeApp:allTests`.
4. Build the Android debug APK with `gradle :composeApp:assembleDebug`.
5. Upload the debug APK as a seven-day workflow artifact.

The workflow uses GitHub-hosted runners and does not require deployment credentials, signing keys or paid external services.

## Cost and security rules

- Prefer GitHub-hosted runners while the project remains small.
- Keep workflow permissions read-only unless a specific job needs more.
- Never expose signing credentials or production secrets to pull-request workflows.
- Cache Gradle dependencies through the official setup action.
- Cancel superseded runs on the same branch.
- Keep artifact retention short for disposable debug builds.
- Do not publish releases or deploy infrastructure from pull-request workflows.

## Current limitations

- The repository does not yet contain a Gradle wrapper; CI installs the pinned Gradle version directly.
- A successful CI run has not yet been observed. Treat the workflow as configured, not verified, until GitHub Actions reports a green run.
- Physical-device validation remains a local acceptance step. A hosted Linux runner cannot prove the app behaves correctly on the owner's Android hardware.

## Future improvements

Only add these when they provide real value:
- Gradle wrapper and wrapper validation.
- Static analysis and formatting checks.
- Android instrumented tests on an emulator.
- Dependency vulnerability and license checks.
- Release signing and publishing after a secure release process is defined.
