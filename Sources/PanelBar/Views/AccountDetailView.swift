import SwiftUI
import PanelBarCore

struct AccountDetailView: View {
    @EnvironmentObject var appState: AppState
    let account: WHMAccount

    var body: some View {
        VStack(spacing: 0) {
            TopStrip(
                title: account.user,
                subtitle: account.domain,
                kind: .whm,
                back: { appState.selectedWHMAccount = nil },
                backLabel: appState.strings.tabAccounts,
                statusBadge: (account.isSuspended ? appState.strings.suspended : appState.strings.active, account.isSuspended ? Theme.Colors.red : Theme.Colors.green)
            )

            ScrollingContent {
                statusAndDiskCard
                accountInfoSection
                limitsSection
                actionsSection
            }

            FooterBar(
                text: appState.lastChecked.map { appState.strings.lastChecked(time: relative($0)) } ?? appState.strings.checking,
                onRefresh: { Task { await appState.refreshAll() } },
                onSettings: {
                    appState.selectedWHMAccount = nil
                    appState.openSettings()
                },
                onQuit: { appState.exitApp() },
                isLoading: appState.isLoading
            )
        }
        .frame(width: Theme.Layout.popoverWidth, height: Theme.Layout.popoverHeight)
        .background(Theme.Colors.bg)
    }

