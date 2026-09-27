import SwiftUI
import PanelBarCore

struct WHMOverviewTab: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            SectionLabel(text: appState.strings.resources).padding(.top, 14)

            LazyVGrid(columns: [GridItem(.flexible(), spacing: 10), GridItem(.flexible(), spacing: 10)], spacing: 10) {
                accountsTile
                loadTile
                diskTile
                servicesTile
            }
            .padding(.horizontal, Theme.Layout.gutter).padding(.top, 8)

            DetailSection(title: appState.strings.systemSection) {
                if let profile = appState.activeProfile {
                    KV(key: appState.strings.hostname, value: appState.hostname ?? Format.host(profile.urlString))
                    Rectangle().fill(Theme.Colors.hairline).frame(height: 1)
                    if let version = appState.whmVersion {
                        KV(key: appState.strings.whmVersion, value: version)
                        Rectangle().fill(Theme.Colors.hairline).frame(height: 1)
                    }
                    KV(key: appState.strings.adminUser, value: profile.username)
                    Rectangle().fill(Theme.Colors.hairline).frame(height: 1)
                    KV(key: appState.strings.portAndProtocol, value: profile.allowInsecureHTTP ? "2086 · HTTP" : "2087 · HTTPS")
                }
            }

            quickActionsSection

            if !appState.whmServices.down.isEmpty {
                servicesDownCard
            }
            if let suspended = appState.whmAccounts.first(where: { $0.isSuspended }) {
                suspendedCard(suspended)
            }
        }
        .padding(.bottom, 14)
    }

    private var accountsTile: some View {
        let suspendedCount = appState.whmAccounts.filter(\.isSuspended).count
        return StatTile(
            icon: "person.2",
            tint: Theme.Colors.whmBlue,
            value: "\(appState.whmAccounts.count)",
            label: appState.strings.accountsHosted,
            note: suspendedCount > 0 ? appState.strings.suspendedCount(count: suspendedCount) : (appState.whmAccounts.isEmpty ? appState.strings.none : appState.strings.allActive),
            noteColor: suspendedCount > 0 ? Theme.Colors.red : Theme.Colors.green,
            action: { appState.whmTab = .accounts }
        )
    }

    @ViewBuilder
    private var loadTile: some View {
        if let load = appState.systemLoad {
            StatTile(
                icon: "gauge.with.dots.needle.50percent",
                tint: Theme.Colors.whmBlue,
                value: String(format: "%.2f", load.one),
                label: appState.strings.loadAverage1m,
                note: String(format: "5m %.2f · 15m %.2f", load.five, load.fifteen)
            )
        } else {
            StatTile(
                icon: "gauge.with.dots.needle.50percent",
                tint: Theme.Colors.whmBlue,
                value: "—",
                label: appState.strings.loadAverage,
                note: appState.strings.checking
            )
        }
    }

    @ViewBuilder
    private var diskTile: some View {
        if let disk = appState.diskUsage {
            StatTile(
                icon: "internaldrive",
                tint: Theme.Colors.text2,
                value: Format.mb(disk.totalUsedMB),
                label: appState.strings.diskUsed,
                note: appState.strings.summedAcrossAccounts(count: disk.accounts.count)
            )
        } else {
            StatTile(
                icon: "internaldrive",
                tint: Theme.Colors.text2,
                value: "—",
                label: appState.strings.diskUsed,
                note: appState.strings.summingAccounts
            )
        }
    }

    private var servicesTile: some View {
        let monitored = appState.whmServices.filter { $0.installed && $0.monitored }
        let total = monitored.count
        let down = appState.whmServices.down.count
        let up = monitored.filter { $0.state == .up }.count
        let isHealthy = down == 0 && total > 0
        let tint = isHealthy ? Theme.Colors.green : (total == 0 ? Theme.Colors.gray : Theme.Colors.red)

        return StatTile(
            icon: "server.rack",
            tint: tint,
            value: total > 0 ? "\(up)/\(total)" : "—",
            label: appState.strings.servicesOnline,
            note: total == 0 ? appState.strings.checking : (isHealthy ? appState.strings.allMonitoredRunning : appState.strings.servicesDown(count: down)),
            noteColor: isHealthy ? Theme.Colors.green : (total == 0 ? Theme.Colors.text3 : Theme.Colors.red),
            action: { appState.whmTab = .services }
        )
    }

    private var quickActionsSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            SectionLabel(text: appState.strings.quickActions)
            LazyVGrid(columns: [GridItem(.flexible(), spacing: 8), GridItem(.flexible(), spacing: 8)], spacing: 8) {
                ActionTileButton(
                    title: appState.strings.openWHM,
                    icon: "safari",
                    subtitle: "Port 2087",
                    tone: Theme.Colors.whmBlue,
                    isExternal: true
                ) {
                    appState.openDashboard()
                }

                ActionTileButton(
                    title: appState.strings.tabAccounts,
                    icon: "person.2",
                    subtitle: "\(appState.whmAccounts.count) hosted",
                    tone: Theme.Colors.whmBlue
                ) {
                    appState.whmTab = .accounts
                }

                ActionTileButton(
                    title: appState.strings.tabServices,
                    icon: "server.rack",
                    subtitle: "\(appState.whmServices.filter { $0.state == .up }.count) online",
                    tone: Theme.Colors.whmBlue
                ) {
                    appState.whmTab = .services
                }

                if let profile = appState.activeProfile {
                    ActionTileButton(
                        title: appState.strings.copyHost,
                        icon: "doc.on.doc",
                        subtitle: appState.strings.hostname,
                        tone: Theme.Colors.text2
                    ) {
                        appState.copyText(appState.hostname ?? Format.host(profile.urlString))
                    }
                }
            }
            .padding(.horizontal, Theme.Layout.gutter)
        }
        .padding(.top, 14)
    }

    private var servicesDownCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 6) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.system(size: 11))
                    .foregroundColor(Theme.Colors.red)
                Text(appState.strings.servicesDownCardTitle)
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(Theme.Colors.text)
                Spacer()
                Button {
                    appState.whmTab = .services
                } label: {
                    Text(appState.strings.inspect)
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(Theme.Colors.whmBlue)
                }
                .buttonStyle(.plain).focusEffectDisabled()
            }
            Text(appState.whmServices.down.map(\.displayName).joined(separator: ", "))
                .font(.system(size: 11))
                .foregroundColor(Theme.Colors.text2)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(11)
        .background(Theme.Colors.red.opacity(0.10), in: RoundedRectangle(cornerRadius: Theme.Layout.cardRadius))
        .overlay(RoundedRectangle(cornerRadius: Theme.Layout.cardRadius).stroke(Theme.Colors.red.opacity(0.25), lineWidth: 1))
        .shadow(color: Theme.Colors.cardShadow, radius: 10, x: 0, y: 4)
        .padding(.horizontal, Theme.Layout.gutter)
        .padding(.top, 12)
    }

    private func suspendedCard(_ account: WHMAccount) -> some View {
        let count = appState.whmAccounts.filter(\.isSuspended).count
        return VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 6) {
                Image(systemName: "pause.circle.fill")
                    .font(.system(size: 11))
                    .foregroundColor(Theme.Colors.amber)
                Text(appState.strings.accountSuspendedTitle(count: count))
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(Theme.Colors.text)
                Spacer()
                Button {
                    appState.whmTab = .accounts
                } label: {
                    Text(appState.strings.view)
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(Theme.Colors.whmBlue)
                }
                .buttonStyle(.plain).focusEffectDisabled()
            }
            Text("\(account.user) (\(account.domain))\(count > 1 ? " and \(count - 1) other\(count == 2 ? "" : "s")" : "")")
                .font(.system(size: 11))
                .foregroundColor(Theme.Colors.text2)
        }
        .padding(11)
        .background(Theme.Colors.amber.opacity(0.10), in: RoundedRectangle(cornerRadius: Theme.Layout.cardRadius))
        .overlay(RoundedRectangle(cornerRadius: Theme.Layout.cardRadius).stroke(Theme.Colors.amber.opacity(0.25), lineWidth: 1))
        .shadow(color: Theme.Colors.cardShadow, radius: 10, x: 0, y: 4)
        .padding(.horizontal, Theme.Layout.gutter)
        .padding(.top, 10)
    }
}

