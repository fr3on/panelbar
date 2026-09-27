import SwiftUI
import PanelBarCore

struct CPanelOverviewTab: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            SectionLabel(text: appState.strings.resources).padding(.top, 14)

            LazyVGrid(columns: [GridItem(.flexible(), spacing: 10), GridItem(.flexible(), spacing: 10)], spacing: 10) {
                diskTile
                sslExpiryTile
                domainsTile
                sslCoverageTile
            }
            .padding(.horizontal, Theme.Layout.gutter).padding(.top, 8)

            DetailSection(title: appState.strings.accountAndServer) {
                if let profile = appState.activeProfile {
                    KV(key: appState.strings.cpanelUser, value: profile.username)
                    Rectangle().fill(Theme.Colors.hairline).frame(height: 1)
                    KV(key: appState.strings.serverHost, value: Format.host(profile.urlString))
                    if let mainDomain = primaryDomain {
                        Rectangle().fill(Theme.Colors.hairline).frame(height: 1)
                        KV(key: appState.strings.primaryDomain, value: mainDomain)
                    }
                    Rectangle().fill(Theme.Colors.hairline).frame(height: 1)
                    KV(key: appState.strings.portAndProtocol, value: profile.allowInsecureHTTP ? "2082 · HTTP" : "2083 · HTTPS")
                }
            }

            quickActionsSection
        }
        .padding(.bottom, 14)
    }

    private var primaryDomain: String? {
        appState.domainStatuses.first(where: { $0.kind.lowercased() == "main" })?.name ?? appState.domainStatuses.first?.name
    }

    private var diskTile: some View {
        let quota = appState.quota
        let fraction = quota?.usedFraction
        let fractionVal = fraction ?? 0
        let color = fractionVal > 0.9 ? Theme.Colors.red : (fractionVal > 0.75 ? Theme.Colors.amber : Theme.Colors.cpanelOrange)

        return StatTile(
            icon: "internaldrive",
            tint: color,
            value: quota.map { Format.mb($0.megabytesUsed) } ?? "—",
            label: quota?.megabyteLimit ?? 0 > 0 ? appState.strings.diskLimit(limit: Format.mb(quota!.megabyteLimit)) : appState.strings.diskUsedUnlimited,
            note: fraction.map { appState.strings.percentUsed(percent: Int(($0 * 100).rounded())) } ?? appState.strings.noQuotaLimit,
            progress: fraction,
            progressColor: color
        )
    }

    private var sslExpiryTile: some View {
        let worst = appState.domainStatuses.first
        return StatTile(
            icon: "lock.shield",
            tint: worst?.daysLeft.map { $0 <= 7 ? Theme.Colors.red : ($0 <= 30 ? Theme.Colors.amber : Theme.Colors.green) } ?? Theme.Colors.gray,
            value: worst?.daysLeft.map { "\($0)d" } ?? "—",
            label: appState.strings.nextSSLExpiry,
            note: worst?.name ?? appState.strings.noCertificates,
            action: { appState.cpanelTab = .domains }
        )
    }

    private var domainsTile: some View {
        let total = appState.domainStatuses.count
        let sub = appState.domainStatuses.filter { $0.kind.lowercased() != "main" }.count
        let note = total == 0 ? appState.strings.noneHosted : (sub > 0 ? appState.strings.subAddon(count: sub) : appState.strings.primaryDomain)

        return StatTile(
            icon: "globe",
            tint: Theme.Colors.cpanelOrange,
            value: "\(total)",
            label: appState.strings.domainsHostedCount(count: total),
            note: note,
            action: { appState.cpanelTab = .domains }
        )
    }

    private var sslCoverageTile: some View {
        let total = appState.domainStatuses.count
        let secure = appState.domainStatuses.filter { ($0.daysLeft ?? 0) > 0 }.count
        let isAllSecure = total > 0 && secure == total
        let tint = isAllSecure ? Theme.Colors.green : (secure > 0 ? Theme.Colors.amber : (total == 0 ? Theme.Colors.gray : Theme.Colors.red))
        let value = total == 0 ? "—" : (isAllSecure ? "100%" : "\(secure)/\(total)")
        let note = total == 0 ? appState.strings.noDomains : (isAllSecure ? appState.strings.allDomainsCovered : appState.strings.unprotected(count: total - secure))

        return StatTile(
            icon: "shield.checkerboard",
            tint: tint,
            value: value,
            label: appState.strings.sslProtection,
            note: note,
            noteColor: isAllSecure ? Theme.Colors.green : (total == 0 ? Theme.Colors.text3 : Theme.Colors.amber),
            progress: total > 0 ? Double(secure) / Double(total) : nil,
            progressColor: tint,
            action: { appState.cpanelTab = .domains }
        )
    }

    private var quickActionsSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            SectionLabel(text: appState.strings.quickActions)
            LazyVGrid(columns: [GridItem(.flexible(), spacing: 8), GridItem(.flexible(), spacing: 8)], spacing: 8) {
                ActionTileButton(
                    title: appState.strings.openCPanel,
                    icon: "safari",
                    subtitle: "Port 2083",
                    tone: Theme.Colors.cpanelOrange,
                    isExternal: true
                ) {
                    appState.openDashboard()
                }

                ActionTileButton(
                    title: appState.strings.webmail,
                    icon: "envelope",
                    subtitle: "Port 2096",
                    tone: Theme.Colors.cpanelOrange,
                    isExternal: true
                ) {
                    appState.openWebmail()
                }

                ActionTileButton(
                    title: appState.strings.tabDomains,
                    icon: "globe",
                    subtitle: "\(appState.domainStatuses.count) hosted",
                    tone: Theme.Colors.cpanelOrange
                ) {
                    appState.cpanelTab = .domains
                }

                if let profile = appState.activeProfile {
                    ActionTileButton(
                        title: appState.strings.copyHost,
                        icon: "doc.on.doc",
                        subtitle: appState.strings.serverAddress,
                        tone: Theme.Colors.text2
                    ) {
                        appState.copyText(Format.host(profile.urlString))
                    }
                }
            }
            .padding(.horizontal, Theme.Layout.gutter)
        }
        .padding(.top, 14)
    }
}

