# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.0] - 2026-09-27

### Added
- Native macOS menu bar app (SwiftUI `MenuBarExtra`, window style), read-only by design.
- Two connection kinds, each with its own dashboard: a **cPanel account** (UAPI) or a **WHM server** (WHM API 1).
- Menu bar item with a status dot and one optional stat (disk/accounts, SSL days left/services), adapting to light and dark menu bars.
- cPanel dashboard: quota, domains with SSL status sorted worst-first, and account details.
- WHM dashboard: hosted accounts sorted by disk usage with suspension state, system load, disk usage, and service health sorted so anything down surfaces first.
- A clear, specific error when a certificate doesn't match the hostname you connected with, instead of a generic TLS failure.
- Multiple saved connections (cPanel and WHM together) with a quick switcher, onboarding wizard, and Add/Edit Server screens.
- Test connection verifies the API token against a real read call, so a rejected token is reported.
- API tokens stored in the macOS Keychain, never UserDefaults.
- Remote `http://` connections are refused unless allowed per connection; friendly error and a visible marker when allowed.
- Optional Touch ID to edit or delete a saved connection.
- Settings: menu bar stat, refresh intervals (popover and background), Launch at login, Appearance, and Language.
- Interface localized into English, Simplified Chinese, Japanese, German, Spanish, French and Turkish.
- App icon, generated assets, and a build script (`build-app.sh`) for a universal `.app`.
- Swift Testing suites for the clients, models, connection policy and settings, with fixtures transcribed from real cPanel/WHM API output.
