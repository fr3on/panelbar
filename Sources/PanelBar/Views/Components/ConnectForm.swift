import SwiftUI
import PanelBarCore

/// The form for adding a connection: used both by onboarding's Connect step and the popover's
/// Add Server screen, so the two never drift apart.
struct ConnectForm: View {
    @EnvironmentObject var appState: AppState

    private var hostPlaceholder: String { appState.newKind == .cpanel ? "https://host.example.com:2083" : "https://srv1.host.example.com:2087" }
    private var userLabel: String { appState.newKind.usernameLabel }
    private var userPlaceholder: String { appState.newKind == .cpanel ? "agency" : "root" }
    private var tokenHelp: String {
        appState.newKind == .cpanel
            ? appState.strings.tokenHelpCPanel
            : appState.strings.tokenHelpWHM
    }
    private var insecureWarning: Bool {
        PanelBarCore.ConnectionPolicy.requiresInsecureOptIn(appState.newURL) && !appState.newToken.isEmpty
    }

    var body: some View {
        VStack(spacing: 12) {
            kindCard
            connectionCard
            authCard
            if insecureWarning {
                insecureCard
            }
            testCard
        }
        .onChange(of: appState.newURL) { _, _ in appState.resetTestResult() }
        .onChange(of: appState.newToken) { _, _ in appState.resetTestResult() }
        .onChange(of: appState.newKind) { _, _ in appState.resetTestResult() }
    }

    // MARK: - Cards

    private func sectionLabel(_ icon: String, _ title: String) -> some View {
        HStack(spacing: 5) {
            Image(systemName: icon).font(.system(size: 10, weight: .semibold)).foregroundColor(Theme.Colors.text3)
            Text(title.uppercased()).font(.system(size: 10, weight: .bold)).tracking(0.4).foregroundColor(Theme.Colors.text3)
        }
        .padding(.horizontal, 4)
    }

    private var kindCard: some View {
        VStack(alignment: .leading, spacing: 6) {
            sectionLabel("square.grid.2x2", appState.strings.serverType)

            HStack(spacing: 8) {
                kindOption(.cpanel, appState.strings.cpanelAccount, appState.strings.singleSiteAgency)
                kindOption(.whm, appState.strings.whmServer, appState.strings.fullServerManager)
            }
        }
    }

