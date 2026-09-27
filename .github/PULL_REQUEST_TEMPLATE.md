## What and why

<!-- What does this change, and what problem does it solve? Link the issue if there is one. -->

## Checklist

- [ ] `swift build` and `swift test` pass
- [ ] Core changes have tests (new cPanel/WHM response shapes include a fixture transcribed from real output)
- [ ] Read-only: only `GET`-equivalent UAPI/WHM API 1 calls, and nothing that changes an account or server
- [ ] Remote `http://` stays gated by `ConnectionPolicy`
- [ ] No new dependencies, and no network calls except to accounts and servers the user added
- [ ] No real hostnames, account names or tokens in fixtures, code or screenshots
- [ ] UI changes include a screenshot

## Screenshots

<!-- Before / after, if the UI changed. -->
