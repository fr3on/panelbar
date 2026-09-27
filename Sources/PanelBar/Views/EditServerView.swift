import SwiftUI
import PanelBarCore

struct EditServerView: View {
    @EnvironmentObject var appState: AppState
    let profile: ConnectionProfile

    private var hostPlaceholder: String {
        appState.editKind == .cpanel ? "https://host.example.com:2083" : "https://srv1.host.example.com:2087"
    }
    private var userLabel: String {
        appState.editKind == .cpanel ? "cPanel username" : "WHM username (root or reseller)"
    }
    private var userPlaceholder: String {
        appState.editKind == .cpanel ? "agency" : "root"
    }
    private var tokenHelp: String {
        appState.editKind == .cpanel
            ? appState.strings.tokenHelpCPanel
            : appState.strings.tokenHelpWHM
    }
    private var insecureWarning: Bool {
        PanelBarCore.ConnectionPolicy.requiresInsecureOptIn(appState.editURL) && !appState.editToken.isEmpty
    }
    private var blocked: Bool {
        appState.editURL.isEmpty || (PanelBarCore.ConnectionPolicy.requiresInsecureOptIn(appState.editURL) && !appState.editAllowInsecure)
    }

    var body: some View {
        VStack(spacing: 0) {
            header
            ScrollingContent {
                VStack(spacing: 16) {
                    kindSegmentedControl
                    connectionCard
                    authCard
                    if insecureWarning {
                        insecureCard
                    }
                    testCard
                    dangerZoneCard
                }
                .padding(.horizontal, Theme.Layout.gutter)
                .padding(.top, 14)
                .padding(.bottom, 20)
            }
            footer
        }
        .frame(width: Theme.Layout.popoverWidth, height: Theme.Layout.popoverHeight)
        .background(Theme.Colors.bg)
    }

    // MARK: - Header

    private var header: some View {
        TopStrip(
            title: appState.strings.editServer,
            subtitle: profile.name,
            kind: appState.editKind,
            back: { appState.cancelEditingProfile() },
            backLabel: appState.strings.back
        )
    }

    // MARK: - Kind Segmented Switcher

    private var kindSegmentedControl: some View {
        HStack(spacing: 8) {
            kindPill(kind: .cpanel, title: appState.strings.cpanelAccount, icon: "person.crop.circle")
            kindPill(kind: .whm, title: appState.strings.whmServer, icon: "server.rack")
        }
    }

