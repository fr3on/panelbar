# Security Policy

## Supported Versions

| Version | Supported          |
| ------- | ------------------ |
| 0.1.x   | Yes |

## Security Features

- **No Remote Telemetry**: PanelBar does not collect, track, or phone home any telemetry, analytics, or user identifiers.
- **Encrypted by default**: cPanel and WHM serve their APIs over TLS by default (ports 2083/2087). A remote `http://` connection (anything that is not loopback, LAN and VPN addresses included) is refused before any request is sent, unless that connection's profile has **Allow insecure HTTP** switched on. The switch is per connection and off by default. The API token and data travel unencrypted on such a connection, so use HTTPS or an SSH tunnel (`ssh -N -L 2087:localhost:2087 user@host`) where you can.
- **Why App Transport Security is off**: macOS blocks remote `http://` for the whole app unless `NSAllowsArbitraryLoads` is set, and it cannot be relaxed per host at run time. The app sets it so the per-connection opt-in can work, and enforces the rule itself in `PanelBarCore.ConnectionPolicy` (tested), so the effective behavior stays "https or opted-in".
- **A certificate that doesn't match the hostname is reported, not silently downgraded**: PanelBar maps TLS trust failures to a specific, actionable error instead of a generic network failure, and never falls back to an insecure connection on its own.
- **Keychain Storage**: API tokens are securely persisted in the Apple Keychain using `kSecClassGenericPassword` with `kSecAttrAccessibleAfterFirstUnlock`. Tokens are sent only in the `Authorization` header of requests to the account or server they belong to.
- **Read-only**: PanelBar sends only `GET`-equivalent UAPI/WHM API 1 calls. It never starts, stops or signals a service, and never changes data in cPanel or WHM.
- **Optional Touch ID**: editing or deleting a saved connection — the two actions that reveal or destroy a stored token — can be gated behind Touch ID.

## Reporting a Vulnerability

If you discover a security vulnerability in PanelBar, please report it privately via GitHub Security Advisories or by contacting the project maintainers directly.