    private func kindOption(_ kind: ConnectionKind, _ title: String, _ subtitle: String) -> some View {
        let isSelected = appState.newKind == kind
        let accent = Theme.Colors.accent(kind)

        return Button {
            appState.newKind = kind
            if appState.newURL.isEmpty || appState.newURL == "https://host.example.com:2083" || appState.newURL == "https://host.example.com:2087" {
                appState.newURL = kind == .cpanel ? "https://host.example.com:2083" : "https://host.example.com:2087"
            }
        } label: {
            HStack(spacing: 8) {
                Image(systemName: isSelected ? "largecircle.fill.circle" : "circle")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(isSelected ? accent : Theme.Colors.text3)

                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(Theme.Colors.text)
                    Text(subtitle)
                        .font(.system(size: 10))
                        .foregroundColor(Theme.Colors.text3)
                }
                Spacer(minLength: 0)
            }
            .padding(10)
            .background(isSelected ? accent.opacity(0.08) : Theme.Colors.card, in: RoundedRectangle(cornerRadius: Theme.Layout.cardRadius))
            .overlay(
                RoundedRectangle(cornerRadius: Theme.Layout.cardRadius)
                    .stroke(isSelected ? accent.opacity(0.6) : Theme.Colors.border, lineWidth: isSelected ? 1.5 : 1)
            )
            .shadow(color: Theme.Colors.cardShadow, radius: 8, x: 0, y: 3)
        }
        .buttonStyle(.plain).focusEffectDisabled()
    }

    private var connectionCard: some View {
        VStack(alignment: .leading, spacing: 6) {
            sectionLabel("link", appState.strings.connectionDetails)

            VStack(alignment: .leading, spacing: 10) {
                FormField(
                    label: appState.strings.displayName,
                    placeholder: appState.newKind == .cpanel ? "Client Account" : "WHM Production",
                    text: $appState.newName
                )

                FormField(
                    label: appState.strings.hostURL,
                    placeholder: hostPlaceholder,
                    text: $appState.newURL,
                    mono: true
                )
            }
            .padding(12)
            .glassCard()
        }
    }

    private var authCard: some View {
        VStack(alignment: .leading, spacing: 6) {
            sectionLabel("key.fill", appState.strings.authentication)

            VStack(alignment: .leading, spacing: 10) {
                FormField(
                    label: userLabel,
                    placeholder: userPlaceholder,
                    text: $appState.newUsername
                )

                FormField(
                    label: appState.strings.apiToken,
                    placeholder: appState.strings.pasteNewToken,
                    text: $appState.newToken,
                    mono: true,
                    secure: true
                )

                HStack(spacing: 5) {
                    Image(systemName: "key.horizontal")
                        .font(.system(size: 9))
                        .foregroundColor(Theme.Colors.text3)
                    Text(tokenHelp)
                        .font(.system(size: 10.5))
                        .foregroundColor(Theme.Colors.text3)
                }
            }
            .padding(12)
            .glassCard()
        }
    }

    private var insecureCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 6) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.system(size: 12))
                    .foregroundColor(Theme.Colors.amber)
                Text(appState.strings.plainHTTPWarning)
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(Theme.Colors.text)
            }
            Text(appState.strings.plainHTTPDescription)
                .font(.system(size: 11))
                .foregroundColor(Theme.Colors.text2)

            HStack(spacing: 10) {
                SwitchControl(isOn: $appState.newAllowInsecure, tint: Theme.Colors.amber)
                Text(appState.strings.allowUnencryptedHTTP)
                    .font(.system(size: 11.5, weight: .medium))
                    .foregroundColor(Theme.Colors.text)
                Spacer()
            }
        }
        .padding(12)
        .background(Theme.Colors.amber.opacity(0.10), in: RoundedRectangle(cornerRadius: Theme.Layout.cardRadius))
        .overlay(RoundedRectangle(cornerRadius: Theme.Layout.cardRadius).stroke(Theme.Colors.amber.opacity(0.3), lineWidth: 1))
        .shadow(color: Theme.Colors.cardShadow, radius: 8, x: 0, y: 3)
    }

    private var testCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 10) {
                Button {
                    Task { await appState.testConnection() }
                } label: {
                    HStack(spacing: 6) {
                        if appState.isTestingConnection {
                            ProgressView().scaleEffect(0.6).frame(width: 12, height: 12)
                            Text(appState.strings.testing).font(.system(size: 12, weight: .medium))
                        } else {
                            Image(systemName: "waveform.path.ecg").font(.system(size: 11, weight: .semibold))
                            Text(appState.strings.testConnection).font(.system(size: 12, weight: .medium))
                        }
                    }
                    .foregroundColor(Theme.Colors.text)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 7)
                    .background(Theme.Colors.card, in: RoundedRectangle(cornerRadius: Theme.Layout.pillRadius))
                    .overlay(RoundedRectangle(cornerRadius: Theme.Layout.pillRadius).stroke(Theme.Colors.border, lineWidth: 1))
                }
                .buttonStyle(.plain).focusEffectDisabled()
                .disabled(appState.isTestingConnection || appState.newURL.isEmpty)

                Spacer()
            }

            if let result = appState.testResult {
                testFeedbackBanner(result: result, isSuccess: appState.testSuccess ?? false, needsKey: appState.testNeedsKey)
            }
        }
        .padding(12)
        .glassCard()
    }

    private func testFeedbackBanner(result: String, isSuccess: Bool, needsKey: Bool) -> some View {
        let bannerBg: Color = isSuccess ? Theme.Colors.green.opacity(0.08) : (needsKey ? Theme.Colors.amber.opacity(0.08) : Theme.Colors.red.opacity(0.08))
        let bannerBorder: Color = isSuccess ? Theme.Colors.green.opacity(0.25) : (needsKey ? Theme.Colors.amber.opacity(0.25) : Theme.Colors.red.opacity(0.25))
        let iconColor: Color = isSuccess ? Theme.Colors.green : (needsKey ? Theme.Colors.amber : Theme.Colors.red)
        let iconName: String = isSuccess ? "checkmark.circle.fill" : (needsKey ? "key.horizontal.fill" : "exclamationmark.triangle.fill")

        return HStack(alignment: .top, spacing: 8) {
            Image(systemName: iconName)
                .font(.system(size: 12))
                .foregroundColor(iconColor)
                .padding(.top, 1)

            Text(result)
                .font(.system(size: 11))
                .foregroundColor(Theme.Colors.text)
                .fixedSize(horizontal: false, vertical: true)
                .textSelection(.enabled)

            Spacer(minLength: 0)
        }
        .padding(8)
        .background(bannerBg, in: RoundedRectangle(cornerRadius: Theme.Layout.pillRadius))
        .overlay(RoundedRectangle(cornerRadius: Theme.Layout.pillRadius).stroke(bannerBorder, lineWidth: 1))
    }
}