struct CPanelDomainsTab: View {
    @EnvironmentObject var appState: AppState

    private var filtered: [DomainSSLStatus] {
        let query = appState.searchQuery.trimmingCharacters(in: .whitespaces).lowercased()
        guard !query.isEmpty else { return appState.domainStatuses }
        return appState.domainStatuses.filter { $0.name.lowercased().contains(query) }
    }

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 6) {
                Image(systemName: "magnifyingglass").font(.system(size: 11)).foregroundColor(Theme.Colors.text3)
                TextField(appState.strings.filterDomains, text: $appState.searchQuery).textFieldStyle(.plain).font(.system(size: 12))
            }
            .padding(.horizontal, 10).padding(.vertical, 7)
            .background(Theme.Colors.card, in: RoundedRectangle(cornerRadius: 8))
            .padding(.horizontal, Theme.Layout.gutter).padding(.top, 12)

            TableHeader(columns: [appState.strings.tableHeaderDomain, appState.strings.tableHeaderType, appState.strings.tableHeaderSSL]).padding(.top, 10)
            if filtered.isEmpty {
                Text(appState.domainStatuses.isEmpty ? appState.strings.noDomains : appState.strings.noMatches)
                    .font(.system(size: 11.5)).foregroundColor(Theme.Colors.text3)
                    .frame(maxWidth: .infinity).padding(.top, 20)
            } else {
                VStack(spacing: 0) {
                    ForEach(filtered) { d in
                        row(d)
                        Rectangle().fill(Theme.Colors.hairline).frame(height: 1)
                    }
                }
            }
        }
        .padding(.bottom, 12)
    }

    private func row(_ d: DomainSSLStatus) -> some View {
        HStack {
            Text(d.name).font(.system(size: 12.5, weight: .medium)).foregroundColor(Theme.Colors.text).lineLimit(1)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text(d.kind).font(.system(size: 11)).foregroundColor(Theme.Colors.text2).frame(width: 68, alignment: .leading)
            HStack(spacing: 5) {
                StatusDot(color: color(d.daysLeft), size: 6)
                Text(d.daysLeft.map { "\($0)d" } ?? "none").font(.system(size: 11.5, weight: .medium)).foregroundColor(Theme.Colors.text)
            }
            .frame(width: 56, alignment: .leading)
        }
        .padding(.horizontal, Theme.Layout.gutter).padding(.vertical, 10)
        .background(Theme.Colors.card)
        .contentShape(Rectangle())
        .contextMenu {
            Button { appState.copyText(d.name) } label: { Label(appState.strings.copyDomain, systemImage: "doc.on.doc") }
        }
    }

    private func color(_ days: Int?) -> Color {
        guard let d = days else { return Theme.Colors.gray }
        return d <= 7 ? Theme.Colors.red : (d <= 30 ? Theme.Colors.amber : Theme.Colors.green)
    }
}