    private func kindPill(kind: ConnectionKind, title: String, icon: String) -> some View {
        let isSelected = appState.editKind == kind
        return Button {
            appState.editKind = kind
        } label: {
            HStack(spacing: 7) {
                Image(systemName: icon)
                    .font(.system(size: 11, weight: .semibold))
                Text(title)
                    .font(.system(size: 12, weight: .medium))
            }
            .foregroundColor(isSelected ? .white : Theme.Colors.text2)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
            .background(
                isSelected ? Theme.Colors.accent(kind) : Theme.Colors.card,
                in: RoundedRectangle(cornerRadius: 7)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 7)
                    .stroke(isSelected ? Color.clear : Theme.Colors.border, lineWidth: 1)
            )
        }
        .buttonStyle(.plain).focusEffectDisabled()
    }

    // MARK: - Server Connection Card

    private var connectionCard: some View {
        VStack(alignment: .leading, spacing: 5) {
            SectionLabel(text: appState.strings.serverConnection)
            VStack(spacing: 0) {
                formRow(icon: "tag", label: appState.strings.serverName, placeholder: appState.editKind == .cpanel ? "e.g. Client Site" : "e.g. Primary WHM", text: $appState.editName, mono: false)
                Rectangle().fill(Theme.Colors.hairline).frame(height: 1)
                formRow(icon: "network", label: appState.strings.hostURL, placeholder: hostPlaceholder, text: $appState.editURL, mono: true)
                Rectangle().fill(Theme.Colors.hairline).frame(height: 1)
                formRow(icon: "person", label: userLabel, placeholder: userPlaceholder, text: $appState.editUsername, mono: false)
            }
            .background(Theme.Colors.card, in: RoundedRectangle(cornerRadius: 8))
            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Theme.Colors.border))
        }
    }

    // MARK: - Authentication Card

    private var authCard: some View {
        VStack(alignment: .leading, spacing: 6) {
            SectionLabel(text: appState.strings.authentication)
            VStack(spacing: 0) {
                HStack(alignment: .center, spacing: 10) {
                    Image(systemName: "key")
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(Theme.Colors.text3)
                        .frame(width: 16)
                    VStack(alignment: .leading, spacing: 2) {
                        Text(appState.strings.apiToken)
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(Theme.Colors.text3)
                        SecureField("Keep existing or paste new token", text: $appState.editToken)
                            .textFieldStyle(.plain)
                            .font(.system(size: 12, design: .monospaced))
                    }
                }
                .padding(.horizontal, 12).padding(.vertical, 8)
            }
            .background(Theme.Colors.card, in: RoundedRectangle(cornerRadius: 8))
            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Theme.Colors.border))

            HStack(spacing: 5) {
                Image(systemName: "info.circle")
                    .font(.system(size: 10))
                Text(tokenHelp)
                    .font(.system(size: 10.5))
            }
            .foregroundColor(Theme.Colors.text3)
            .padding(.horizontal, 4)
        }
    }

    private func formRow(icon: String, label: String, placeholder: String, text: Binding<String>, mono: Bool) -> some View {
        HStack(alignment: .center, spacing: 10) {
            Image(systemName: icon)
                .font(.system(size: 11, weight: .medium))
                .foregroundColor(Theme.Colors.text3)
                .frame(width: 16)
            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(Theme.Colors.text3)
                TextField(placeholder, text: text)
                    .textFieldStyle(.plain)
                    .font(.system(size: 12, design: mono ? .monospaced : .default))
            }
        }
        .padding(.horizontal, 12).padding(.vertical, 8)
    }

    // MARK: - Insecure HTTP Card

    private var insecureCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 6) {
                Image(systemName: "exclamationmark.shield.fill")
                    .font(.system(size: 11))
                    .foregroundColor(Theme.Colors.amber)
                Text(appState.strings.plainHTTPWarning)
                    .font(.system(size: 11.5, weight: .semibold))
                    .foregroundColor(Theme.Colors.text)
            }
            Text(appState.strings.plainHTTPDescription)
                .font(.system(size: 10.5))
                .foregroundColor(Theme.Colors.text2)
            HStack {
                SwitchControl(isOn: $appState.editAllowInsecure, tint: Theme.Colors.amber)
                Text(appState.strings.allowUnencryptedHTTP)
                    .font(.system(size: 11.5, weight: .medium))
                    .foregroundColor(Theme.Colors.text)
                Spacer()
            }
        }
        .padding(11)
        .background(Theme.Colors.amber.opacity(0.06), in: RoundedRectangle(cornerRadius: 8))
        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Theme.Colors.amber.opacity(0.25)))
    }

    // MARK: - Test Connection Card

    private var testCard: some View {
        VStack(alignment: .leading, spacing: 6) {
            SectionLabel(text: appState.strings.verifyConnection)
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 10) {
                    Button {
                        Task { await appState.testEditConnection() }
                    } label: {
                        HStack(spacing: 6) {
                            if appState.isTestingEditConnection {
                                ProgressView().scaleEffect(0.5).frame(width: 10, height: 10)
                                Text(appState.strings.connecting).font(.system(size: 11.5, weight: .medium))
                            } else {
                                Image(systemName: "bolt.horizontal.fill")
                                    .font(.system(size: 10, weight: .semibold))
                                Text(appState.strings.testConnection).font(.system(size: 11.5, weight: .medium))
                            }
                        }
                        .foregroundColor(Theme.Colors.text)
                        .padding(.horizontal, 12).padding(.vertical, 6)
                        .background(Theme.Colors.bg, in: RoundedRectangle(cornerRadius: 5))
                        .overlay(RoundedRectangle(cornerRadius: 5).stroke(Theme.Colors.border))
                    }
                    .buttonStyle(.plain).focusEffectDisabled()
                    .disabled(appState.isTestingEditConnection || appState.editURL.isEmpty)

                    if appState.isTestingEditConnection {
                        Text(appState.strings.verifyingCredentials)
                            .font(.system(size: 11))
                            .foregroundColor(Theme.Colors.text3)
                    }
                    Spacer()
                }

                if let result = appState.editTestResult {
                    let success = appState.editTestSuccess == true
                    HStack(alignment: .top, spacing: 7) {
                        Image(systemName: success ? "checkmark.circle.fill" : "exclamationmark.circle.fill")
                            .font(.system(size: 11))
                            .foregroundColor(success ? Theme.Colors.green : (appState.editTestNeedsKey ? Theme.Colors.amber : Theme.Colors.red))
                            .padding(.top, 1)
                        Text(result)
                            .font(.system(size: 11))
                            .foregroundColor(success ? Theme.Colors.text : Theme.Colors.red)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(8)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(
                        (success ? Theme.Colors.green : Theme.Colors.red).opacity(0.08),
                        in: RoundedRectangle(cornerRadius: 6)
                    )
                }
            }
            .padding(11)
            .background(Theme.Colors.card, in: RoundedRectangle(cornerRadius: 8))
            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Theme.Colors.border))
        }
    }

    // MARK: - Danger Zone Card

    private var dangerZoneCard: some View {
        VStack(alignment: .leading, spacing: 6) {
            SectionLabel(text: appState.strings.dangerZone)
            VStack(alignment: .leading, spacing: 8) {
                HStack(alignment: .center) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(appState.strings.deleteThisConnection)
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(Theme.Colors.red)
                        Text(appState.strings.deleteConnectionDescription)
                            .font(.system(size: 10.5))
                            .foregroundColor(Theme.Colors.text3)
                    }
                    Spacer()
                    Button {
                        appState.isConfirmingDeleteProfile.toggle()
                    } label: {
                        HStack(spacing: 4) {
                            Image(systemName: "trash")
                                .font(.system(size: 10, weight: .semibold))
                            Text(appState.strings.delete)
                                .font(.system(size: 11.5, weight: .medium))
                        }
                        .foregroundColor(Theme.Colors.red)
                        .padding(.horizontal, 10).padding(.vertical, 5)
                        .background(Theme.Colors.red.opacity(0.09), in: RoundedRectangle(cornerRadius: 5))
                    }
                    .buttonStyle(.plain).focusEffectDisabled()
                }

                if appState.isConfirmingDeleteProfile {
                    VStack(alignment: .leading, spacing: 8) {
                        Rectangle().fill(Theme.Colors.red.opacity(0.2)).frame(height: 1)
                        HStack {
                            Text(appState.strings.areYouSureCannotBeUndone)
                                .font(.system(size: 11, weight: .medium))
                                .foregroundColor(Theme.Colors.red)
                            Spacer()
                            Button {
                                appState.isConfirmingDeleteProfile = false
                            } label: {
                                Text(appState.strings.cancel)
                                    .font(.system(size: 11))
                                    .foregroundColor(Theme.Colors.text3)
                                    .padding(.horizontal, 8).padding(.vertical, 4)
                            }
                            .buttonStyle(.plain).focusEffectDisabled()

                            Button {
                                appState.isConfirmingDeleteProfile = false
                                appState.deleteProfile(profile.id)
                            } label: {
                                Text(appState.strings.confirmDelete)
                                    .font(.system(size: 11, weight: .semibold))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 10).padding(.vertical, 4)
                                    .background(Theme.Colors.red, in: RoundedRectangle(cornerRadius: 4))
                            }
                            .buttonStyle(.plain).focusEffectDisabled()
                        }
                    }
                    .padding(.top, 4)
                }
            }
            .padding(12)
            .background(Theme.Colors.card, in: RoundedRectangle(cornerRadius: 8))
            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Theme.Colors.red.opacity(0.22)))
        }
    }

    // MARK: - Footer Toolbar

    private var footer: some View {
        HStack {
            Button {
                appState.cancelEditingProfile()
            } label: {
                Text(appState.strings.cancel)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(Theme.Colors.text3)
                    .padding(.horizontal, 14).padding(.vertical, 7)
                    .background(Theme.Colors.bg, in: RoundedRectangle(cornerRadius: 5))
                    .overlay(RoundedRectangle(cornerRadius: 5).stroke(Theme.Colors.border))
            }
            .buttonStyle(.plain).focusEffectDisabled()

            Spacer()

            Button {
                appState.saveEditedProfile()
            } label: {
                HStack(spacing: 5) {
                    Image(systemName: "checkmark")
                        .font(.system(size: 10, weight: .bold))
                    Text(appState.strings.saveChanges)
                        .font(.system(size: 12, weight: .semibold))
                }
                .foregroundColor(.white)
                .padding(.horizontal, 16).padding(.vertical, 7)
                .background(
                    blocked ? Theme.Colors.gray : Theme.Colors.accent(appState.editKind),
                    in: RoundedRectangle(cornerRadius: 5)
                )
            }
            .buttonStyle(.plain).focusEffectDisabled()
            .disabled(blocked)
        }
        .padding(.horizontal, Theme.Layout.gutter)
        .padding(.vertical, 10)
        .overlay(alignment: .top) { Rectangle().fill(Theme.Colors.hairline).frame(height: 1) }
        .background(Theme.Colors.card)
    }
}
