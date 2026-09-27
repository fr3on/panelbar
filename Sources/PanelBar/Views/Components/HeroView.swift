import SwiftUI
import PanelBarCore

/// Hero stat number, state line and primary action pill in the QdrantBar style.
struct HeroView: View {
    @EnvironmentObject var appState: AppState
    let profile: ConnectionProfile

    private var stateText: String {
        switch appState.connection {
        case .online: return appState.strings.statusOnline
        case .unauthorized: return appState.strings.statusNeedsToken
        case .offline: return appState.strings.statusOffline
        }
    }

    private var stateColor: Color {
        switch appState.connection {
        case .online: return Theme.Colors.green
        case .unauthorized: return Theme.Colors.amber
        case .offline: return Theme.Colors.gray
        }
    }

    private var heroNumber: String? {
        guard appState.connection == .online else { return nil }
        switch profile.kind {
        case .cpanel: return "\(appState.domainStatuses.count)"
        case .whm: return "\(appState.whmAccounts.count)"
        }
    }

    private var heroLabel: String {
        profile.kind == .cpanel ? appState.strings.domainsHosted : appState.strings.accountsHosted
    }

    private var versionDetail: String? {
        if profile.kind == .whm, let version = appState.whmVersion {
            return "v\(version)"
        }
        return nil
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(alignment: .firstTextBaseline, spacing: 8) {
                switch appState.connection {
                case .online:
                    if let heroNumber {
                        Text(heroNumber)
                            .font(Theme.Typography.heroNumber)
                            .foregroundColor(Theme.Colors.text)
                            .lineLimit(1)
                            .minimumScaleFactor(0.6)
                        Text(heroLabel)
                            .font(.system(size: 13))
                            .foregroundColor(Theme.Colors.text3)
                    }
                case .unauthorized:
                    Text(appState.strings.statusLocked)
                        .font(Theme.Typography.heroNumber)
                        .foregroundColor(Theme.Colors.text)
                case .offline:
                    Text(appState.strings.statusOffline)
                        .font(Theme.Typography.heroNumber)
                        .foregroundColor(Theme.Colors.text)
                }

                Spacer()

                if appState.connection == .online {
                    Button {
                        appState.openDashboard()
                    } label: {
                        QuietPillLabel(
                            title: profile.kind == .cpanel ? appState.strings.openCPanel : appState.strings.openWHM,
                            icon: "arrow.up.right"
                        )
                    }
                    .buttonStyle(.plain)
                    .help(profile.kind == .cpanel ? appState.strings.openCPanelInBrowser : appState.strings.openWHMInBrowser)
                }
            }

            HStack(spacing: 7) {
                StatusDot(color: stateColor)
                Text(stateText)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(Theme.Colors.text)

                if appState.connection == .online, let versionDetail {
                    Text(versionDetail)
                        .font(.system(size: 12))
                        .foregroundColor(Theme.Colors.text3)
                        .lineLimit(1)
                }

                Spacer()

                HStack(spacing: 4) {
                    if profile.allowInsecureHTTP {
                        Image(systemName: "lock.open.fill")
                            .font(.system(size: 9))
                            .foregroundColor(Theme.Colors.amber)
                            .help(appState.strings.plainHTTPAnywayWarning)
                    }
                    Text(Format.host(profile.urlString))
                        .font(.system(size: 11))
                        .foregroundColor(Theme.Colors.text3)
                        .lineLimit(1)
                }
            }
        }
        .padding(.horizontal, Theme.Layout.gutter)
        .padding(.top, 12)
        .padding(.bottom, 14)
    }
}
