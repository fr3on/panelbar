import SwiftUI
import PanelBarCore

struct DashboardView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        if let profile = appState.activeProfile {
            VStack(spacing: 0) {
                PopoverHeader(profile: profile)
                HeroView(profile: profile)
                switch profile.kind {
                case .cpanel: CPanelTabs()
                case .whm: WHMTabs()
                }
                content(for: profile)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                    .clipped()
                FooterBar(
                    text: appState.lastChecked.map { appState.strings.lastChecked(time: relative($0)) } ?? appState.strings.checking,
                    onRefresh: { Task { await appState.refreshAll() } },
                    onSettings: { appState.openSettings() },
                    onQuit: { appState.exitApp() },
                    isLoading: appState.isLoading
                )
            }
            .frame(width: Theme.Layout.popoverWidth, height: Theme.Layout.popoverHeight, alignment: .top)
        } else {
            VStack(spacing: 0) {
                Spacer()
                VStack(spacing: 14) {
                    Image(systemName: "server.rack")
                        .font(.system(size: 32))
                        .foregroundColor(Theme.Colors.text3)
                    Text(appState.strings.noServerConnected).font(.system(size: 13, weight: .medium)).foregroundColor(Theme.Colors.text)
                    Text(appState.strings.addServerDescription).font(.system(size: 11.5)).foregroundColor(Theme.Colors.text3).multilineTextAlignment(.center).padding(.horizontal, 32)
                    Button { appState.navigateToAddServer() } label: { PrimaryPillLabel(title: appState.strings.addAServer, kind: .cpanel) }
                        .buttonStyle(.plain).focusEffectDisabled()
                }
                Spacer()
                FooterBar(
                    text: "PanelBar v\(appState.appVersion)",
                    onRefresh: { },
                    onSettings: { appState.openSettings() },
                    onQuit: { appState.exitApp() }
                )
            }
        }
    }

    @ViewBuilder
    private func content(for profile: ConnectionProfile) -> some View {
        switch appState.connection {
        case .unauthorized:
            AttentionCard(
                title: appState.strings.tokenRejected,
                body: appState.strings.tokenRejectedBody(host: Format.host(profile.urlString)),
                kind: profile.kind,
                showKeyField: true
            )
            Spacer(minLength: 0)
        case .offline:
            AttentionCard(
                title: appState.strings.unreachable,
                body: appState.connectionError?.errorDescription ?? appState.strings.couldNotConnect(host: Format.host(profile.urlString)),
                kind: profile.kind,
                showKeyField: false
            )
            Spacer(minLength: 0)
        case .online:
            ScrollingContent {
                switch profile.kind {
                case .cpanel:
                    switch appState.cpanelTab {
                    case .overview: CPanelOverviewTab()
                    case .domains: CPanelDomainsTab()
                    }
                case .whm:
                    switch appState.whmTab {
                    case .overview: WHMOverviewTab()
                    case .accounts: WHMAccountsTab()
                    case .services: WHMServicesTab()
                    }
                }
            }
        }
    }

    private func relative(_ date: Date) -> String {
        let seconds = Int(Date().timeIntervalSince(date))
        if seconds < 5 { return appState.strings.justNow }
        if seconds < 60 { return appState.strings.secondsAgo(count: seconds) }
        return appState.strings.minutesAgo(count: seconds / 60)
    }
}

struct CPanelTabs: View {
    @EnvironmentObject var appState: AppState
    var body: some View {
        SegmentedTabs(items: [
            (CPanelTab.overview, appState.strings.tabOverview),
            (CPanelTab.domains, appState.strings.tabDomains)
        ], selected: $appState.cpanelTab)
    }
}

struct WHMTabs: View {
    @EnvironmentObject var appState: AppState
    var body: some View {
        SegmentedTabs(items: [
            (WHMTab.overview, appState.strings.tabOverview),
            (WHMTab.accounts, appState.strings.tabAccounts),
            (WHMTab.services, appState.strings.tabServices)
        ], selected: $appState.whmTab)
    }
}

struct AttentionCard: View {
    @EnvironmentObject var appState: AppState
    let title: String
    let body_: String
    let kind: ConnectionKind
    let showKeyField: Bool

    init(title: String, body: String, kind: ConnectionKind, showKeyField: Bool) {
        self.title = title; self.body_ = body; self.kind = kind; self.showKeyField = showKeyField
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title).font(.system(size: 12.5, weight: .semibold)).foregroundColor(Theme.Colors.text)
            Text(body_).font(.system(size: 11.5)).foregroundColor(Theme.Colors.text2).fixedSize(horizontal: false, vertical: true)
            if showKeyField {
                FormField(label: appState.strings.apiToken, placeholder: appState.strings.pasteNewToken, text: $appState.apiKeyDraft, mono: true, secure: true)
                HStack {
                    Spacer()
                    Button {
                        let key = appState.apiKeyDraft
                        appState.apiKeyDraft = ""
                        Task { await appState.saveApiKey(key) }
                    } label: {
                        PrimaryPillLabel(title: appState.strings.saveToken, kind: kind)
                    }
                    .buttonStyle(.plain).focusEffectDisabled()
                    .disabled(appState.apiKeyDraft.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            } else {
                HStack {
                    Spacer()
                    Button { Task { await appState.refreshAll() } } label: { SecondaryPillLabel(title: appState.strings.retry, icon: "arrow.clockwise") }
                        .buttonStyle(.plain).focusEffectDisabled()
                }
            }
        }
        .padding(13)
        .glassCard()
        .padding(.horizontal, Theme.Layout.gutter).padding(.top, 14)
    }
}
