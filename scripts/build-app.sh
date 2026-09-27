#!/bin/zsh
# Builds a universal (arm64 + x86_64) PanelBar and wraps it in a menu-bar-only app bundle at build/PanelBar.app.
#
#   SIGN_IDENTITY   codesign identity; defaults to "-" (ad-hoc, fine for local use, not for distribution)
#   BUILD_NUMBER    CFBundleVersion; defaults to the git commit count, or 1 outside a repo
set -euo pipefail
cd "$(dirname "$0")/.."

VERSION="$(tr -d '[:space:]' < VERSION)"
BUILD_NUMBER="${BUILD_NUMBER:-$(git rev-list --count HEAD 2>/dev/null || echo 1)}"
SIGN_IDENTITY="${SIGN_IDENTITY:--}"

swift build -c release --arch arm64 --arch x86_64
BIN="$(swift build -c release --arch arm64 --arch x86_64 --show-bin-path)/PanelBar"
APP="build/PanelBar.app"

rm -rf "$APP"
mkdir -p "$APP/Contents/MacOS" "$APP/Contents/Resources"
cp "$BIN" "$APP/Contents/MacOS/PanelBar"

if [[ -f "assets/AppIcon.icns" ]]; then
  cp "assets/AppIcon.icns" "$APP/Contents/Resources/AppIcon.icns"
fi

cat > "$APP/Contents/Info.plist" <<PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0"><dict>
  <key>CFBundleIdentifier</key><string>com.0x200.panelbar</string>
  <key>CFBundleName</key><string>PanelBar</string>
  <key>CFBundleDisplayName</key><string>PanelBar</string>
  <key>CFBundleExecutable</key><string>PanelBar</string>
  <key>CFBundleIconFile</key><string>AppIcon</string>
  <key>CFBundlePackageType</key><string>APPL</string>
  <key>CFBundleShortVersionString</key><string>${VERSION}</string>
  <key>CFBundleVersion</key><string>${BUILD_NUMBER}</string>
  <key>LSMinimumSystemVersion</key><string>14.0</string>
  <key>LSApplicationCategoryType</key><string>public.app-category.developer-tools</string>
  <key>NSPrincipalClass</key><string>NSApplication</string>
  <key>LSUIElement</key><true/>
</dict></plist>
PLIST
plutil -lint "$APP/Contents/Info.plist" >/dev/null

codesign --force --options runtime --timestamp=none --sign "$SIGN_IDENTITY" "$APP"
codesign --verify --strict "$APP"
echo "Built $APP ($VERSION, build $BUILD_NUMBER) signed as: $SIGN_IDENTITY"
lipo -archs "$APP/Contents/MacOS/PanelBar" | sed 's/^/Architectures: /'
