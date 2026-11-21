#!/usr/bin/env bash
set -Eeuo pipefail

ROOT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
PACKAGE_ID="com.aurex.app"
APK_PATH="$ROOT_DIR/composeApp/build/outputs/apk/debug/composeApp-debug.apk"

if ! command -v adb >/dev/null 2>&1; then
  echo "ERROR: adb was not found. Install Android SDK Platform Tools and add adb to PATH." >&2
  exit 1
fi

if [[ ! -x "$ROOT_DIR/gradlew" ]]; then
  echo "ERROR: Gradle Wrapper is missing or not executable in $ROOT_DIR." >&2
  exit 1
fi

ADB=(adb)
if [[ -n "${ANDROID_SERIAL:-}" ]]; then
  ADB+=(-s "$ANDROID_SERIAL")
fi

if [[ ! -f "$APK_PATH" ]]; then
  echo "Debug APK not found. Building AUREX with the checked-in Gradle Wrapper..."
  "$ROOT_DIR/gradlew" -p "$ROOT_DIR" :composeApp:assembleDebug
fi

if ! "${ADB[@]}" get-state >/dev/null 2>&1; then
  echo "ERROR: No single authorized Android device is available." >&2
  echo "Connect one device, accept the USB debugging prompt, and check 'adb devices'." >&2
  echo "For multiple devices, set ANDROID_SERIAL to the target device serial." >&2
  adb devices || true
  exit 1
fi

echo "Installing AUREX on the connected Android device..."
"${ADB[@]}" install -r "$APK_PATH"

echo "Launching AUREX..."
"${ADB[@]}" shell monkey -p "$PACKAGE_ID" 1

echo
echo "Install and launch commands completed."
echo "Confirm that the AUREX welcome screen is visible on the device."