    private var statusAndDiskCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .center, spacing: 8) {
                StatusDot(color: account.isSuspended ? Theme.Colors.red : Theme.Colors.green, size: 8)
                Text(account.isSuspended ? appState.strings.suspended : appState.strings.active)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(account.isSuspended ? Theme.Colors.red : Theme.Colors.green)
                if account.isSuspended {
                    Chip(text: appState.strings.suspended.uppercased(), tone: Theme.Colors.red)
                }
                Spacer()
                if let fraction = account.diskUsedFraction {
                    Text(appState.strings.quotaPercent(percent: Int((fraction * 100).rounded())))
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(fraction > 0.9 ? Theme.Colors.red : Theme.Colors.text3)
                }
            }

            if account.isSuspended, let reason = account.suspendreason, !reason.isEmpty {
                Text(reason)
                    .font(.system(size: 11))
                    .foregroundColor(Theme.Colors.text2)
                    .padding(8)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Theme.Colors.red.opacity(0.08), in: RoundedRectangle(cornerRadius: 6))
            }

            VStack(alignment: .leading, spacing: 5) {
                HStack(alignment: .firstTextBaseline) {
                    Text(Format.diskSize(account.diskused))
                        .font(Theme.Typography.heroNumber)
                        .foregroundColor(Theme.Colors.text)
                    Text(appState.strings.usedOf(used: Format.diskSize(account.diskused), limit: Format.diskSize(account.disklimit)))
                        .font(.system(size: 12))
                        .foregroundColor(Theme.Colors.text3)
                    Spacer()
                }

                if let fraction = account.diskUsedFraction {
                    MiniBar(fraction: fraction, color: fraction > 0.9 ? Theme.Colors.red : Theme.Colors.whmBlue)
                        .frame(height: 5)
                }
            }
        }
        .padding(12)
        .background(Theme.Colors.card, in: RoundedRectangle(cornerRadius: 7))
        .overlay(RoundedRectangle(cornerRadius: 7).stroke(Theme.Colors.border))
        .padding(.horizontal, Theme.Layout.gutter)
        .padding(.top, 14)
    }

    private var accountInfoSection: some View {
        DetailSection(title: appState.strings.accountInformation) {
            KV(key: appState.strings.username, value: account.user)
            Rectangle().fill(Theme.Colors.hairline).frame(height: 1)
            KV(key: appState.strings.primaryDomain, value: account.domain)

            if let email = account.email, !email.isEmpty {
                Rectangle().fill(Theme.Colors.hairline).frame(height: 1)
                KV(key: appState.strings.contactEmail, value: email)
            }
            if let ip = account.ip, !ip.isEmpty {
                Rectangle().fill(Theme.Colors.hairline).frame(height: 1)
                KV(key: appState.strings.ipAddress, value: ip)
            }
            if let plan = account.plan, !plan.isEmpty {
                Rectangle().fill(Theme.Colors.hairline).frame(height: 1)
                KV(key: appState.strings.hostingPackage, value: plan)
            }
            if let owner = account.owner, !owner.isEmpty {
                Rectangle().fill(Theme.Colors.hairline).frame(height: 1)
                KV(key: appState.strings.owner, value: owner)
            }
            if let startdate = account.startdate, !startdate.isEmpty {
                Rectangle().fill(Theme.Colors.hairline).frame(height: 1)
                KV(key: appState.strings.createdDate, value: startdate)
            }
            if let theme = account.theme, !theme.isEmpty {
                Rectangle().fill(Theme.Colors.hairline).frame(height: 1)
                KV(key: appState.strings.cpanelTheme, value: theme)
            }
        }
    }

    private var limitsSection: some View {
        DetailSection(title: appState.strings.quotasAndLimits) {
            KV(key: appState.strings.diskUsage, value: "\(Format.diskSize(account.diskused)) / \(Format.diskSize(account.disklimit))")
            if let maxaddons = account.maxaddons, !maxaddons.isEmpty {
                Rectangle().fill(Theme.Colors.hairline).frame(height: 1)
                KV(key: appState.strings.maxAddonDomains, value: maxaddons)
            }
            if let maxsub = account.maxsub, !maxsub.isEmpty {
                Rectangle().fill(Theme.Colors.hairline).frame(height: 1)
                KV(key: appState.strings.maxSubdomains, value: maxsub)
            }
            if let maxpop = account.maxpop, !maxpop.isEmpty {
                Rectangle().fill(Theme.Colors.hairline).frame(height: 1)
                KV(key: appState.strings.maxEmailAccounts, value: maxpop)
            }
            if let maxsql = account.maxsql, !maxsql.isEmpty {
                Rectangle().fill(Theme.Colors.hairline).frame(height: 1)
                KV(key: appState.strings.maxSQLDatabases, value: maxsql)
            }
            if let inodes = account.inodesused, !inodes.isEmpty {
                Rectangle().fill(Theme.Colors.hairline).frame(height: 1)
                KV(key: appState.strings.inodes, value: formattedInodes(used: inodes, limit: account.inodeslimit))
            }
        }
    }

    private func formattedInodes(used: String, limit: String?) -> String {
        let usedStr = Int(used).map { Format.count($0) } ?? used
        guard let limit, !limit.isEmpty else { return usedStr }
        let limitStr = Int(limit).map { Format.count($0) } ?? limit
        return "\(usedStr) / \(limitStr)"
    }

    private var actionsSection: some View {
        HStack(spacing: 8) {
            Button {
                openCPanel()
            } label: {
                SecondaryPillLabel(title: "cPanel", icon: "arrow.up.right")
            }
            .buttonStyle(.plain).focusEffectDisabled()

            Button {
                appState.copyText(account.domain)
            } label: {
                SecondaryPillLabel(title: appState.strings.copyDomain, icon: "doc.on.doc")
            }
            .buttonStyle(.plain).focusEffectDisabled()

            Button {
                appState.copyText(account.user)
            } label: {
                SecondaryPillLabel(title: appState.strings.copyUser, icon: "person")
            }
            .buttonStyle(.plain).focusEffectDisabled()

            Spacer()
        }
        .padding(.horizontal, Theme.Layout.gutter)
        .padding(.top, 14)
        .padding(.bottom, 12)
    }

    private func openCPanel() {
        if let url = URL(string: "https://\(account.domain):2083") {
            NSWorkspace.shared.open(url)
        }
    }

    private func relative(_ date: Date) -> String {
        let seconds = Int(Date().timeIntervalSince(date))
        if seconds < 5 { return appState.strings.justNow }
        if seconds < 60 { return appState.strings.secondsAgo(count: seconds) }
        return appState.strings.minutesAgo(count: seconds / 60)
    }
}
