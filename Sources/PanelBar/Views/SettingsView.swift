import SwiftUI
import PanelBarCore

struct SettingsView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        VStack(spacing: 0) {
            header
            ScrollingContent {
                serversGroup
                generalGroup
                menuBarGroup
                refreshGroup
                securityGroup
                privacyGroup
                aboutGroup
            }
            footer
        }
        .frame(width: Theme.Layout.popoverWidth, height: Theme.Layout.popoverHeight)
        .background(Theme.Colors.bg)
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 9) {
            GlassPillButton(icon: "chevron.left", title: appState.strings.back, onLight: true) {
                appState.closeSettings()
            }
            HStack(spacing: 10) {
                ZStack {
                    RoundedRectangle(cornerRadius: 9, style: .continuous)
                        .fill(LinearGradient(colors: [Theme.Colors.text2, Theme.Colors.text2.opacity(0.8)], startPoint: .top, endPoint: .bottom))
                        .frame(width: 32, height: 32)
                    Image(systemName: "gearshape.fill").font(.system(size: 13, weight: .semibold)).foregroundColor(.white)
                }
                Text(appState.strings.settings).font(.system(size: 14.5, weight: .bold)).foregroundColor(Theme.Colors.text)
                Spacer()
            }
        }
        .padding(.horizontal, 14).padding(.top, 14).padding(.bottom, 14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .solidCard(radius: 20)
        .padding(.horizontal, 10).padding(.top, 10)
    }

    private func group<Content: View>(_ title: String, icon: String, @ViewBuilder _ content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 5) {
                Image(systemName: icon).font(.system(size: 10, weight: .semibold)).foregroundColor(Theme.Colors.text3)
                Text(title.uppercased()).font(.system(size: 10.5, weight: .bold)).tracking(0.4).foregroundColor(Theme.Colors.text3)
            }
            .padding(.horizontal, Theme.Layout.gutter)
            VStack(spacing: 0) { content() }
                .clipShape(RoundedRectangle(cornerRadius: Theme.Layout.cardRadius))
                .overlay(RoundedRectangle(cornerRadius: Theme.Layout.cardRadius).stroke(Theme.Colors.border, lineWidth: 1))
                .shadow(color: Theme.Colors.cardShadow, radius: 10, x: 0, y: 4)
                .padding(.horizontal, Theme.Layout.gutter)
        }.padding(.top, 16)
    }

    private func row<Control: View>(_ title: String, detail: String? = nil, @ViewBuilder _ control: () -> Control) -> some View {
        HStack(alignment: .center, spacing: 10) {
            VStack(alignment: .leading, spacing: 2) {
                Text(title).font(.system(size: 12.5)).foregroundColor(Theme.Colors.text)
                if let detail { Text(detail).font(.system(size: 10.5)).foregroundColor(Theme.Colors.text3).fixedSize(horizontal: false, vertical: true) }
            }
            Spacer(minLength: 8)
            control()
        }
        .padding(.horizontal, Theme.Layout.gutter).padding(.vertical, 7).background(Theme.Colors.card)
    }

    private var menuBarGroup: some View {
        group(appState.strings.menuBarSection, icon: "menubar.rectangle") {
            row(appState.strings.showNextToIcon) {
                dropdownPicker(
                    id: "menuBarStat",
                    selectedLabel: title(for: appState.settings.menuBarStat),
                    options: AppSettings.MenuBarStat.allCases.map { ($0.rawValue, title(for: $0)) },
                    isSelected: { $0 == appState.settings.menuBarStat.rawValue },
                    onSelect: { id in
                        if let stat = AppSettings.MenuBarStat(rawValue: id) { appState.settings.menuBarStat = stat }
                    }
                )
            }
            Rectangle().fill(Theme.Colors.hairline).frame(height: 1)
            row(appState.strings.iconAndDotOnlyWhenOffline) { SwitchControl(isOn: $appState.settings.hideStatWhenOffline) }
        }
    }

    private func title(for stat: AppSettings.MenuBarStat) -> String {
        switch stat {
        case .none: return appState.strings.statIconOnly
        case .primary: return appState.strings.statDiskAccounts
        case .sslDaysLeft: return appState.strings.statSSLDaysServices
        }
    }

    private var refreshGroup: some View {
        group(appState.strings.refreshSection, icon: "arrow.clockwise") {
            row(appState.strings.whilePopoverOpen, detail: appState.strings.refreshGentleNote) {
                dropdownPicker(
                    id: "openRefresh",
                    selectedLabel: appState.strings.minutes(count: appState.settings.openRefreshMinutes),
                    options: AppSettings.openRefreshMinuteChoices.map { (String($0), appState.strings.minutes(count: $0)) },
                    isSelected: { $0 == String(appState.settings.openRefreshMinutes) },
                    onSelect: { id in if let minutes = Int(id) { appState.settings.openRefreshMinutes = minutes } }
                )
            }
            Rectangle().fill(Theme.Colors.hairline).frame(height: 1)
            row(appState.strings.inTheBackground) {
                dropdownPicker(
                    id: "backgroundRefresh",
                    selectedLabel: appState.settings.backgroundRefreshMinutes == 0 ? appState.strings.off : appState.strings.minutes(count: appState.settings.backgroundRefreshMinutes),
                    options: AppSettings.backgroundRefreshMinuteChoices.map { (String($0), $0 == 0 ? appState.strings.off : appState.strings.minutes(count: $0)) },
                    isSelected: { $0 == String(appState.settings.backgroundRefreshMinutes) },
                    onSelect: { id in if let minutes = Int(id) { appState.settings.backgroundRefreshMinutes = minutes } }
                )
            }
        }
    }

    private var generalGroup: some View {
        group(appState.strings.generalSection, icon: "slider.horizontal.3") {
            row(appState.strings.launchAtLogin, detail: appState.launchAtLoginMessage) { SwitchControl(isOn: $appState.launchAtLogin) }
            Rectangle().fill(Theme.Colors.hairline).frame(height: 1)
            row(appState.strings.appearance) {
                dropdownPicker(
                    id: "appearance",
                    selectedLabel: appearanceTitle(appState.settings.appearance),
                    options: AppSettings.AppearanceChoice.allCases.map { ($0.rawValue, appearanceTitle($0)) },
                    isSelected: { $0 == appState.settings.appearance.rawValue },
                    onSelect: { id in
                        if let choice = AppSettings.AppearanceChoice(rawValue: id) { appState.settings.appearance = choice }
                    }
                )
            }
            Rectangle().fill(Theme.Colors.hairline).frame(height: 1)
            row(appState.strings.languageTitle) {
                dropdownPicker(
                    id: "language",
                    selectedLabel: appState.settings.language == .system ? appState.strings.systemDefault : appState.settings.language.displayName,
                    options: [(AppLanguage.system.rawValue, "\(appState.strings.systemDefault) (\(AppLanguage.resolveSystemLanguage().displayName))")]
                        + AppLanguage.supportedLanguages.map { ($0.rawValue, $0.displayName) },
                    isSelected: { $0 == appState.settings.language.rawValue },
                    onSelect: { id in
                        if let lang = AppLanguage(rawValue: id) { appState.setLanguage(lang) }
                    }
                )
            }
        }
    }

    private func appearanceTitle(_ choice: AppSettings.AppearanceChoice) -> String {
        switch choice {
        case .system: return appState.strings.appearanceSystem
        case .light: return appState.strings.appearanceLight
        case .dark: return appState.strings.appearanceDark
        }
    }

    /// A pill trigger + native popover panel, replacing plain `Menu` (whose bezel/chrome renders
    /// unreliably on this OS — see the profile switcher fix) and a hand-rolled overlay (which got
    /// clipped by the section card's own `.clipShape`, cutting the option list off). `.popover` is
    /// presented in its own layer, so it escapes both problems and tracks scrolling automatically.
    /// Only one picker is open at a time, tracked by `appState.openSettingsPickerID`.
    private func dropdownPicker(
        id: String,
        selectedLabel: String,
        options: [(id: String, label: String)],
        isSelected: @escaping (String) -> Bool,
        onSelect: @escaping (String) -> Void
    ) -> some View {
        let isOpen = appState.openSettingsPickerID == id
        return Button {
            withAnimation(.easeOut(duration: 0.12)) { appState.openSettingsPickerID = isOpen ? nil : id }
        } label: {
            pill(selectedLabel)
        }
        .buttonStyle(.plain).focusEffectDisabled()
        .popover(isPresented: Binding(
            get: { appState.openSettingsPickerID == id },
            set: { if !$0 { appState.openSettingsPickerID = nil } }
        ), arrowEdge: .top) {
            VStack(alignment: .leading, spacing: 1) {
                ForEach(options, id: \.id) { option in
                    Button {
                        onSelect(option.id)
                        appState.openSettingsPickerID = nil
                    } label: {
                        HStack(spacing: 10) {
                            Text(option.label).font(.system(size: 12, weight: .medium)).foregroundColor(Theme.Colors.text).lineLimit(1)
                            Spacer(minLength: 10)
                            if isSelected(option.id) {
                                Image(systemName: "checkmark").font(.system(size: 10, weight: .bold)).foregroundColor(Theme.Colors.text2)
                            }
                        }
                        .padding(.horizontal, 10).padding(.vertical, 6)
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain).focusEffectDisabled()
                }
            }
            .padding(4)
            .frame(minWidth: 180, alignment: .leading)
        }
    }

    private func pill(_ text: String) -> some View {
        HStack(spacing: 4) {
            Text(text).font(.system(size: 12.5)).foregroundColor(Theme.Colors.text2)
            Image(systemName: "chevron.down").font(.system(size: 8, weight: .bold)).foregroundColor(Theme.Colors.text3)
        }
        .padding(.horizontal, 8).padding(.vertical, 4)
        .background(Theme.Colors.card, in: RoundedRectangle(cornerRadius: 5)).overlay(RoundedRectangle(cornerRadius: 5).stroke(Theme.Colors.border))
    }

    private var securityGroup: some View {
        group(appState.strings.securitySection, icon: "lock.shield") {
            row(appState.strings.protectWithTouchID, detail: TouchIDManager.shared.isTouchIDAvailable ? appState.strings.touchIDDetailAvailable : appState.strings.touchIDDetailUnavailable) {
                if TouchIDManager.shared.isTouchIDAvailable {
                    Button {
                        appState.toggleTouchID()
                    } label: {
                        HStack(spacing: 6) {
                            Image(systemName: "touchid")
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundColor(appState.requireTouchID ? Theme.Colors.accent(appState.activeProfile?.kind ?? .cpanel) : Theme.Colors.text3)
                            Text(appState.requireTouchID ? appState.strings.enabled : appState.strings.disabled)
                                .font(.system(size: 11, weight: .medium))
                                .foregroundColor(appState.requireTouchID ? Theme.Colors.text : Theme.Colors.text3)
                        }
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(appState.requireTouchID ? Theme.Colors.accent(appState.activeProfile?.kind ?? .cpanel).opacity(0.12) : Theme.Colors.card, in: RoundedRectangle(cornerRadius: 6))
                        .overlay(RoundedRectangle(cornerRadius: 6).stroke(appState.requireTouchID ? Theme.Colors.accent(appState.activeProfile?.kind ?? .cpanel).opacity(0.4) : Theme.Colors.border))
                    }
                    .buttonStyle(.plain).focusEffectDisabled()
                } else {
                    Text(appState.strings.unavailable)
                        .font(.system(size: 11))
                        .foregroundColor(Theme.Colors.text3)
                }
            }
        }
    }

    private var serversGroup: some View {
        group(appState.strings.serversSection, icon: "server.rack") {
            VStack(spacing: 0) {
                ForEach(appState.profiles) { profile in
                    HStack(spacing: 8) {
                        StatusDot(color: profile.id == appState.activeProfileID ? Theme.Colors.green : Theme.Colors.gray, size: 7)
                        VStack(alignment: .leading, spacing: 2) {
                            HStack(spacing: 6) {
                                Text(profile.name).font(.system(size: 12.5, weight: .medium)).foregroundColor(Theme.Colors.text).lineLimit(1)
                                Chip(text: profile.kind == .cpanel ? "CPANEL" : "WHM", tone: Theme.Colors.accent(profile.kind))
                                if profile.id == appState.activeProfileID {
                                    Text(appState.strings.active).font(.system(size: 10, weight: .medium)).foregroundColor(Theme.Colors.text3)
                                }
                            }
                            Text(Format.host(profile.urlString)).font(.system(size: 10.5)).foregroundColor(Theme.Colors.text3).lineLimit(1)
                        }
                        Spacer()

                        Button {
                            appState.startEditingProfile(profile)
                        } label: {
                            Image(systemName: "pencil")
                                .font(.system(size: 11))
                                .foregroundColor(Theme.Colors.text2)
                                .padding(5)
                                .background(Theme.Colors.hairline, in: RoundedRectangle(cornerRadius: 4))
                        }
                        .buttonStyle(.plain).focusEffectDisabled()
                        .help(appState.strings.editServer)

                        Button {
                            appState.deleteProfile(profile.id)
                        } label: {
                            Image(systemName: "trash")
                                .font(.system(size: 11))
                                .foregroundColor(Theme.Colors.red)
                                .padding(5)
                                .background(Theme.Colors.red.opacity(0.1), in: RoundedRectangle(cornerRadius: 4))
                        }
                        .buttonStyle(.plain).focusEffectDisabled()
                        .help(appState.strings.deleteServer)
                    }
                    .padding(.horizontal, 12).padding(.vertical, 8)
                    .background(Theme.Colors.card)

                    Rectangle().fill(Theme.Colors.hairline).frame(height: 1)
                }

                Button {
                    appState.navigateToAddServer()
                } label: {
                    HStack(spacing: 5) {
                        Image(systemName: "plus").font(.system(size: 10, weight: .bold))
                        Text(appState.strings.addAnotherServer).font(.system(size: 11.5, weight: .medium))
                        Spacer()
                    }
                    .foregroundColor(Theme.Colors.accent(appState.activeProfile?.kind ?? .cpanel))
                    .padding(.horizontal, 12).padding(.vertical, 9)
                    .background(Theme.Colors.card)
                }
                .buttonStyle(.plain).focusEffectDisabled()
            }
        }
    }

    private var privacyGroup: some View {
        group(appState.strings.privacySection, icon: "hand.raised") {
            Text(appState.strings.privacyNote)
                .font(.system(size: 11)).foregroundColor(Theme.Colors.text3).padding(.horizontal, 12).padding(.vertical, 10)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    private var aboutGroup: some View {
        group(appState.strings.aboutSection, icon: "info.circle") {
            VStack(spacing: 0) {
                HStack(alignment: .center, spacing: 12) {
                    Image(nsImage: NSApp.applicationIconImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 32, height: 32)
                        .clipShape(RoundedRectangle(cornerRadius: 7, style: .continuous))
                        .shadow(color: Color.black.opacity(0.2), radius: 3, y: 1)

                    VStack(alignment: .leading, spacing: 2) {
                        Text("PanelBar").font(.system(size: 13, weight: .semibold)).foregroundColor(Theme.Colors.text)
                        Text(appState.strings.unofficialDisclaimer(version: appState.appVersion))
                            .font(.system(size: 10.5)).foregroundColor(Theme.Colors.text3).fixedSize(horizontal: false, vertical: true)
                    }
                    Spacer()
                }
                .padding(.horizontal, 12).padding(.vertical, 9)
                .background(Theme.Colors.card)

                Rectangle().fill(Theme.Colors.hairline).frame(height: 1)

                // Update checker section
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Button {
                            Task { await appState.checkForUpdates() }
                        } label: {
                            HStack(spacing: 5) {
                                if appState.updateStatus == .checking {
                                    ProgressView().scaleEffect(0.5).frame(width: 10, height: 10)
                                } else {
                                    Image(systemName: "arrow.triangle.2.circlepath").font(.system(size: 10, weight: .medium))
                                }
                                Text(appState.strings.checkForUpdates).font(.system(size: 11.5, weight: .medium))
                            }
                            .foregroundColor(Theme.Colors.text)
                            .padding(.horizontal, 10).padding(.vertical, 5)
                            .background(Theme.Colors.card, in: RoundedRectangle(cornerRadius: 5))
                            .overlay(RoundedRectangle(cornerRadius: 5).stroke(Theme.Colors.border))
                        }
                        .buttonStyle(.plain).focusEffectDisabled()
                        .disabled(appState.updateStatus == .checking)

                        Spacer()
                    }

                    switch appState.updateStatus {
                    case .idle:
                        EmptyView()
                    case .checking:
                        HStack(spacing: 6) {
                            ProgressView().scaleEffect(0.5).frame(width: 8, height: 8)
                            Text(appState.strings.checkingForUpdates).font(.system(size: 11)).foregroundColor(Theme.Colors.text3)
                        }
                    case .upToDate(let version):
                        HStack(spacing: 6) {
                            StatusDot(color: Theme.Colors.green, size: 6)
                            Text(appState.strings.upToDate(version: version)).font(.system(size: 11.5)).foregroundColor(Theme.Colors.text2)
                        }
                    case .updateAvailable(let version, let releaseURL):
                        HStack(spacing: 6) {
                            StatusDot(color: Theme.Colors.cpanelOrange, size: 6)
                            Text(appState.strings.updateAvailable(version: version)).font(.system(size: 11.5, weight: .medium)).foregroundColor(Theme.Colors.text)
                            Spacer()
                            Button {
                                NSWorkspace.shared.open(releaseURL)
                            } label: {
                                HStack(spacing: 3) {
                                    Text(appState.strings.viewRelease).font(.system(size: 11, weight: .medium))
                                    Image(systemName: "arrow.up.right").font(.system(size: 8))
                                }
                                .foregroundColor(Theme.Colors.onAccent)
                                .padding(.horizontal, 8).padding(.vertical, 4)
                                .background(Theme.Colors.cpanelOrange, in: RoundedRectangle(cornerRadius: 4))
                            }
                            .buttonStyle(.plain).focusEffectDisabled()
                        }
                    case .error(let message):
                        HStack(spacing: 6) {
                            StatusDot(color: Theme.Colors.amber, size: 6)
                            Text(message).font(.system(size: 11)).foregroundColor(Theme.Colors.text3)
                        }
                    }

                    Text(appState.strings.manualCheckOnlyNote)
                        .font(.system(size: 10)).foregroundColor(Theme.Colors.text3)
                }
                .padding(.horizontal, 12).padding(.vertical, 10)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Theme.Colors.card)

                Rectangle().fill(Theme.Colors.hairline).frame(height: 1)

                Button {
                    if let url = URL(string: "https://github.com/fr3on/panelbar") {
                        NSWorkspace.shared.open(url)
                    }
                } label: {
                    HStack {
                        Text(appState.strings.sourceCodeOnGitHub).font(.system(size: 11.5)).foregroundColor(Theme.Colors.text2)
                        Spacer()
                        Image(systemName: "arrow.up.right").font(.system(size: 10)).foregroundColor(Theme.Colors.text3)
                    }
                    .padding(.horizontal, 12).padding(.vertical, 8)
                    .background(Theme.Colors.card)
                }
                .buttonStyle(.plain).focusEffectDisabled()
            }
        }
    }

    private var footer: some View {
        HStack {
            Image(systemName: "arrow.clockwise").font(.system(size: 10))
            Text(appState.strings.changesSaveInstantly).font(.system(size: 11))
            Spacer()
            Button {
                appState.exitApp()
            } label: {
                HStack(spacing: 4) {
                    Image(systemName: "power").font(.system(size: 9, weight: .bold))
                    Text(appState.strings.quitApp).font(.system(size: 11, weight: .medium))
                }
                .foregroundColor(Theme.Colors.red)
            }
            .buttonStyle(.plain).focusEffectDisabled()
        }
        .foregroundColor(Theme.Colors.text3).padding(.horizontal, Theme.Layout.gutter).padding(.vertical, 10)
        .overlay(alignment: .top) { Rectangle().fill(Theme.Colors.hairline).frame(height: 1) }
    }
}