struct WHMAccountsTab: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        VStack(spacing: 0) {
            TableHeader(columns: [appState.strings.tableHeaderAccount, appState.strings.tableHeaderDisk]).padding(.top, 12)
            VStack(spacing: 0) {
                ForEach(appState.whmAccounts.sorted { $0.diskUsedMB ?? 0 > $1.diskUsedMB ?? 0 }) { a in
                    row(a)
                    Rectangle().fill(Theme.Colors.hairline).frame(height: 1)
                }
            }
        }
        .padding(.bottom, 12)
    }

    private func row(_ a: WHMAccount) -> some View {
        Button {
            appState.selectedWHMAccount = a
        } label: {
            HStack(spacing: 8) {
                VStack(alignment: .leading, spacing: 1) {
                    HStack(spacing: 6) {
                        Text(a.user).font(.system(size: 12.5, weight: .medium)).foregroundColor(Theme.Colors.text)
                        if a.isSuspended { Chip(text: appState.strings.suspended.uppercased(), tone: Theme.Colors.red) }
                    }
                    Text(a.domain).font(.system(size: 10.5)).foregroundColor(Theme.Colors.text3).lineLimit(1)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                if let used = a.diskUsedMB {
                    VStack(alignment: .trailing, spacing: 3) {
                        Text(Format.mb(used)).font(.system(size: 11.5, weight: .medium)).foregroundColor(Theme.Colors.text)
                        if let fraction = a.diskUsedFraction {
                            MiniBar(fraction: fraction, color: fraction > 0.9 ? Theme.Colors.red : Theme.Colors.whmBlue).frame(width: 44)
                        }
                    }
                }

                Image(systemName: "chevron.right")
                    .font(.system(size: 9, weight: .semibold))
                    .foregroundColor(Theme.Colors.text3.opacity(0.7))
                    .padding(.leading, 2)
            }
            .padding(.horizontal, Theme.Layout.gutter).padding(.vertical, 10)
            .background(Theme.Colors.card)
            .contentShape(Rectangle())
            .opacity(a.isSuspended ? 0.75 : 1)
        }
        .buttonStyle(.plain).focusEffectDisabled()
        .contextMenu {
            Button { appState.selectedWHMAccount = a } label: { Label(appState.strings.viewAccountDetails, systemImage: "info.circle") }
            Button { appState.copyText(a.user) } label: { Label(appState.strings.copyUsername, systemImage: "doc.on.doc") }
            Button { appState.copyText(a.domain) } label: { Label(appState.strings.copyDomain, systemImage: "doc.on.doc") }
        }
    }
}

