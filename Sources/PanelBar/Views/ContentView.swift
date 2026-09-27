import SwiftUI
import PanelBarCore

struct ContentView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        Group {
            if let profile = appState.editingProfile {
                EditServerView(profile: profile)
            } else if let account = appState.selectedWHMAccount {
                AccountDetailView(account: account)
            } else {
                switch appState.currentView {
                case .dashboard: DashboardView()
                case .addServer: AddServerView()
                case .settings: SettingsView()
                }
            }
        }
        .frame(width: Theme.Layout.popoverWidth, height: Theme.Layout.popoverHeight, alignment: .top)
        .background(Theme.Colors.bg)
        .preferredColorScheme(colorScheme)
        .environment(\.appLanguage, appState.language)
        // Some subviews' AppKit-backed dynamic colors (see ThemeAppearanceOverride) only get
        // re-resolved when the layer they're drawn into is actually redrawn. Forcing the whole
        // tree to be rebuilt on an appearance change guarantees every one of them repaints,
        // instead of some views quietly keeping their previous appearance's cached colors.
        .id(appState.settings.appearance.rawValue)
        .background(
            // Hidden buttons providing standard macOS keyboard shortcuts when popover is open
            Group {
                Button(appState.strings.quit) { appState.exitApp() }
                    .keyboardShortcut("q", modifiers: .command)
                Button(appState.strings.settings) { appState.openSettings() }
                    .keyboardShortcut(",", modifiers: .command)
                Button(appState.strings.refresh) { Task { await appState.refreshAll() } }
                    .keyboardShortcut("r", modifiers: .command)
            }
            .opacity(0)
            .frame(width: 0, height: 0)
        )
        .onAppear { appState.isPopoverOpen = true }
        .onDisappear { appState.isPopoverOpen = false }
    }

    private var colorScheme: ColorScheme? {
        switch appState.settings.appearance {
        case .system: return nil
        case .light: return .light
        case .dark: return .dark
        }
    }
}
