# Contributing to PanelBar

Thank you for your interest in contributing to PanelBar!

## Principles

1. **Zero External Dependencies**: PanelBar relies exclusively on Apple's native frameworks and Swift standard library.
2. **Separation of Concerns**: `PanelBarCore` must remain free of UI/AppKit imports so it remains fully unit-testable.
3. **Safety First**: PanelBar is monitor-only. Destructive operations (suspending accounts, changing DNS, issuing certificates) and server management (start, stop, restart services) are not supported.
4. **Verify field names against real output**: cPanel and WHM's docs are inconsistent and sometimes wrong. Don't guess a JSON field name or model it from documentation alone — check it against real `whmapi1`/UAPI output first, and add a fixture transcribed from that output.
5. **Insecure by opt-in only**: Remote `http://` URLs are refused unless a connection explicitly opts in, and credentials never leave the user's host.

## Development Setup

```bash
# Clone the repository
git clone https://github.com/fr3on/panelbar.git
cd panelbar

# Build and test
swift build
swift test

# Build application bundle
./scripts/build-app.sh
```

## Pull Request Guidelines

- Ensure `swift test` passes without any warnings.
- Keep commits small, focused, and descriptive.
- Do not include automated AI co-authorship attribution in commits or PR messages.
- Scrub any real hostnames, account names or tokens from fixtures and code before committing — see [SECURITY.md](SECURITY.md).