struct WHMServicesTab: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        VStack(spacing: 0) {
            TableHeader(columns: [appState.strings.tableHeaderService, appState.strings.tableHeaderStatus]).padding(.top, 12)
            VStack(spacing: 0) {
                ForEach(sorted) { s in
                    row(s)
                    Rectangle().fill(Theme.Colors.hairline).frame(height: 1)
                }
            }
        }
        .padding(.bottom, 12)
    }

    private var sorted: [WHMService] {
        appState.whmServices.sorted { rank($0) < rank($1) }
    }

    private func rank(_ s: WHMService) -> Int {
        switch s.state {
        case .down: return 0
        case .notMonitored: return 1
        case .up: return 2
        case .notInstalled: return 3
        }
    }

    private func row(_ s: WHMService) -> some View {
        HStack {
            Text(s.displayName).font(.system(size: 12.5, weight: .medium)).foregroundColor(Theme.Colors.text).lineLimit(1)
            Spacer()
            HStack(spacing: 5) {
                StatusDot(color: color(s), size: 6)
                Text(label(s)).font(.system(size: 11.5)).foregroundColor(Theme.Colors.text2)
            }
        }
        .padding(.horizontal, Theme.Layout.gutter).padding(.vertical, 10)
        .background(Theme.Colors.card)
    }

    private func color(_ s: WHMService) -> Color {
        switch s.state {
        case .up: return Theme.Colors.green
        case .down: return Theme.Colors.red
        case .notMonitored: return Theme.Colors.amber
        case .notInstalled: return Theme.Colors.gray
        }
    }

    private func label(_ s: WHMService) -> String {
        switch s.state {
        case .up: return appState.strings.serviceUp
        case .down: return appState.strings.serviceDown
        case .notMonitored: return appState.strings.serviceNotMonitored
        case .notInstalled: return appState.strings.serviceNotInstalled
        }
    }
}
