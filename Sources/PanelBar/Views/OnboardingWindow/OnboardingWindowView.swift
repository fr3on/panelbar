import SwiftUI
import PanelBarCore

struct OnboardingWindowView: View {
    @EnvironmentObject var appState: AppState
    static let size = CGSize(width: 620, height: 500)

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 6) {
                ForEach(0..<3, id: \.self) { i in
                    Capsule().fill(i == appState.onboardingStep ? Theme.Colors.text : Theme.Colors.hairline)
                        .frame(width: i == appState.onboardingStep ? 22 : 7, height: 7)
                }
            }
            .frame(maxWidth: .infinity).frame(height: 44)

            Group {
                switch appState.onboardingStep {
                case 0: welcomeStep
                case 1: connectStep
                default: connectedStep
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.horizontal, 32).padding(.bottom, 24)
        }
        .frame(width: Self.size.width, height: Self.size.height)
        .background(GlassBackdrop())
        .environment(\.appLanguage, appState.language)
    }

    // MARK: Step 1

    private var welcomeStep: some View {
        HStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 14) {
                Spacer(minLength: 0)
                Text(appState.strings.onboardingWelcomeTag).font(.system(size: 11, weight: .bold)).tracking(0.8).foregroundColor(Theme.Colors.cpanelOrange)
                Text(appState.strings.welcomeToPanelBar).font(.system(size: 27, weight: .semibold)).foregroundColor(Theme.Colors.text).lineSpacing(2)
                Text(appState.strings.onboardingSubtitle)
                    .font(.system(size: 12.5)).foregroundColor(Theme.Colors.text2).fixedSize(horizontal: false, vertical: true)
                VStack(alignment: .leading, spacing: 8) {
                    bullet(appState.strings.onboardingBullet1)
                    bullet(appState.strings.onboardingBullet2)
                }
                Spacer(minLength: 0)
                Button { appState.onboardingStep = 1 } label: { PrimaryPillLabel(title: appState.strings.getStarted, kind: .cpanel) }.buttonStyle(.plain).focusEffectDisabled()
            }
            .padding(.trailing, 20).frame(width: 300, alignment: .leading)

            miniPreview.frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }

    private func bullet(_ text: String) -> some View {
        HStack(alignment: .top, spacing: 8) {
            Circle().fill(Theme.Colors.text3).frame(width: 3, height: 3).padding(.top, 6)
            Text(text).font(.system(size: 11.5)).foregroundColor(Theme.Colors.text2).fixedSize(horizontal: false, vertical: true)
        }
    }

    private var miniPreview: some View {
        VStack(spacing: 10) {
            miniCard(kind: .cpanel, title: "agency-client.com", line: "82 days left")
                .rotationEffect(.degrees(-2)).offset(x: -6)
            miniCard(kind: .whm, title: "srv1.host.example.com", line: "13 accounts")
                .rotationEffect(.degrees(1.5)).offset(x: 10)
        }
    }

    private func miniCard(kind: ConnectionKind, title: String, line: String) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(title).font(.system(size: 11, weight: .semibold)).foregroundColor(.white).lineLimit(1)
                .padding(.horizontal, 10).padding(.vertical, 8).frame(maxWidth: .infinity, alignment: .leading)
                .background(Theme.Colors.accent(kind))
            Text(line).font(.system(size: 10.5)).foregroundColor(Theme.Colors.text2)
                .padding(.horizontal, 10).padding(.vertical, 9).frame(maxWidth: .infinity, alignment: .leading)
                .background(Theme.Colors.card)
        }
        .frame(width: 190).clipShape(RoundedRectangle(cornerRadius: Theme.Layout.cardRadius))
        .overlay(RoundedRectangle(cornerRadius: Theme.Layout.cardRadius).stroke(Color.black.opacity(0.08)))
        .shadow(color: .black.opacity(0.12), radius: 10, y: 6)
    }

    // MARK: Step 2

    private var connectStep: some View {
        VStack(alignment: .leading, spacing: 12) {
            VStack(alignment: .leading, spacing: 3) {
                Text(appState.strings.connectAccountOrServer).font(.system(size: 17, weight: .semibold)).foregroundColor(Theme.Colors.text)
                Text(appState.strings.connectStepSubtitle).font(.system(size: 11.5)).foregroundColor(Theme.Colors.text3)
            }
            ScrollingContent {
                ConnectForm().padding(.bottom, 8)
            }
            HStack {
                Button { appState.onboardingStep = 0 } label: { Text("← \(appState.strings.back)").font(.system(size: 12)).foregroundColor(Theme.Colors.text3) }.buttonStyle(.plain).focusEffectDisabled()
                Spacer()
                if appState.testSuccess == false {
                    Button { saveAndContinue() } label: { Text(appState.strings.saveAnyway).font(.system(size: 12)).foregroundColor(Theme.Colors.text2) }
                        .buttonStyle(.plain).padding(.trailing, 6)
                }
                Button {
                    Task {
                        if appState.testSuccess != true { await appState.testConnection() }
                        if appState.testSuccess == true { saveAndContinue() }
                    }
                } label: {
                    PrimaryPillLabel(title: appState.strings.connectAndContinue, kind: appState.newKind)
                        .opacity(appState.newURL.isEmpty ? 0.4 : 1)
                }
                .buttonStyle(.plain).focusEffectDisabled()
                .disabled(appState.newURL.isEmpty || appState.isTestingConnection)
            }
        }
    }

    private func saveAndContinue() {
        appState.saveNewProfile()
        appState.onboardingStep = 2
    }

    // MARK: Step 3

    private var connectedStep: some View {
        let online = appState.isHealthy
        let color: Color = online ? Theme.Colors.green : (appState.isUnauthorized ? Theme.Colors.amber : Theme.Colors.gray)
        return VStack(spacing: 0) {
            Spacer(minLength: 4)
            ZStack {
                Circle().fill(color.opacity(0.13)).frame(width: 56, height: 56)
                Image(systemName: online ? "checkmark" : (appState.isUnauthorized ? "lock.fill" : "ellipsis"))
                    .font(.system(size: 22, weight: .bold)).foregroundColor(color)
            }
            Text(online ? appState.strings.youreConnected : appState.strings.saved).font(.system(size: 22, weight: .semibold)).foregroundColor(Theme.Colors.text).padding(.top, 14)
            Text(summaryLine).font(.system(size: 12.5)).foregroundColor(Theme.Colors.text2).padding(.top, 4)
            VStack(alignment: .leading, spacing: 9) {
                tip("menubar.rectangle", appState.strings.onboardingTip1)
                tip("lock.shield", appState.strings.onboardingTip2)
                tip("plus.circle", appState.strings.onboardingTip3)
            }
            .padding(14).frame(maxWidth: .infinity, alignment: .leading)
            .glassCard()
            .padding(.horizontal, 40).padding(.top, 20)
            Spacer(minLength: 0)
            Button {
                appState.hasCompletedOnboarding = true
                OnboardingWindowManager.shared.close()
                Task { await appState.refreshAll() }
            } label: { PrimaryPillLabel(title: appState.strings.openPanelBar, kind: appState.activeProfile?.kind ?? .cpanel) }
            .buttonStyle(.plain).focusEffectDisabled()
        }
    }

    private var summaryLine: String {
        guard let profile = appState.activeProfile else { return "" }
        var parts = [profile.name]
        switch appState.connection {
        case .online:
            switch profile.kind {
            case .cpanel: parts.append(appState.strings.domainsHostedCount(count: appState.domainStatuses.count))
            case .whm: parts.append("\(appState.whmAccounts.count) \(appState.strings.accountsHosted)")
            }
        case .unauthorized: parts.append(appState.strings.statusNeedsToken)
        case .offline: parts.append(appState.strings.checking)
        }
        return parts.joined(separator: " \u{B7} ")
    }

    private func tip(_ icon: String, _ text: String) -> some View {
        HStack(alignment: .top, spacing: 9) {
            Image(systemName: icon).font(.system(size: 11)).foregroundColor(Theme.Colors.cpanelOrange).frame(width: 15)
            Text(text).font(.system(size: 11.5)).foregroundColor(Theme.Colors.text2).fixedSize(horizontal: false, vertical: true)
        }
    }
}