/// Switch between saved connections (cPanel accounts and WHM servers alike). Named "Servers", not
/// "Accounts", so it never collides with WHM's own Accounts tab (the cPanel accounts a WHM server hosts).
struct ServersTab: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 0) {
                ForEach(appState.profiles) { profile in
                    row(profile)
                    if profile.id != appState.profiles.last?.id {
                        Rectangle().fill(Theme.Colors.hairline).frame(height: 1)
                    }
                }
            }
            HStack {
                Spacer()
                Button { appState.navigateToAddServer() } label: { PrimaryPillLabel(title: appState.strings.addServer, kind: appState.activeProfile?.kind ?? .cpanel) }
                    .buttonStyle(.plain).focusEffectDisabled()
            }
            .padding(.horizontal, Theme.Layout.gutter).padding(.top, 14)
        }
        .padding(.top, 12).padding(.bottom, 12)
    }

    private func row(_ profile: ConnectionProfile) -> some View {
        let active = profile.id == appState.activeProfileID
        return HStack(spacing: 10) {
            StatusDot(color: active ? Theme.Colors.green : Theme.Colors.gray, size: 7)
            Button { appState.switchProfile(to: profile) } label: {
                VStack(alignment: .leading, spacing: 2) {
                    HStack(spacing: 6) {
                        Text(profile.name).font(.system(size: 13, weight: .medium)).foregroundColor(Theme.Colors.text).lineLimit(1)
                        Chip(text: profile.kind == .cpanel ? "CPANEL" : "WHM", tone: Theme.Colors.accent(profile.kind))
                    }
                    Text(Format.host(profile.urlString)).font(.system(size: 11)).foregroundColor(Theme.Colors.text3).lineLimit(1)
                }
                .frame(maxWidth: .infinity, alignment: .leading).contentShape(Rectangle())
            }
            Button {
                appState.startEditingProfile(profile)
            } label: {
                Image(systemName: "pencil").font(.system(size: 11)).foregroundColor(Theme.Colors.text3)
            }
            .buttonStyle(.plain).focusEffectDisabled()
            .help(appState.strings.editServer)

            if active {
                Image(systemName: "checkmark").font(.system(size: 10, weight: .bold)).foregroundColor(Theme.Colors.accent(profile.kind))
            } else {
                Button { appState.deleteProfile(profile.id) } label: {
                    Image(systemName: "trash").font(.system(size: 11)).foregroundColor(Theme.Colors.red.opacity(0.8))
                }
                .buttonStyle(.plain).focusEffectDisabled()
                .help(appState.strings.deleteServer)
            }
        }
        .padding(.horizontal, Theme.Layout.gutter).padding(.vertical, 9)
    }
}
